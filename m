Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.248.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793805363;
	b=bjv4zMnKIYu9KlJIaSzX4GZA7KFu4ju3d3nBcygAIhUljOD//H7OCvZGuMM/KDsdmRyP
	 z2Tj3ctp92CSIwODBTigHKhpKoEcxbsfYRWAQa2egSe/ba3z6zBCV1K09ao0WlUjot7Yc
	 0yA/z0Ovc3y7jasErAC4v6vZc0fCFnsDk3whjXQLCDGqquS6K5igiiJ3uwGUVQwUvAWME
	 Q/jbuOfygHKA2p4+BGDssOIP1/v7Z+CZ5ZAlq0ijZ7/49egh8SEUDN6hDFAnzf5PZT+1o
	 LswqsFQHq2kGl2AK/iVzXtRLgbVAjBbIbwGaPo3L55nxZUagkjKW0lvm1ulwZPI1TSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793805363;
	h=DMARC-Filter:From:DKIM-Signature:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FmkxNNy+ToMepP/ABtw7xTjrpXoi59PxFvnFgDXrA8w=;
	b=Uhjzj2yag0iLakwvJdzRrzTMI0Pl5HEcq5S7/8gqXIw0tLI3ckrV3C6rn9iHvZLHYduB
	 RZrhg2CGf2xGvi7/2Z2wVMovMuBmgrtonysGufcCDdxpPg0Z0y23ywkvyDzJO43cMmMwB
	 VfnIx9i/W0K2edrrL1jeQvy7xS2Wq7aczRAM1sICwIWtTW5TXUWu9oV1Vd3D6S1ebNamr
	 GeN1QJAk6KypWHLdd8zv9ofei4f8Nes8K+rX4LncJsXN0QkYRGBa9FS7L705MEcWH3gjH
	 qlQVwEFabtlmjEiaz90SrhwDTAA1MJ/3aQ7XIw9D9aUILGBIJKGXQYNLpuS/epBQZPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=deq.rocks;
	spf=none smtp.mailfrom=deq.rocks;
	dkim=pass header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=U94boUCW;
	arc=none smtp.remote-ip=91.216.248.207
