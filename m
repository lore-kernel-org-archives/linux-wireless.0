Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=152.67.88.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793565963;
	b=hqAVrB9BuRMYLIpA/HATHywKSbuVT0CAnWIMXOQ+yK+5F1jv+cUzHkysYX9LJ70vuyrI
	 o8wTHKaMaLzLHJQV+SqsCTwGgoTRoj0OKH2nVvwPnsV6eK5w9NEtHA/qRzjvXKFyH8nCN
	 RFNoULNnk5yvmCuCwKRso09VIAMv6ZakUaCim1daDyciGGVPdSvvFuBirbWOblmIdkShc
	 BryUGIRUGw8kURpXExnlOJB8j7Fcq5IvGzGnO3dRjeiOevn+f66stMG90eor+K5ff0ij1
	 Dqdauv+g6G/Njdg8SiGvhgPZ/5HMgdzctkDqgE2PaedzZ3jmZYfy7ZpLjhuXat4K6sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793565963;
	h=DMARC-Filter:DKIM-Signature:DKIM-Signature:Message-Instance:
	 DKIM2-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+72Hg4hfGZPD1UziWjFY001haEaujPWb5AzUvnnLFYA=;
	b=f7+9YWTpf62uvjS1tEtOx3r11pKo+HIqpdyst+07q8atHSyBYlLEsPNfctobFJt5qy3C
	 6TTjgnG9dxkizUioUTrRnZGl4CroxuYWbe3Jt/3gdIgaJdM7BlPPSzMCPhAFtesrjJQZQ
	 8sIe+cpdXISBpDhCLfErdraWw4OnAo8zizv087gscT+YmeJOj0dt3r/e3d8kKhUO68Zee
	 4/CuEKya1SdKLqdPUVZv/VauHCtJ6oJsmJ1ZM6vdnXwNJ4Y+xvUA2346DJsbQeVdw9XU5
	 ORUdyPThUKBQ4rit+DEvxJwYrWV9ls1EUiXw7Ni3j4RNxYd0APnq9YTyNNvyQ4NyQhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cubiculum.net;
	spf=pass smtp.mailfrom=cubiculum.net;
	dkim=pass header.d=cubiculum.net header.i=@cubiculum.net header.a=ed25519-sha256 header.s=202501e header.b=wpjbpPtT;
	dkim=pass header.d=cubiculum.net header.i=@cubiculum.net header.a=rsa-sha256 header.s=202501r header.b=I4pBtsS9;
	arc=none smtp.remote-ip=152.67.88.11
