Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="GDz7QVhZ"
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4B61994;
	Fri,  1 Dec 2023 02:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=gCYgYqHnTsuL1EhCdX4RcAVkG0NIh0eg2vdMmu8RzJg=;
	t=1701427798; x=1702637398; b=GDz7QVhZ/FEw4V807vi0uoSEJxQi10jHgfWBrqKBvsYsl6k
	6JoQcpR0vHAq/5zUd/JOlfLhUfmf5nRtiDrObBiTRTcNkhHMgWXtEM1bEEXQzHxrrFiGSNPF9tL6k
	TWeTeg+k1GjwPQ0Z400tPx8KnF2yLFZj8Tm4DA0LojpzHUo96+FrG0/SijMz1EZM34D9J9EpgKDuS
	Ia3ClOa0Cou1aj/CzH6IFaPSx7rl0SjtNnJoSt2wnTgNE2DDDI7IsWmfyNE2t9E8f4Pzi0+Q0ikMt
	BdUUbwMqgtR4n1ukAyoAtTWZCAVRFod+jHtV0oaE1TEwxdGBcKmVK0EyIqSnuY8Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.97)
	(envelope-from <johannes@sipsolutions.net>)
	id 1r915n-0000000BBjV-15Ek;
	Fri, 01 Dec 2023 11:49:55 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: hostap@lists.infradead.org,
	netdev@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wpa_suppplicant 1/2] netlink: add netlink_process_one_event()
Date: Fri,  1 Dec 2023 11:49:08 +0100
Message-ID: <20231201114952.c278cb7ac0c4.If32fddf88f23f3939bb73bc6926aad7f88804079@changeid>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231201104952.26254-4-johannes@sipsolutions.net>
References: <346b21d87c69f817ea3c37caceb34f1f56255884.camel@sipsolutions.net>
 <20231201104952.26254-4-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Add a new function to read and process a single netlink event
with a timeout, to be used in driver_nl80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 src/drivers/netlink.c | 43 +++++++++++++++++++++++++++++++++++++++----
 src/drivers/netlink.h |  2 ++
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/src/drivers/netlink.c b/src/drivers/netlink.c
index 7780479c3e91..bbfe86eee7a0 100644
--- a/src/drivers/netlink.c
+++ b/src/drivers/netlink.c
@@ -33,19 +33,20 @@ static void netlink_receive_link(struct netlink_data *netlink,
 }
 
 
-static void netlink_receive(int sock, void *eloop_ctx, void *sock_ctx)
+static void _netlink_process_one_event(struct netlink_data *netlink,
+				       int wait_single)
 {
-	struct netlink_data *netlink = eloop_ctx;
 	char buf[8192];
 	int left;
 	struct sockaddr_nl from;
 	socklen_t fromlen;
 	struct nlmsghdr *h;
-	int max_events = 10;
+	int max_events = wait_single ? 1 : 10;
 
 try_again:
 	fromlen = sizeof(from);
-	left = recvfrom(sock, buf, sizeof(buf), MSG_DONTWAIT,
+	left = recvfrom(netlink->sock, buf, sizeof(buf),
+			wait_single ? 0 : MSG_DONTWAIT,
 			(struct sockaddr *) &from, &fromlen);
 	if (left < 0) {
 		if (errno != EINTR && errno != EAGAIN)
@@ -88,6 +89,40 @@ try_again:
 }
 
 
+void netlink_process_one_event(struct netlink_data *netlink,
+			       unsigned int timeout_ms)
+{
+	if (timeout_ms) {
+		struct timeval timeout = {
+			.tv_sec = timeout_ms / 1000,
+			.tv_usec = 1000 * (timeout_ms % 1000),
+		};
+		fd_set read_set;
+		int ret;
+
+		FD_ZERO(&read_set);
+		FD_SET(netlink->sock, &read_set);
+
+		ret = select(netlink->sock + 1, &read_set, NULL, NULL,
+			     &timeout);
+		if (ret < 0) {
+			perror("select on netlink socket");
+			return;
+		}
+		if (ret == 0)
+			return;
+	}
+
+	_netlink_process_one_event(netlink, 1);
+}
+
+
+static void netlink_receive(int sock, void *eloop_ctx, void *sock_ctx)
+{
+	_netlink_process_one_event(eloop_ctx, 0);
+}
+
+
 struct netlink_data * netlink_init(struct netlink_config *cfg)
 {
 	struct netlink_data *netlink;
diff --git a/src/drivers/netlink.h b/src/drivers/netlink.h
index 3a7340e51534..faee28b722ea 100644
--- a/src/drivers/netlink.h
+++ b/src/drivers/netlink.h
@@ -21,6 +21,8 @@ struct netlink_config {
 };
 
 struct netlink_data * netlink_init(struct netlink_config *cfg);
+void netlink_process_one_event(struct netlink_data *netlink,
+			       unsigned int timeout_ms);
 void netlink_deinit(struct netlink_data *netlink);
 int netlink_send_oper_ifla(struct netlink_data *netlink, int ifindex,
 			   int linkmode, int operstate);
-- 
2.43.0