Received: from mx5.mail-out.lima-city.de (mx5.mail-out.lima-city.de [91.216.248.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29865606D834;
	Wed,  4 Nov 2026 15:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29865606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=deq.rocks header.i=@deq.rocks header.a=rsa-sha256 header.s=securedbylima-20251205 header.b=U94boUCW
From: Andre Eikmeyer <dev@deq.rocks>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1793805361;
	bh=VmecE7aJ+0JSl/7mJYiBiRErvc45KJfwgo6cIMtg5rI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U94boUCWddQzLH/dT4/hQ8ADwJK5MmqUzfQO1UGr+aOc2iMfm3pswrOGLKcJkvtwn
	 Zb1h7xyNFdhwNg9p3onvazGNzx5lx6TKxiI1UWVzR7qca2n6Dw8BWBck+PeWcXHe7T
	 STrKIdGykk4qzJq3mnbjU2c8bi/VjpxibjhO1sZUKQm66QfNuJYBvUxDS3NHgfXgXK
	 /CBPlmkMhHgnt8GDI9K9/zTWD/8yCZVibdvDATOwq1MO1v6G6EvgML3qvBd5oy95ei
	 jUPrJktvcnyY5wVpdv7uB85Ch2ZzPNv36rNfIQiMVzyRr7qfYmBL9ms9k5SSz2F1iE
	 l/9+0095/AtlQ==
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Andre Eikmeyer <dev@deq.rocks>,
	Yossef Osman <Yossef.Osman@proton.me>,
	Aditya Garg <aditya.garg@linux.dev>
Subject: [PATCH 7/7] wifi: brcmfmac: pass AWDL frames and role changes to user space
Date: Wed,  4 Nov 2026 16:15:47 +0100
Message-ID: <20261104151547.70333-8-dev@deq.rocks>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104151547.70333-1-dev@deq.rocks>
References: <20261104151547.70333-1-dev@deq.rocks>
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

User space runs the AWDL election and peer discovery from the AWDL
action frames other devices send. The firmware reports them with two
events on the AWDL interface, ACTION_FRAME_RX and AWDL_EVENT (98). A
header is in front of the frame. Its first 16 bits, high byte first,
are its version: 1 is struct brcmf_rx_mgmt_data with 16 bytes, 2 has 24
bytes. Both events come with either version. AWDL_EVENT carries a frame
only with some of its status values. AWDL_ROLE (97) reports the AWDL
role of the firmware in its status, 0 slave, 1 master not taking part
in the election and 2 master.

Register the two AWDL events when the firmware supports AWDL, so the
event mask includes them. Pass every AWDL action frame (vendor specific
category, OUI 00:17:f2, type 8) of the two events and the role changes
to user space as the vendor events AWDL_FRAME and AWDL_ROLE. Other
events of the AWDL interface are dropped as before.

Tested-by: Yossef Osman <Yossef.Osman@proton.me>
Tested-by: Aditya Garg <aditya.garg@linux.dev>
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
---
 .../broadcom/brcm80211/brcmfmac/awdl.c        | 122 +++++++++++++++++-
 .../broadcom/brcm80211/brcmfmac/awdl.h        |   4 +
 .../broadcom/brcm80211/brcmfmac/cfg80211.c    |   1 +
 .../broadcom/brcm80211/brcmfmac/fweh.c        |   8 +-
 .../broadcom/brcm80211/brcmfmac/fweh.h        |   5 +
 .../broadcom/brcm80211/brcmfmac/vendor.c      |   8 ++
 .../broadcom/brcm80211/brcmfmac/vendor.h      |  12 ++
 7 files changed, 151 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.c
index 7df77a7fdf4..c8d92e84c5a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.c
@@ -639,17 +639,125 @@ static void brcmf_awdl_settle_work(struct wiphy *wiphy,
 		       sizeof(dwell_off));
 }
 
+/*
+ * ACTION_FRAME_RX and AWDL_EVENT put a header in front of a received frame.
+ * Its first 16 bits, high byte first, are the version: 1 is struct
+ * brcmf_rx_mgmt_data with 16 bytes, 2 has 24 bytes.
+ */
+#define BRCMF_AWDL_RX_HDR_V1_LEN	16
+#define BRCMF_AWDL_RX_HDR_V2_LEN	24
+
+/* AWDL action frame: vendor specific category, Apple OUI, type AWDL */
+static const u8 brcmf_awdl_af[] = { 0x7f, 0x00, 0x17, 0xf2, 0x08 };
+
+static struct sk_buff *brcmf_awdl_event_alloc(struct brcmf_pub *drvr,
+					      int event, int len)
+{
+	struct brcmf_if *pri = brcmf_get_ifp(drvr, 0);
+
+	return cfg80211_vendor_event_alloc(drvr->wiphy,
+					   pri && pri->vif ? &pri->vif->wdev :
+							     NULL,
+					   len, event, GFP_KERNEL);
+}
+
+/**
+ * brcmf_awdl_fweh_event() - pass a firmware event of the AWDL interface on.
+ *
+ * @ifp: interface of the event.
+ * @e: event message.
+ * @data: event data.
+ *
+ * Called from the firmware event worker for the events of the AWDL
+ * interface, which do not go to the cfg80211 handlers. Received AWDL action
+ * frames and role changes become vendor events, other events are dropped.
+ * AWDL_EVENT carries an AWDL action frame with some of its status values.
+ * Return: 0 or a negative error code.
+ */
+int brcmf_awdl_fweh_event(struct brcmf_if *ifp,
+			  const struct brcmf_event_msg *e, void *data)
+{
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct sk_buff *skb;
+	u32 hdr;
+
+	if (!ifp->awdl)
+		return 0;
+
+	switch (e->event_code) {
+	case BRCMF_E_ACTION_FRAME_RX:
+	case BRCMF_E_AWDL_EVENT:
+		break;
+	case BRCMF_E_AWDL_ROLE:
+		skb = brcmf_awdl_event_alloc(drvr, BRCMF_VNDR_EVTS_AWDL_ROLE,
+					     NLMSG_DEFAULT_SIZE);
+		if (!skb)
+			return -ENOMEM;
+		if (nla_put_u32(skb, BRCMF_AWDL_ATTR_ROLE, e->status)) {
+			kfree_skb(skb);
+			return -EMSGSIZE;
+		}
+		cfg80211_vendor_event(skb, GFP_KERNEL);
+		return 0;
+	default:
+		return 0;
+	}
+
+	if (e->datalen < 2)
+		return 0;
+	switch (get_unaligned_be16(data)) {
+	case 1:
+		hdr = BRCMF_AWDL_RX_HDR_V1_LEN;
+		break;
+	case 2:
+		hdr = BRCMF_AWDL_RX_HDR_V2_LEN;
+		break;
+	default:
+		return 0;
+	}
+	if (e->datalen < hdr + sizeof(brcmf_awdl_af) ||
+	    memcmp((u8 *)data + hdr, brcmf_awdl_af, sizeof(brcmf_awdl_af)))
+		return 0;
+
+	skb = brcmf_awdl_event_alloc(drvr, BRCMF_VNDR_EVTS_AWDL_FRAME,
+				     e->datalen);
+	if (!skb)
+		return -ENOMEM;
+	if (nla_put(skb, BRCMF_AWDL_ATTR_ADDR, ETH_ALEN, e->addr) ||
+	    nla_put(skb, BRCMF_AWDL_ATTR_FRAME, e->datalen - hdr,
+		    (u8 *)data + hdr)) {
+		kfree_skb(skb);
+		return -EMSGSIZE;
+	}
+	cfg80211_vendor_event(skb, GFP_KERNEL);
+	return 0;
+}
+
+/*
+ * Registers the firmware events that only the AWDL interface reports, so the
+ * event mask includes them. The firmware runs AWDL with all of them enabled.
+ */
+void brcmf_awdl_register_events(struct brcmf_pub *drvr)
+{
+	static const enum brcmf_fweh_event_code events[] = {
+		BRCMF_E_AWDL_AW, BRCMF_E_AWDL_ROLE, BRCMF_E_AWDL_EVENT,
+		BRCMF_E_AWDL_STATS, BRCMF_E_SDB_STATE,
+	};
+	struct brcmf_if *pri = brcmf_get_ifp(drvr, 0);
+	int i;
+
+	if (!pri || !brcmf_feat_is_enabled(pri, BRCMF_FEAT_AWDL))
+		return;
+	for (i = 0; i < ARRAY_SIZE(events); i++)
+		brcmf_fweh_register(drvr, events[i], brcmf_awdl_fweh_event);
+}
+
 static void brcmf_awdl_send_result(struct brcmf_pub *drvr, int event,
 				   int status, struct net_device *ndev)
 {
-	struct brcmf_if *pri = brcmf_get_ifp(drvr, 0);
 	struct sk_buff *skb;
 
-	skb = cfg80211_vendor_event_alloc(drvr->wiphy,
-					  pri && pri->vif ? &pri->vif->wdev :
-							    NULL,
-					  NLMSG_DEFAULT_SIZE, event,
-					  GFP_KERNEL);
+	skb = brcmf_awdl_event_alloc(drvr, event, NLMSG_DEFAULT_SIZE);
 	if (!skb)
 		return;
 	if (nla_put_s32(skb, BRCMF_AWDL_ATTR_STATUS, status) ||
@@ -732,6 +840,8 @@ const struct nla_policy brcmf_awdl_vndr_policy[BRCMF_AWDL_ATTR_MAX + 1] = {
 	[BRCMF_AWDL_ATTR_IFINDEX] = { .type = NLA_REJECT },
 	[BRCMF_AWDL_ATTR_PEER_IES] = { .type = NLA_BINARY,
 				       .len = BRCMF_AWDL_PEER_IES_MAX },
+	[BRCMF_AWDL_ATTR_FRAME] = { .type = NLA_REJECT },
+	[BRCMF_AWDL_ATTR_ROLE] = { .type = NLA_REJECT },
 };
 
 /* The device of a vendor command and its parsed attributes */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.h
index 63030221dea..06c932a3c95 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/awdl.h
@@ -18,6 +18,7 @@ struct brcmf_pub;
 struct brcmf_if;
 struct net_device;
 struct sk_buff;
+struct brcmf_event_msg;
 
 enum brcmf_awdl_op {
 	BRCMF_AWDL_OP_NONE,
@@ -87,6 +88,9 @@ int brcmf_awdl_add(struct brcmf_pub *drvr, const u8 *mac,
 		   struct net_device **ndev);
 int brcmf_awdl_del(struct brcmf_pub *drvr);
 void brcmf_awdl_suspend(struct brcmf_pub *drvr);
+void brcmf_awdl_register_events(struct brcmf_pub *drvr);
+int brcmf_awdl_fweh_event(struct brcmf_if *ifp,
+			  const struct brcmf_event_msg *e, void *data);
 bool brcmf_awdl_if_added(struct brcmf_pub *drvr, struct brcmf_if *ifp);
 bool brcmf_awdl_if_removed(struct brcmf_pub *drvr, struct brcmf_if *ifp);
 int brcmf_awdl_encap(struct brcmf_if *ifp, struct sk_buff *skb);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 41ea0481cf1..cad12496173 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -7045,6 +7045,7 @@ static s32 wl_init_priv(struct brcmf_cfg80211_info *cfg)
 	if (err)
 		return err;
 	brcmf_register_event_handlers(cfg);
+	brcmf_awdl_register_events(cfg->pub);
 	mutex_init(&cfg->usr_sync);
 	brcmf_init_escan(cfg);
 	brcmf_init_conf(cfg->conf);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index 8c098029104..bd4bf205cc1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -324,11 +324,13 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			ifp = drvr->iflist[0];
 		else
 			ifp = drvr->iflist[emsg.bsscfgidx];
-		/* The AWDL interface has no vif, its events are not for
-		 * the cfg80211 handlers
+		/* The AWDL interface has no vif, its events go to user
+		 * space and not to the cfg80211 handlers
 		 */
-		if (ifp && ifp->awdl)
+		if (ifp && ifp->awdl) {
+			brcmf_awdl_fweh_event(ifp, &emsg, event->data);
 			goto event_free;
+		}
 
 		err = brcmf_fweh_call_event_handler(drvr, ifp, event->code,
 						    &emsg, event->data);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
index e327dd58d29..f8dee73cab1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.h
@@ -94,7 +94,12 @@ struct brcmf_cfg80211_info;
 	BRCMF_ENUM_DEF(FIFO_CREDIT_MAP, 74) \
 	BRCMF_ENUM_DEF(ACTION_FRAME_RX, 75) \
 	BRCMF_ENUM_DEF(TDLS_PEER_EVENT, 92) \
+	BRCMF_ENUM_DEF(AWDL_AW, 96) \
+	BRCMF_ENUM_DEF(AWDL_ROLE, 97) \
+	BRCMF_ENUM_DEF(AWDL_EVENT, 98) \
 	BRCMF_ENUM_DEF(BCMC_CREDIT_SUPPORT, 127) \
+	BRCMF_ENUM_DEF(AWDL_STATS, 150) \
+	BRCMF_ENUM_DEF(SDB_STATE, 152) \
 	BRCMF_ABSTRACT_ENUM_DEF(EXT_AUTH_REQ, 0) \
 	BRCMF_ABSTRACT_ENUM_DEF(EXT_AUTH_FRAME_RX, 1) \
 	BRCMF_ABSTRACT_ENUM_DEF(MGMT_FRAME_TXSTATUS, 2) \
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
index 5e7de07c995..aae9cd75947 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.c
@@ -193,4 +193,12 @@ const struct nl80211_vendor_cmd_info brcmf_vendor_events[] = {
 		.vendor_id = BROADCOM_OUI,
 		.subcmd = BRCMF_VNDR_EVTS_AWDL_STOPPED
 	},
+	[BRCMF_VNDR_EVTS_AWDL_FRAME] = {
+		.vendor_id = BROADCOM_OUI,
+		.subcmd = BRCMF_VNDR_EVTS_AWDL_FRAME
+	},
+	[BRCMF_VNDR_EVTS_AWDL_ROLE] = {
+		.vendor_id = BROADCOM_OUI,
+		.subcmd = BRCMF_VNDR_EVTS_AWDL_ROLE
+	},
 };
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.h
index ce7f7c46710..96009375eb7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/vendor.h
@@ -54,6 +54,11 @@ enum brcmf_vndr_cmds {
  * @BRCMF_VNDR_EVTS_AWDL_STOPPED: the AWDL interface was removed, after
  *	%BRCMF_VNDR_CMDS_AWDL_STOP or before system sleep, with
  *	%BRCMF_AWDL_ATTR_STATUS.
+ * @BRCMF_VNDR_EVTS_AWDL_FRAME: AWDL action frame received from
+ *	%BRCMF_AWDL_ATTR_ADDR, the frame body from the category on in
+ *	%BRCMF_AWDL_ATTR_FRAME.
+ * @BRCMF_VNDR_EVTS_AWDL_ROLE: the firmware changed its AWDL role to
+ *	%BRCMF_AWDL_ATTR_ROLE.
  * @BRCMF_VNDR_EVTS_LAST: number of vendor events.
  *
  * The value of an event is its index in the vendor events and its vendor
@@ -62,6 +67,8 @@ enum brcmf_vndr_cmds {
 enum brcmf_vndr_evts {
 	BRCMF_VNDR_EVTS_AWDL_STARTED,
 	BRCMF_VNDR_EVTS_AWDL_STOPPED,
+	BRCMF_VNDR_EVTS_AWDL_FRAME,
+	BRCMF_VNDR_EVTS_AWDL_ROLE,
 	BRCMF_VNDR_EVTS_LAST
 };
 
@@ -80,6 +87,9 @@ enum brcmf_vndr_evts {
  * @BRCMF_AWDL_ATTR_IFINDEX: interface index of the AWDL interface (u32).
  * @BRCMF_AWDL_ATTR_PEER_IES: HT and VHT capabilities elements of a peer,
  *	built from the AWDL TLVs it sends, as macOS passes them.
+ * @BRCMF_AWDL_ATTR_FRAME: received action frame body.
+ * @BRCMF_AWDL_ATTR_ROLE: AWDL role of the firmware (u32), 0 slave, 1 master
+ *	not taking part in the election, 2 master.
  * @BRCMF_AWDL_ATTR_MAX: highest attribute.
  */
 enum brcmf_awdl_attrs {
@@ -94,6 +104,8 @@ enum brcmf_awdl_attrs {
 	BRCMF_AWDL_ATTR_STATUS,
 	BRCMF_AWDL_ATTR_IFINDEX,
 	BRCMF_AWDL_ATTR_PEER_IES,
+	BRCMF_AWDL_ATTR_FRAME,
+	BRCMF_AWDL_ATTR_ROLE,
 
 	__BRCMF_AWDL_ATTR_AFTER_LAST,
 	BRCMF_AWDL_ATTR_MAX = __BRCMF_AWDL_ATTR_AFTER_LAST - 1