Received: from mail.cubiculum.net (mail.cubiculum.net [152.67.88.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6594606A324
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6594606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cubiculum.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cubiculum.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass header.d=cubiculum.net header.i=@cubiculum.net header.a=ed25519-sha256 header.s=202501e header.b=wpjbpPtT;
	dkim=pass (2048-bit key, unprotected) header.d=cubiculum.net header.i=@cubiculum.net header.a=rsa-sha256 header.s=202501r header.b=I4pBtsS9
DKIM-Signature: v=1; a=ed25519-sha256; s=202501e; d=cubiculum.net; c=relaxed/relaxed; r=y;
	h=Message-ID:Date:Subject:To:From; t=1793563979; bh=+72Hg4hfGZPD1UziWjFY001
	haEaujPWb5AzUvnnLFYA=; b=wpjbpPtT1iYcb3kNgaQk14GMg2CcXDdY6XM/qC5VdtdnrFKEEo
	bYk80VWXgKN2Gy+IgxybNHSpV05yeB2s/LAQ==;
DKIM-Signature: v=1; a=rsa-sha256; s=202501r; d=cubiculum.net; c=relaxed/relaxed; r=y;
	h=Message-ID:Date:Subject:To:From; t=1793563979; bh=+72Hg4hfGZPD1UziWjFY001
	haEaujPWb5AzUvnnLFYA=; b=I4pBtsS9KPGs9im7qkFOUWHkgv8D3HOyot5ma1Xjo+Y6NHsS/P
	PWf0o7vbOk70TnC3y5YKzIWAlyy6X6Q+KA6xXStoplUKv6/t4PBgT/ESx20EyFgQHqf4AaKIYqQ
	RrDqZO6+bveaZdLgJsqEBPevwu13oIcsMtWzUhu4JMy2TXj1ZfqY2cxrMy0VdSMCOHf1fvbHqJ+
	gcRYwfY+FOwjKLzK/F2W2HLLP+E6H37qvF8B730Ge7CGSZ5KoIGEff7x9Mupahi9aCbgxLoxEPX
	fqUgeMNPV0V2WzvkIPSYVVagXavHsbeD1e8Ec09Wcx04YBxLKqWtt8VjNUm5Ju0ypHg==;
Message-Instance: m=1; h=sha256:JNOAWn+xMGQUjxEEWr0NTIxZSqclnvEr5UXc8dOT
	0pQ=:jUD1Ty3Pun5D+mFuxbvgkhOc2e/Q+db3JfMnz0J3Huo=;
DKIM2-Signature: i=1; m=1; t=1793563979; d=cubiculum.net; mf=PGtlcm5lbEBj
	dWJpY3VsdW0ubmV0Pg==; rt=PHBrc2hpaEByZWFsdGVrLmNvbT4=,PGpvaGFubmVzQHNpcHNv
	bHV0aW9ucy5uZXQ+,PGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZz4=; s=
	v2-ed25519-20260926:ed25519-sha256:hiy880lUIwpvQeid1LK1JI88GMhNLyv4b0AvYZGC
	Pj7uP74Q1FSubWCOKCzs0ZpIHa0RYiJiC6XkMfGvm7ZWCw==,v2-rsa-20260926:rsa-sha256
	:jlYEe5MNUhfEsmT7SB37deGfaEwJeSxNl6H1WZGd0VNS0il8AbOq6BMt30N14d10fceF92oT
	VJZAGeiLjvzML84JIAFPKoin+WQuX/ck9o6JGrbtyiJV5Nz300ALFBl2yOLoeY3Qnmu3edvQ
	kSjwSieYwm5vxapCxhxaNGZ23Wxpnq0cqGJNJeP9g5zfSQCQ9gGJxCRFmCS57TLgfLNtFsrd
	y0kfSq5GQveNkmJzfBsFtsGEeHrfoCUqZFLijX46ns8KhCa1GoCGHyXO+kdG29hQUFUs0o9C
	OZV1U3HFYvZQ7CjAxPasGpHhSlj1HBHAAahfBjFoyn9upq+jYHIflg==;
From: rcfa <kernel@cubiculum.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH wireless] wifi: mac80211: deauthenticate on stop if an association just completed
Date: Sun,  1 Nov 2026 20:12:51 +0000
Message-ID: <20261101201251.1106968-1-kernel@cubiculum.net>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an interface goes down, cfg80211_leave() runs on NETDEV_GOING_DOWN
and disconnects if the interface is connected. An association that
userspace started (NL80211_CMD_ASSOCIATE) and that is still in progress
is left to mac80211, and ieee80211_mgd_stop() abandons it later, from
ndo_stop. In between, the wiphy lock is not held and SDATA_STATE_RUNNING
is still set, so the association response can still be processed and
the association succeeds. ieee80211_do_stop() then goes on with an
associated interface: sta_info_flush() removes the AP station and the
WARN_ON_ONCE() on its result fires, an MLD also warns "destroying
interface with valid links", and the interface is removed from the
driver while its links still have channel contexts, which are never
unassigned.

ieee80211_mgd_quiesce() has worked around the same race for suspend
since commit be72afe0a438 ("mac80211: fix another suspend vs.
association race"), by deauthenticating if the interface is associated
by then. Do the same in ieee80211_mgd_stop(). When it runs,
SDATA_STATE_RUNNING is clear and the wiphy lock is held, so no further
association response can be processed.

The window opened when cfg80211 stopped tracking authentication state:
until then, cfg80211_mlme_down() also deauthenticated from BSSes that
were authenticated but not yet associated, which aborted an association
in progress.

This was seen with an RTL8922AU (rtw89, USB) on Linux 7.1.5 and
wpa_supplicant 2.11 associating by MLO to an AP MLD, when NetworkManager
took the interface down to change its MAC address for a scan in the
same second as the association completed:

  wlan0: associated
  WARNING: net/mac80211/iface.c:536 at ieee80211_do_stop+0x8e9/0xb50 [mac80211]
  Call Trace:
   ieee80211_stop
   __dev_close_many
   __dev_change_flags
   netif_change_flags
   do_setlink
   rtnl_newlink
  destroying interface with valid links 0x0002
  WARNING: net/mac80211/iface.c:563 at ieee80211_do_stop+0x9d8/0xb50 [mac80211]

rtw89 then kept the interface on its channel manager's active list, and
its next scan looped forever with the wiphy lock held, which hung RTNL.
That is being fixed in rtw89 separately.

Timing alone did not reproduce the race (0 of 29 attempts), so its end
state was reproduced with a test-only hook in ieee80211_deauth() that
ignores the next WLAN_REASON_DEAUTH_LEAVING request, which leaves the
interface associated when ndo_stop runs (rtw89 had its own fix in both
runs). Without this change, the
second round warned as above, then in ieee80211_prep_connection(),
ieee80211_set_disassoc() and cfg80211_process_disassoc(), and ended in
a NULL pointer dereference in ieee80211_rx_mgmt_beacon(). With it, both
of 2 rounds deauthenticated on stop ("deauthenticating from ... by local
choice (Reason: 3=DEAUTH_LEAVING)"), with no warning or oops, and the
interface reconnected.

The problem was found with Claude Code (Claude Opus 5.5) while analysing
that hang, and this change and changelog were written in the same
session.

Fixes: 95de817b9034 ("cfg80211: stop tracking authenticated state")
Signed-off-by: rcfa <kernel@cubiculum.net>
---

Notes:
    Testing: the results above are from Linux 7.1.5 (Kali 7.1.5-1kali1)
    with this change applied to its mac80211. This port to wireless/main
    differs only in context and has been compile-tested only: x86_64
    allmodconfig with gcc 16.2 (CONFIG_WERROR=y), net/mac80211/ with and
    without W=1, and sparse on mlme.c, with no new warnings. The test-only
    hook and the script that drives it are available on request.
    
    The rtw89 side is posted separately, for rtw-next:
    "wifi: rtw89: take the interface off the active list when removing it"

 net/mac80211/mlme.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3c31c16860ab..5791d5b5fe86 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -10838,6 +10838,25 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 	wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy,
 				  &ifmgd->uhr_omp.status_work);
 
+	/*
+	 * As in ieee80211_mgd_quiesce(): cfg80211 cannot abort an ongoing
+	 * association when it disconnects on NETDEV_GOING_DOWN, so the
+	 * association response may still have been processed before we got
+	 * here. Deauthenticate if the association succeeded, rather than
+	 * remove the interface from the driver with the AP station, links
+	 * and channel contexts still in place.
+	 */
+	if (ifmgd->associated) {
+		u8 bssid[ETH_ALEN];
+		struct cfg80211_deauth_request req = {
+			.reason_code = WLAN_REASON_DEAUTH_LEAVING,
+			.bssid = bssid,
+		};
+
+		memcpy(bssid, sdata->vif.cfg.ap_addr, ETH_ALEN);
+		ieee80211_mgd_deauth(sdata, &req);
+	}
+
 	if (ifmgd->assoc_data)
 		ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT, NULL);
 	if (ifmgd->auth_data)

base-commit: 25e73f1d6868c759c8eb56cad4e411692c5341b4
-- 
2.53.0

