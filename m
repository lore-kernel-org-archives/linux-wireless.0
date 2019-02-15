Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA72CC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 06:44:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 681462192C
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 06:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oI2FA9iI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbfBOGoG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 01:44:06 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39861 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfBOGoF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 01:44:05 -0500
Received: by mail-lf1-f65.google.com with SMTP id m11so6370569lfc.6
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 22:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XtfTzJ1rRcoXCBPJDCX2UWCN/wCvP+88VtlwcK3jZ/o=;
        b=oI2FA9iInDmEeHJzDvxC1vxNCPmyuEOlSMJAGPYw5Ag1iPPKOA9BT0BW2vIvwk3grj
         bmMvI5BJDegPbcCtPtnd+ep9JjoJpbGf/VnLvmyO4nVHFUtDTF/EogujFssH5OGsuPq9
         3Gif2GPx/xRl41qFKNppcx2onAZArJlLgi5kpl+Xz3t0kBnKaYSX3+gTTRGMerxWdaep
         Vc0IbQsDitRF66Ykdj0Ry0DfBMuO/xhWaX6m9GNtKDv5iDhZQ8mCe17j6D+yxvpQGyKb
         6ri7k1vf0VZp7WlRAl1feXpZ5E18MOP7Ehz+3VxlROFIUhiogj/FvVcqhChtpPxLlJx5
         0pxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XtfTzJ1rRcoXCBPJDCX2UWCN/wCvP+88VtlwcK3jZ/o=;
        b=DsOU1lbhFPEtnJ+uXAb5iqmmLnpnz07r0fOS8hoNeXNLa8lnKWWCCJSvJ6CNy7wEIa
         ARKqv+lzSSJxFnMLRW4l6asGEYkI1tdV2N6GH3gCYtb/7iSeJhA7F8eJmO/nE5NAgeLh
         VNKdGZC3dCAgWjyueaDgzdqoa6fJXkj8HKHLUTiBAs/yHXKGvbD/m+6BcZ6r2OH9ADxh
         IPsR3VksxI2Ji+V6LBIWZQ2y0iFWQaDt1MD4MOkXaUMSQjwwu31hkP9o48YAd1TNnASi
         6HT/inLE53I4FxBiRpkj7ZFz8kxUcsFGpLn005Tgq93Ni/gg7y5zyX4/WCV7p+x6GMxk
         dJAQ==
X-Gm-Message-State: AHQUAuZdVgxKhFb1cQkT9TbsU0RqFHV8dNCN2z+lrn84kOdAzcqhZduY
        r4OANo+uH4dbdq5+ASNVaoM=
X-Google-Smtp-Source: AHgI3IZptWvefj4ESsXZo+vuhh/J6DLbQkKzbC9t5cGdrHvdLXui4dKEtoHIUzkU/Hn4h1Zx6yxfVg==
X-Received: by 2002:a19:ee13:: with SMTP id g19mr4490003lfb.72.1550213037392;
        Thu, 14 Feb 2019 22:43:57 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id e72sm1027903lfg.48.2019.02.14.22.43.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 22:43:56 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3] brcmfmac: use bphy_err() in all wiphy-related code
Date:   Fri, 15 Feb 2019 07:43:45 +0100
Message-Id: <20190215064345.11946-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214125758.11943-1-zajec5@gmail.com>
References: <20190214125758.11943-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This recently added macro provides more meaningful error messages thanks
to identifying a specific wiphy. It's especially important on systems
with few cards supported by the same (brcmfmac) driver.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
V2: Fix one line over 80 chars
V3: Pass drvr to the brcmf_fweh_call_event_handler() to make getting
    wiphy 100% reliable
---
 .../broadcom/brcm80211/brcmfmac/bcdc.c        | 26 +++---
 .../broadcom/brcm80211/brcmfmac/common.c      | 38 +++++----
 .../broadcom/brcm80211/brcmfmac/core.c        | 79 ++++++++++-------
 .../broadcom/brcm80211/brcmfmac/feature.c     |  6 +-
 .../broadcom/brcm80211/brcmfmac/fweh.c        | 32 ++++---
 .../broadcom/brcm80211/brcmfmac/fwil.c        | 15 ++--
 .../broadcom/brcm80211/brcmfmac/fwsignal.c    | 36 +++++---
 .../broadcom/brcm80211/brcmfmac/msgbuf.c      | 65 ++++++++------
 .../broadcom/brcm80211/brcmfmac/p2p.c         | 85 +++++++++++--------
 .../broadcom/brcm80211/brcmfmac/pno.c         | 22 +++--
 .../broadcom/brcm80211/brcmfmac/proto.c       |  7 +-
 11 files changed, 247 insertions(+), 164 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 1068a2a4494c..9291dd7f6c56 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -169,6 +169,7 @@ brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
+	struct wiphy *wiphy = drvr->wiphy;
 	void *info;
 	int ret = 0, retries = 0;
 	u32 id, flags;
@@ -178,8 +179,8 @@ brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	*fwerr = 0;
 	ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, false);
 	if (ret < 0) {
-		brcmf_err("brcmf_proto_bcdc_msg failed w/status %d\n",
-			  ret);
+		bphy_err(wiphy, "brcmf_proto_bcdc_msg failed w/status %d\n",
+			 ret);
 		goto done;
 	}
 
@@ -195,9 +196,9 @@ brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	if ((id < bcdc->reqid) && (++retries < RETRIES))
 		goto retry;
 	if (id != bcdc->reqid) {
-		brcmf_err("%s: unexpected request id %d (expected %d)\n",
-			  brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
-			  bcdc->reqid);
+		bphy_err(wiphy, "%s: unexpected request id %d (expected %d)\n",
+			 brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
+			 bcdc->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -227,6 +228,7 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 {
 	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 	struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
+	struct wiphy *wiphy = drvr->wiphy;
 	int ret;
 	u32 flags, id;
 
@@ -245,9 +247,9 @@ brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	id = (flags & BCDC_DCMD_ID_MASK) >> BCDC_DCMD_ID_SHIFT;
 
 	if (id != bcdc->reqid) {
-		brcmf_err("%s: unexpected request id %d (expected %d)\n",
-			  brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
-			  bcdc->reqid);
+		bphy_err(wiphy, "%s: unexpected request id %d (expected %d)\n",
+			 brcmf_ifname(brcmf_get_ifp(drvr, ifidx)), id,
+			 bcdc->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -290,6 +292,7 @@ static int
 brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 			 struct sk_buff *pktbuf, struct brcmf_if **ifp)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_proto_bcdc_header *h;
 	struct brcmf_if *tmp_if;
 
@@ -312,8 +315,8 @@ brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 	}
 	if (((h->flags & BCDC_FLAG_VER_MASK) >> BCDC_FLAG_VER_SHIFT) !=
 	    BCDC_PROTO_VER) {
-		brcmf_err("%s: non-BCDC packet received, flags 0x%x\n",
-			  brcmf_ifname(tmp_if), h->flags);
+		bphy_err(wiphy, "%s: non-BCDC packet received, flags 0x%x\n",
+			 brcmf_ifname(tmp_if), h->flags);
 		return -EBADE;
 	}
 
@@ -452,6 +455,7 @@ static void brcmf_proto_bcdc_debugfs_create(struct brcmf_pub *drvr)
 
 int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_bcdc *bcdc;
 
 	bcdc = kzalloc(sizeof(*bcdc), GFP_ATOMIC);
@@ -460,7 +464,7 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&bcdc->msg + 1) != (unsigned long)bcdc->buf) {
-		brcmf_err("struct brcmf_proto_bcdc is not correctly defined\n");
+		bphy_err(wiphy, "struct brcmf_proto_bcdc is not correctly defined\n");
 		goto fail;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index c62009a06617..102b2d8412d0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -90,6 +90,7 @@ struct brcmf_mp_global_t brcmf_mp_global;
 
 void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_join_pref_params join_pref_params[2];
 	int err;
 
@@ -106,7 +107,7 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_set(ifp, "join_pref", join_pref_params,
 				       sizeof(join_pref_params));
 	if (err)
-		brcmf_err("Set join_pref error (%d)\n", err);
+		bphy_err(wiphy, "Set join_pref error (%d)\n", err);
 }
 
 static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
@@ -130,6 +131,7 @@ static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 {
 	struct brcmf_bus *bus = ifp->drvr->bus_if;
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_dload_data_le *chunk_buf;
 	const struct firmware *clm = NULL;
 	u8 clm_name[BRCMF_FW_NAME_LEN];
@@ -145,7 +147,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 	memset(clm_name, 0, sizeof(clm_name));
 	err = brcmf_bus_get_fwname(bus, ".clm_blob", clm_name);
 	if (err) {
-		brcmf_err("get CLM blob file name failed (%d)\n", err);
+		bphy_err(wiphy, "get CLM blob file name failed (%d)\n", err);
 		return err;
 	}
 
@@ -182,12 +184,13 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 	} while ((datalen > 0) && (err == 0));
 
 	if (err) {
-		brcmf_err("clmload (%zu byte file) failed (%d); ",
-			  clm->size, err);
+		bphy_err(wiphy, "clmload (%zu byte file) failed (%d)\n",
+			 clm->size, err);
 		/* Retrieve clmload_status and print */
 		err = brcmf_fil_iovar_int_get(ifp, "clmload_status", &status);
 		if (err)
-			brcmf_err("get clmload_status failed (%d)\n", err);
+			bphy_err(wiphy, "get clmload_status failed (%d)\n",
+				 err);
 		else
 			brcmf_dbg(INFO, "clmload_status=%d\n", status);
 		err = -EIO;
@@ -201,6 +204,7 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	u8 buf[BRCMF_DCMD_SMLEN];
 	struct brcmf_bus *bus;
@@ -214,7 +218,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
 				       sizeof(ifp->mac_addr));
 	if (err < 0) {
-		brcmf_err("Retrieving cur_etheraddr failed, %d\n", err);
+		bphy_err(wiphy, "Retrieving cur_etheraddr failed, %d\n", err);
 		goto done;
 	}
 	memcpy(ifp->drvr->wiphy->perm_addr, ifp->drvr->mac, ETH_ALEN);
@@ -226,7 +230,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_REVINFO,
 				     &revinfo, sizeof(revinfo));
 	if (err < 0) {
-		brcmf_err("retrieving revision info failed, %d\n", err);
+		bphy_err(wiphy, "retrieving revision info failed, %d\n", err);
 		strlcpy(ri->chipname, "UNKNOWN", sizeof(ri->chipname));
 	} else {
 		ri->vendorid = le32_to_cpu(revinfo.vendorid);
@@ -260,7 +264,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	/* Do any CLM downloading */
 	err = brcmf_c_process_clm_blob(ifp);
 	if (err < 0) {
-		brcmf_err("download CLM blob file failed, %d\n", err);
+		bphy_err(wiphy, "download CLM blob file failed, %d\n", err);
 		goto done;
 	}
 
@@ -269,8 +273,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	strcpy(buf, "ver");
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
 	if (err < 0) {
-		brcmf_err("Retrieving version information failed, %d\n",
-			  err);
+		bphy_err(wiphy, "Retrieving version information failed, %d\n",
+			 err);
 		goto done;
 	}
 	ptr = (char *)buf;
@@ -304,7 +308,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	/* set mpc */
 	err = brcmf_fil_iovar_int_set(ifp, "mpc", 1);
 	if (err) {
-		brcmf_err("failed setting mpc\n");
+		bphy_err(wiphy, "failed setting mpc\n");
 		goto done;
 	}
 
@@ -314,14 +318,14 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_get(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_err("Get event_msgs error (%d)\n", err);
+		bphy_err(wiphy, "Get event_msgs error (%d)\n", err);
 		goto done;
 	}
 	setbit(eventmask, BRCMF_E_IF);
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs", eventmask,
 				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
-		brcmf_err("Set event_msgs error (%d)\n", err);
+		bphy_err(wiphy, "Set event_msgs error (%d)\n", err);
 		goto done;
 	}
 
@@ -329,8 +333,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 				    BRCMF_DEFAULT_SCAN_CHANNEL_TIME);
 	if (err) {
-		brcmf_err("BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
-			  err);
+		bphy_err(wiphy, "BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
+			 err);
 		goto done;
 	}
 
@@ -338,8 +342,8 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 				    BRCMF_DEFAULT_SCAN_UNASSOC_TIME);
 	if (err) {
-		brcmf_err("BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
-			  err);
+		bphy_err(wiphy, "BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
+			 err);
 		goto done;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index e772c0845638..3174edce748a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -86,11 +86,12 @@ char *brcmf_ifname(struct brcmf_if *ifp)
 
 struct brcmf_if *brcmf_get_ifp(struct brcmf_pub *drvr, int ifidx)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_if *ifp;
 	s32 bsscfgidx;
 
 	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("ifidx %d out of range\n", ifidx);
+		bphy_err(wiphy, "ifidx %d out of range\n", ifidx);
 		return NULL;
 	}
 
@@ -141,7 +142,9 @@ void brcmf_configure_arp_nd_offload(struct brcmf_if *ifp, bool enable)
 
 static void _brcmf_set_multicast_list(struct work_struct *work)
 {
-	struct brcmf_if *ifp;
+	struct brcmf_if *ifp = container_of(work, struct brcmf_if,
+					    multicast_work);
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct net_device *ndev;
 	struct netdev_hw_addr *ha;
 	u32 cmd_value, cnt;
@@ -150,8 +153,6 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	u32 buflen;
 	s32 err;
 
-	ifp = container_of(work, struct brcmf_if, multicast_work);
-
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
 	ndev = ifp->ndev;
@@ -181,7 +182,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 
 	err = brcmf_fil_iovar_data_set(ifp, "mcast_list", buf, buflen);
 	if (err < 0) {
-		brcmf_err("Setting mcast_list failed, %d\n", err);
+		bphy_err(wiphy, "Setting mcast_list failed, %d\n", err);
 		cmd_value = cnt ? true : cmd_value;
 	}
 
@@ -194,14 +195,14 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	 */
 	err = brcmf_fil_iovar_int_set(ifp, "allmulti", cmd_value);
 	if (err < 0)
-		brcmf_err("Setting allmulti failed, %d\n", err);
+		bphy_err(wiphy, "Setting allmulti failed, %d\n", err);
 
 	/*Finally, pick up the PROMISC flag */
 	cmd_value = (ndev->flags & IFF_PROMISC) ? true : false;
 	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_PROMISC, cmd_value);
 	if (err < 0)
-		brcmf_err("Setting BRCMF_C_SET_PROMISC failed, %d\n",
-			  err);
+		bphy_err(wiphy, "Setting BRCMF_C_SET_PROMISC failed, %d\n",
+			 err);
 	brcmf_configure_arp_nd_offload(ifp, !cmd_value);
 }
 
@@ -209,9 +210,11 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 static void _brcmf_update_ndtable(struct work_struct *work)
 {
 	struct brcmf_if *ifp;
+	struct wiphy *wiphy;
 	int i, ret;
 
 	ifp = container_of(work, struct brcmf_if, ndoffload_work);
+	wiphy = ifp->drvr->wiphy;
 
 	/* clear the table in firmware */
 	ret = brcmf_fil_iovar_data_set(ifp, "nd_hostip_clear", NULL, 0);
@@ -225,7 +228,7 @@ static void _brcmf_update_ndtable(struct work_struct *work)
 					       &ifp->ipv6_addr_tbl[i],
 					       sizeof(struct in6_addr));
 		if (ret)
-			brcmf_err("add nd ip err %d\n", ret);
+			bphy_err(wiphy, "add nd ip err %d\n", ret);
 	}
 }
 #else
@@ -237,6 +240,7 @@ static void _brcmf_update_ndtable(struct work_struct *work)
 static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct sockaddr *sa = (struct sockaddr *)addr;
 	int err;
 
@@ -245,7 +249,7 @@ static int brcmf_netdev_set_mac_address(struct net_device *ndev, void *addr)
 	err = brcmf_fil_iovar_data_set(ifp, "cur_etheraddr", sa->sa_data,
 				       ETH_ALEN);
 	if (err < 0) {
-		brcmf_err("Setting cur_etheraddr failed, %d\n", err);
+		bphy_err(wiphy, "Setting cur_etheraddr failed, %d\n", err);
 	} else {
 		brcmf_dbg(TRACE, "updated to %pM\n", sa->sa_data);
 		memcpy(ifp->mac_addr, sa->sa_data, ETH_ALEN);
@@ -298,6 +302,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 	int ret;
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
 	struct ethhdr *eh;
 	int head_delta;
 
@@ -305,7 +310,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 
 	/* Can the device send data? */
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("xmit rejected state=%d\n", drvr->bus_if->state);
+		bphy_err(wiphy, "xmit rejected state=%d\n",
+			 drvr->bus_if->state);
 		netif_stop_queue(ndev);
 		dev_kfree_skb(skb);
 		ret = -ENODEV;
@@ -339,8 +345,8 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		ret = pskb_expand_head(skb, ALIGN(head_delta, NET_SKB_PAD), 0,
 				       GFP_ATOMIC);
 		if (ret < 0) {
-			brcmf_err("%s: failed to expand headroom\n",
-				  brcmf_ifname(ifp));
+			bphy_err(wiphy, "%s: failed to expand headroom\n",
+				 brcmf_ifname(ifp));
 			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
 			goto done;
 		}
@@ -600,13 +606,14 @@ static int brcmf_netdev_open(struct net_device *ndev)
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_pub *drvr = ifp->drvr;
 	struct brcmf_bus *bus_if = drvr->bus_if;
+	struct wiphy *wiphy = drvr->wiphy;
 	u32 toe_ol;
 
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d\n", ifp->bsscfgidx);
 
 	/* If bus is not ready, can't continue */
 	if (bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("failed bus is not ready\n");
+		bphy_err(wiphy, "failed bus is not ready\n");
 		return -EAGAIN;
 	}
 
@@ -620,7 +627,7 @@ static int brcmf_netdev_open(struct net_device *ndev)
 		ndev->features &= ~NETIF_F_IP_CSUM;
 
 	if (brcmf_cfg80211_up(ndev)) {
-		brcmf_err("failed to bring up cfg80211\n");
+		bphy_err(wiphy, "failed to bring up cfg80211\n");
 		return -EIO;
 	}
 
@@ -640,6 +647,7 @@ static const struct net_device_ops brcmf_netdev_ops_pri = {
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
 	struct net_device *ndev;
 	s32 err;
 
@@ -665,7 +673,7 @@ int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked)
 	else
 		err = register_netdev(ndev);
 	if (err != 0) {
-		brcmf_err("couldn't register the net device\n");
+		bphy_err(wiphy, "couldn't register the net device\n");
 		goto fail;
 	}
 
@@ -742,6 +750,7 @@ static const struct net_device_ops brcmf_netdev_ops_p2p = {
 
 static int brcmf_net_p2p_attach(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct net_device *ndev;
 
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d mac=%pM\n", ifp->bsscfgidx,
@@ -754,7 +763,7 @@ static int brcmf_net_p2p_attach(struct brcmf_if *ifp)
 	memcpy(ndev->dev_addr, ifp->mac_addr, ETH_ALEN);
 
 	if (register_netdev(ndev) != 0) {
-		brcmf_err("couldn't register the p2p net device\n");
+		bphy_err(wiphy, "couldn't register the p2p net device\n");
 		goto fail;
 	}
 
@@ -771,6 +780,7 @@ static int brcmf_net_p2p_attach(struct brcmf_if *ifp)
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 			      bool is_p2pdev, const char *name, u8 *mac_addr)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
 
@@ -783,8 +793,8 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 	 */
 	if (ifp) {
 		if (ifidx) {
-			brcmf_err("ERROR: netdev:%s already exists\n",
-				  ifp->ndev->name);
+			bphy_err(wiphy, "ERROR: netdev:%s already exists\n",
+				 ifp->ndev->name);
 			netif_stop_queue(ifp->ndev);
 			brcmf_net_detach(ifp->ndev, false);
 			drvr->iflist[bsscfgidx] = NULL;
@@ -837,12 +847,13 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bsscfgidx, s32 ifidx,
 static void brcmf_del_if(struct brcmf_pub *drvr, s32 bsscfgidx,
 			 bool rtnl_locked)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_if *ifp;
 
 	ifp = drvr->iflist[bsscfgidx];
 	drvr->iflist[bsscfgidx] = NULL;
 	if (!ifp) {
-		brcmf_err("Null interface, bsscfgidx=%d\n", bsscfgidx);
+		bphy_err(wiphy, "Null interface, bsscfgidx=%d\n", bsscfgidx);
 		return;
 	}
 	brcmf_dbg(TRACE, "Enter, bsscfgidx=%d, ifidx=%d\n", bsscfgidx,
@@ -892,16 +903,17 @@ static int brcmf_psm_watchdog_notify(struct brcmf_if *ifp,
 				     const struct brcmf_event_msg *evtmsg,
 				     void *data)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	int err;
 
 	brcmf_dbg(TRACE, "enter: bsscfgidx=%d\n", ifp->bsscfgidx);
 
-	brcmf_err("PSM's watchdog has fired!\n");
+	bphy_err(wiphy, "PSM's watchdog has fired!\n");
 
 	err = brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
 					 evtmsg->datalen);
 	if (err)
-		brcmf_err("Failed to get memory dump, %d\n", err);
+		bphy_err(wiphy, "Failed to get memory dump, %d\n", err);
 
 	return err;
 }
@@ -913,6 +925,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 {
 	struct brcmf_pub *drvr = container_of(nb, struct brcmf_pub,
 					      inetaddr_notifier);
+	struct wiphy *wiphy = drvr->wiphy;
 	struct in_ifaddr *ifa = data;
 	struct net_device *ndev = ifa->ifa_dev->dev;
 	struct brcmf_if *ifp;
@@ -945,7 +958,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 	ret = brcmf_fil_iovar_data_get(ifp, "arp_hostip", addr_table,
 				       sizeof(addr_table));
 	if (ret) {
-		brcmf_err("fail to get arp ip table err:%d\n", ret);
+		bphy_err(wiphy, "fail to get arp ip table err:%d\n", ret);
 		return NOTIFY_OK;
 	}
 
@@ -962,7 +975,7 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 			ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip",
 				&ifa->ifa_address, sizeof(ifa->ifa_address));
 			if (ret)
-				brcmf_err("add arp ip err %d\n", ret);
+				bphy_err(wiphy, "add arp ip err %d\n", ret);
 		}
 		break;
 	case NETDEV_DOWN:
@@ -974,8 +987,8 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 			ret = brcmf_fil_iovar_data_set(ifp, "arp_hostip_clear",
 						       NULL, 0);
 			if (ret) {
-				brcmf_err("fail to clear arp ip table err:%d\n",
-					  ret);
+				bphy_err(wiphy, "fail to clear arp ip table err:%d\n",
+					 ret);
 				return NOTIFY_OK;
 			}
 			for (i = 0; i < ARPOL_MAX_ENTRIES; i++) {
@@ -985,8 +998,8 @@ static int brcmf_inetaddr_changed(struct notifier_block *nb,
 							       &addr_table[i],
 							       sizeof(addr_table[i]));
 				if (ret)
-					brcmf_err("add arp ip err %d\n",
-						  ret);
+					bphy_err(wiphy, "add arp ip err %d\n",
+						 ret);
 			}
 		}
 		break;
@@ -1084,6 +1097,7 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 {
 	int ret = -1;
 	struct brcmf_bus *bus_if = drvr->bus_if;
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_if *ifp;
 	struct brcmf_if *p2p_ifp;
 
@@ -1159,7 +1173,7 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 	return 0;
 
 fail:
-	brcmf_err("failed: %d\n", ret);
+	bphy_err(wiphy, "failed: %d\n", ret);
 	if (drvr->config) {
 		brcmf_cfg80211_detach(drvr->config);
 		drvr->config = NULL;
@@ -1211,7 +1225,7 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 	/* Attach and link in the protocol */
 	ret = brcmf_proto_attach(drvr);
 	if (ret != 0) {
-		brcmf_err("brcmf_prot_attach failed\n");
+		bphy_err(wiphy, "brcmf_prot_attach failed\n");
 		goto fail;
 	}
 
@@ -1224,7 +1238,7 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 
 	ret = brcmf_bus_started(drvr, ops);
 	if (ret != 0) {
-		brcmf_err("dongle is not responding: err=%d\n", ret);
+		bphy_err(wiphy, "dongle is not responding: err=%d\n", ret);
 		goto fail;
 	}
 
@@ -1324,6 +1338,7 @@ static int brcmf_get_pend_8021x_cnt(struct brcmf_if *ifp)
 
 int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	int err;
 
 	err = wait_event_timeout(ifp->pend_8021x_wait,
@@ -1331,7 +1346,7 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 				 MAX_WAIT_FOR_8021X_TX);
 
 	if (!err)
-		brcmf_err("Timed out waiting for no pending 802.1x packets\n");
+		bphy_err(wiphy, "Timed out waiting for no pending 802.1x packets\n");
 
 	return !err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index b91b7ecbfedf..8e08d23b48ff 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -185,13 +185,14 @@ static void brcmf_feat_iovar_data_set(struct brcmf_if *ifp,
 #define MAX_CAPS_BUFFER_SIZE	768
 static void brcmf_feat_firmware_capabilities(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	char caps[MAX_CAPS_BUFFER_SIZE];
 	enum brcmf_feat_id id;
 	int i, err;
 
 	err = brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
 	if (err) {
-		brcmf_err("could not get firmware cap (%d)\n", err);
+		bphy_err(wiphy, "could not get firmware cap (%d)\n", err);
 		return;
 	}
 
@@ -217,13 +218,14 @@ static int brcmf_feat_fwcap_debugfs_read(struct seq_file *seq, void *data)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(seq->private);
 	struct brcmf_if *ifp = brcmf_get_ifp(bus_if->drvr, 0);
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	char caps[MAX_CAPS_BUFFER_SIZE + 1] = { };
 	char *tmp;
 	int err;
 
 	err = brcmf_fil_iovar_data_get(ifp, "cap", caps, sizeof(caps));
 	if (err) {
-		brcmf_err("could not get firmware cap (%d)\n", err);
+		bphy_err(wiphy, "could not get firmware cap (%d)\n", err);
 		return err;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
index e7eaa57d11d9..fbee919aa4cf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
@@ -102,11 +102,13 @@ static void brcmf_fweh_queue_event(struct brcmf_fweh_info *fweh,
 	schedule_work(&fweh->event_work);
 }
 
-static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
+static int brcmf_fweh_call_event_handler(struct brcmf_pub *drvr,
+					 struct brcmf_if *ifp,
 					 enum brcmf_fweh_event_code code,
 					 struct brcmf_event_msg *emsg,
 					 void *data)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_fweh_info *fweh;
 	int err = -EINVAL;
 
@@ -117,9 +119,9 @@ static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,
 		if (fweh->evt_handler[code])
 			err = fweh->evt_handler[code](ifp, emsg, data);
 		else
-			brcmf_err("unhandled event %d ignored\n", code);
+			bphy_err(wiphy, "unhandled event %d ignored\n", code);
 	} else {
-		brcmf_err("no interface object\n");
+		bphy_err(wiphy, "no interface object\n");
 	}
 	return err;
 }
@@ -136,6 +138,7 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 				       void *data)
 {
 	struct brcmf_if_event *ifevent = data;
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_if *ifp;
 	bool is_p2pdev;
 	int err = 0;
@@ -158,7 +161,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 		return;
 	}
 	if (ifevent->ifidx >= BRCMF_MAX_IFS) {
-		brcmf_err("invalid interface index: %u\n", ifevent->ifidx);
+		bphy_err(wiphy, "invalid interface index: %u\n",
+			 ifevent->ifidx);
 		return;
 	}
 
@@ -181,7 +185,8 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 	if (ifp && ifevent->action == BRCMF_E_IF_CHANGE)
 		brcmf_proto_reset_if(drvr, ifp);
 
-	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
+	err = brcmf_fweh_call_event_handler(drvr, ifp, emsg->event_code, emsg,
+					    data);
 
 	if (ifp && ifevent->action == BRCMF_E_IF_DEL) {
 		bool armed = brcmf_cfg80211_vif_event_armed(drvr->config);
@@ -228,9 +233,11 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 	int err = 0;
 	struct brcmf_event_msg_be *emsg_be;
 	struct brcmf_event_msg emsg;
+	struct wiphy *wiphy;
 
 	fweh = container_of(work, struct brcmf_fweh_info, event_work);
 	drvr = container_of(fweh, struct brcmf_pub, fweh);
+	wiphy = drvr->wiphy;
 
 	while ((event = brcmf_fweh_dequeue_event(fweh))) {
 		brcmf_dbg(EVENT, "event %s (%u) ifidx %u bsscfg %u addr %pM\n",
@@ -268,11 +275,11 @@ static void brcmf_fweh_event_worker(struct work_struct *work)
 			ifp = drvr->iflist[0];
 		else
 			ifp = drvr->iflist[emsg.bsscfgidx];
-		err = brcmf_fweh_call_event_handler(ifp, event->code, &emsg,
-						    event->data);
+		err = brcmf_fweh_call_event_handler(drvr, ifp, event->code,
+						    &emsg, event->data);
 		if (err) {
-			brcmf_err("event handler failed (%d)\n",
-				  event->code);
+			bphy_err(wiphy, "event handler failed (%d)\n",
+				 event->code);
 			err = 0;
 		}
 event_free:
@@ -338,8 +345,10 @@ void brcmf_fweh_detach(struct brcmf_pub *drvr)
 int brcmf_fweh_register(struct brcmf_pub *drvr, enum brcmf_fweh_event_code code,
 			brcmf_fweh_handler_t handler)
 {
+	struct wiphy *wiphy = drvr->wiphy;
+
 	if (drvr->fweh.evt_handler[code]) {
-		brcmf_err("event code %d already registered\n", code);
+		bphy_err(wiphy, "event code %d already registered\n", code);
 		return -ENOSPC;
 	}
 	drvr->fweh.evt_handler[code] = handler;
@@ -369,6 +378,7 @@ void brcmf_fweh_unregister(struct brcmf_pub *drvr,
  */
 int brcmf_fweh_activate_events(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	int i, err;
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 
@@ -388,7 +398,7 @@ int brcmf_fweh_activate_events(struct brcmf_if *ifp)
 	err = brcmf_fil_iovar_data_set(ifp, "event_msgs",
 				       eventmask, BRCMF_EVENTING_MASK_LEN);
 	if (err)
-		brcmf_err("Set event_msgs error (%d)\n", err);
+		bphy_err(wiphy, "Set event_msgs error (%d)\n", err);
 
 	return err;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
index 802d7cb73b80..05853fd58bec 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
@@ -107,10 +107,11 @@ static s32
 brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
 	s32 err, fwerr;
 
 	if (drvr->bus_if->state != BRCMF_BUS_UP) {
-		brcmf_err("bus is down. we have nothing to do.\n");
+		bphy_err(wiphy, "bus is down. we have nothing to do.\n");
 		return -EIO;
 	}
 
@@ -226,6 +227,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
 			 u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
 	s32 err;
 	u32 buflen;
 
@@ -242,7 +244,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
 					 buflen, true);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating iovar failed\n");
+		bphy_err(wiphy, "Creating iovar failed\n");
 	}
 
 	mutex_unlock(&drvr->proto_block);
@@ -254,6 +256,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 			 u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
 	s32 err;
 	u32 buflen;
 
@@ -268,7 +271,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 			memcpy(data, drvr->proto_buf, len);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating iovar failed\n");
+		bphy_err(wiphy, "Creating iovar failed\n");
 	}
 
 	brcmf_dbg(FIL, "ifidx=%d, name=%s, len=%d\n", ifp->ifidx, name, len);
@@ -349,6 +352,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 			  void *data, u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
 	s32 err;
 	u32 buflen;
 
@@ -366,7 +370,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 					 buflen, true);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating bsscfg failed\n");
+		bphy_err(wiphy, "Creating bsscfg failed\n");
 	}
 
 	mutex_unlock(&drvr->proto_block);
@@ -378,6 +382,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 			  void *data, u32 len)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
+	struct wiphy *wiphy = drvr->wiphy;
 	s32 err;
 	u32 buflen;
 
@@ -392,7 +397,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 			memcpy(data, drvr->proto_buf, len);
 	} else {
 		err = -EPERM;
-		brcmf_err("Creating bsscfg failed\n");
+		bphy_err(wiphy, "Creating bsscfg failed\n");
 	}
 	brcmf_dbg(FIL, "ifidx=%d, bsscfgidx=%d, name=%s, len=%d\n", ifp->ifidx,
 		  ifp->bsscfgidx, name, len);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index 02759ebd207c..a578bf5e1c55 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1255,6 +1255,7 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 			 enum brcmf_fws_skb_state state, int fifo,
 			 struct sk_buff *p)
 {
+	struct wiphy *wiphy = fws->drvr->wiphy;
 	int prec = 2 * fifo;
 	u32 *qfull_stat = &fws->stats.delayq_full_error;
 	struct brcmf_fws_mac_descriptor *entry;
@@ -1267,7 +1268,7 @@ static int brcmf_fws_enq(struct brcmf_fws_info *fws,
 
 	entry = brcmf_skbcb(p)->mac;
 	if (entry == NULL) {
-		brcmf_err("no mac descriptor found for skb %p\n", p);
+		bphy_err(wiphy, "no mac descriptor found for skb %p\n", p);
 		return -ENOENT;
 	}
 
@@ -1457,6 +1458,7 @@ static int
 brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 		      u32 genbit, u16 seq, u8 compcnt)
 {
+	struct wiphy *wiphy = fws->drvr->wiphy;
 	u32 fifo;
 	u8 cnt = 0;
 	int ret;
@@ -1481,14 +1483,14 @@ brcmf_fws_txs_process(struct brcmf_fws_info *fws, u8 flags, u32 hslot,
 	else if (flags == BRCMF_FWS_TXSTATUS_HOST_TOSSED)
 		fws->stats.txs_host_tossed += compcnt;
 	else
-		brcmf_err("unexpected txstatus\n");
+		bphy_err(wiphy, "unexpected txstatus\n");
 
 	while (cnt < compcnt) {
 		ret = brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
 					      remove_from_hanger);
 		if (ret != 0) {
-			brcmf_err("no packet in hanger slot: hslot=%d\n",
-				  hslot);
+			bphy_err(wiphy, "no packet in hanger slot: hslot=%d\n",
+				 hslot);
 			goto cont;
 		}
 
@@ -1613,11 +1615,12 @@ static int brcmf_fws_notify_credit_map(struct brcmf_if *ifp,
 				       void *data)
 {
 	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
+	struct wiphy *wiphy = fws->drvr->wiphy;
 	int i;
 	u8 *credits = data;
 
 	if (e->datalen < BRCMF_FWS_FIFO_COUNT) {
-		brcmf_err("event payload too small (%d)\n", e->datalen);
+		bphy_err(wiphy, "event payload too small (%d)\n", e->datalen);
 		return -EINVAL;
 	}
 
@@ -1681,6 +1684,7 @@ static void brcmf_rxreorder_get_skb_list(struct brcmf_ampdu_rx_reorder *rfi,
 
 void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	u8 *reorder_data;
 	u8 flow_id, max_idx, cur_idx, exp_idx, end_idx;
 	struct brcmf_ampdu_rx_reorder *rfi;
@@ -1695,7 +1699,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 
 	/* validate flags and flow id */
 	if (flags == 0xFF) {
-		brcmf_err("invalid flags...so ignore this packet\n");
+		bphy_err(wiphy, "invalid flags...so ignore this packet\n");
 		brcmf_netif_rx(ifp, pkt);
 		return;
 	}
@@ -1732,7 +1736,7 @@ void brcmf_fws_rxreorder(struct brcmf_if *ifp, struct sk_buff *pkt)
 			  flow_id, max_idx);
 		rfi = kzalloc(buf_size, GFP_ATOMIC);
 		if (rfi == NULL) {
-			brcmf_err("failed to alloc buffer\n");
+			bphy_err(wiphy, "failed to alloc buffer\n");
 			brcmf_netif_rx(ifp, pkt);
 			return;
 		}
@@ -1996,6 +2000,7 @@ static u8 brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
 static void brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 				   struct sk_buff *skb, int fifo)
 {
+	struct wiphy *wiphy = fws->drvr->wiphy;
 	struct brcmf_fws_mac_descriptor *entry;
 	struct sk_buff *pktout;
 	int qidx, hslot;
@@ -2009,11 +2014,12 @@ static void brcmf_fws_rollback_toq(struct brcmf_fws_info *fws,
 
 		pktout = brcmu_pktq_penq_head(&entry->psq, qidx, skb);
 		if (pktout == NULL) {
-			brcmf_err("%s queue %d full\n", entry->name, qidx);
+			bphy_err(wiphy, "%s queue %d full\n", entry->name,
+				 qidx);
 			rc = -ENOSPC;
 		}
 	} else {
-		brcmf_err("%s entry removed\n", entry->name);
+		bphy_err(wiphy, "%s entry removed\n", entry->name);
 		rc = -ENOENT;
 	}
 
@@ -2121,6 +2127,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	struct brcmf_fws_info *fws = drvr_to_fws(ifp->drvr);
 	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
 	struct ethhdr *eh = (struct ethhdr *)(skb->data);
+	struct wiphy *wiphy = fws->drvr->wiphy;
 	int fifo = BRCMF_FWS_FIFO_BCMC;
 	bool multicast = is_multicast_ether_addr(eh->h_dest);
 	int rc = 0;
@@ -2146,7 +2153,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 		brcmf_fws_enq(fws, BRCMF_FWS_SKBSTATE_DELAYED, fifo, skb);
 		brcmf_fws_schedule_deq(fws);
 	} else {
-		brcmf_err("drop skb: no hanger slot\n");
+		bphy_err(wiphy, "drop skb: no hanger slot\n");
 		brcmf_txfinalize(ifp, skb, false);
 		rc = -ENOMEM;
 	}
@@ -2338,6 +2345,7 @@ static int brcmf_debugfs_fws_stats_read(struct seq_file *seq, void *data)
 
 struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_fws_info *fws;
 	struct brcmf_if *ifp;
 	u32 tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS;
@@ -2365,7 +2373,7 @@ struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
 
 	fws->fws_wq = create_singlethread_workqueue("brcmf_fws_wq");
 	if (fws->fws_wq == NULL) {
-		brcmf_err("workqueue creation failed\n");
+		bphy_err(wiphy, "workqueue creation failed\n");
 		rc = -EBADF;
 		goto fail;
 	}
@@ -2381,13 +2389,13 @@ struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
 	rc = brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
 				 brcmf_fws_notify_credit_map);
 	if (rc < 0) {
-		brcmf_err("register credit map handler failed\n");
+		bphy_err(wiphy, "register credit map handler failed\n");
 		goto fail;
 	}
 	rc = brcmf_fweh_register(drvr, BRCMF_E_BCMC_CREDIT_SUPPORT,
 				 brcmf_fws_notify_bcmc_credit_support);
 	if (rc < 0) {
-		brcmf_err("register bcmc credit handler failed\n");
+		bphy_err(wiphy, "register bcmc credit handler failed\n");
 		brcmf_fweh_unregister(drvr, BRCMF_E_FIFO_CREDIT_MAP);
 		goto fail;
 	}
@@ -2399,7 +2407,7 @@ struct brcmf_fws_info *brcmf_fws_attach(struct brcmf_pub *drvr)
 	fws->fw_signals = true;
 	ifp = brcmf_get_ifp(drvr, 0);
 	if (brcmf_fil_iovar_int_set(ifp, "tlv", tlv)) {
-		brcmf_err("failed to set bdcv2 tlv signaling\n");
+		bphy_err(wiphy, "failed to set bdcv2 tlv signaling\n");
 		fws->fcmode = BRCMF_FWS_FCMODE_NONE;
 		fws->fw_signals = false;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index bbef2d41cb3b..bc751cf69dcf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -429,6 +429,7 @@ static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 				 uint cmd, void *buf, uint len)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_commonring *commonring;
 	struct msgbuf_ioctl_req_hdr *request;
 	u16 buf_len;
@@ -439,7 +440,7 @@ static int brcmf_msgbuf_tx_ioctl(struct brcmf_pub *drvr, int ifidx,
 	brcmf_commonring_lock(commonring);
 	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
 	if (!ret_ptr) {
-		brcmf_err("Failed to reserve space in commonring\n");
+		bphy_err(wiphy, "Failed to reserve space in commonring\n");
 		brcmf_commonring_unlock(commonring);
 		return -ENOMEM;
 	}
@@ -490,6 +491,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				   uint cmd, void *buf, uint len, int *fwerr)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+	struct wiphy *wiphy = drvr->wiphy;
 	struct sk_buff *skb = NULL;
 	int timeout;
 	int err;
@@ -503,7 +505,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 
 	timeout = brcmf_msgbuf_ioctl_resp_wait(msgbuf);
 	if (!timeout) {
-		brcmf_err("Timeout on response for query command\n");
+		bphy_err(wiphy, "Timeout on response for query command\n");
 		return -EIO;
 	}
 
@@ -580,6 +582,7 @@ static u32
 brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 				    struct brcmf_msgbuf_work_item *work)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct msgbuf_tx_flowring_create_req *create;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
@@ -595,7 +598,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 				     &msgbuf->flowring_dma_handle[flowid],
 				     GFP_KERNEL);
 	if (!dma_buf) {
-		brcmf_err("dma_alloc_coherent failed\n");
+		bphy_err(wiphy, "dma_alloc_coherent failed\n");
 		brcmf_flowring_delete(msgbuf->flow, flowid);
 		return BRCMF_FLOWRING_INVALID_ID;
 	}
@@ -608,7 +611,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 	brcmf_commonring_lock(commonring);
 	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
 	if (!ret_ptr) {
-		brcmf_err("Failed to reserve space in commonring\n");
+		bphy_err(wiphy, "Failed to reserve space in commonring\n");
 		brcmf_commonring_unlock(commonring);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return BRCMF_FLOWRING_INVALID_ID;
@@ -635,7 +638,7 @@ brcmf_msgbuf_flowring_create_worker(struct brcmf_msgbuf *msgbuf,
 	err = brcmf_commonring_write_complete(commonring);
 	brcmf_commonring_unlock(commonring);
 	if (err) {
-		brcmf_err("Failed to write commonring\n");
+		bphy_err(wiphy, "Failed to write commonring\n");
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return BRCMF_FLOWRING_INVALID_ID;
 	}
@@ -694,6 +697,7 @@ static u32 brcmf_msgbuf_flowring_create(struct brcmf_msgbuf *msgbuf, int ifidx,
 static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 {
 	struct brcmf_flowring *flow = msgbuf->flow;
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
 	u32 count;
@@ -713,8 +717,8 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 	while (brcmf_flowring_qlen(flow, flowid)) {
 		skb = brcmf_flowring_dequeue(flow, flowid);
 		if (skb == NULL) {
-			brcmf_err("No SKB, but qlen %d\n",
-				  brcmf_flowring_qlen(flow, flowid));
+			bphy_err(wiphy, "No SKB, but qlen %d\n",
+				 brcmf_flowring_qlen(flow, flowid));
 			break;
 		}
 		skb_orphan(skb);
@@ -722,7 +726,7 @@ static void brcmf_msgbuf_txflow(struct brcmf_msgbuf *msgbuf, u16 flowid)
 					     msgbuf->tx_pktids, skb, ETH_HLEN,
 					     &physaddr, &pktid)) {
 			brcmf_flowring_reinsert(flow, flowid, skb);
-			brcmf_err("No PKTID available !!\n");
+			bphy_err(wiphy, "No PKTID available !!\n");
 			break;
 		}
 		ret_ptr = brcmf_commonring_reserve_for_write(commonring);
@@ -893,6 +897,7 @@ brcmf_msgbuf_process_txstatus(struct brcmf_msgbuf *msgbuf, void *buf)
 
 static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
 	struct sk_buff *skb;
@@ -920,7 +925,7 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 		skb = brcmu_pkt_buf_get_skb(BRCMF_MSGBUF_MAX_PKT_SIZE);
 
 		if (skb == NULL) {
-			brcmf_err("Failed to alloc SKB\n");
+			bphy_err(wiphy, "Failed to alloc SKB\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -930,7 +935,7 @@ static u32 brcmf_msgbuf_rxbuf_data_post(struct brcmf_msgbuf *msgbuf, u32 count)
 					     msgbuf->rx_pktids, skb, 0,
 					     &physaddr, &pktid)) {
 			dev_kfree_skb_any(skb);
-			brcmf_err("No PKTID available !!\n");
+			bphy_err(wiphy, "No PKTID available !!\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -1000,6 +1005,7 @@ static u32
 brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 			     u32 count)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
 	struct sk_buff *skb;
@@ -1017,7 +1023,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 							      count,
 							      &alloced);
 	if (!ret_ptr) {
-		brcmf_err("Failed to reserve space in commonring\n");
+		bphy_err(wiphy, "Failed to reserve space in commonring\n");
 		brcmf_commonring_unlock(commonring);
 		return 0;
 	}
@@ -1029,7 +1035,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 		skb = brcmu_pkt_buf_get_skb(BRCMF_MSGBUF_MAX_PKT_SIZE);
 
 		if (skb == NULL) {
-			brcmf_err("Failed to alloc SKB\n");
+			bphy_err(wiphy, "Failed to alloc SKB\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -1039,7 +1045,7 @@ brcmf_msgbuf_rxbuf_ctrl_post(struct brcmf_msgbuf *msgbuf, bool event_buf,
 					     msgbuf->rx_pktids, skb, 0,
 					     &physaddr, &pktid)) {
 			dev_kfree_skb_any(skb);
-			brcmf_err("No PKTID available !!\n");
+			bphy_err(wiphy, "No PKTID available !!\n");
 			brcmf_commonring_write_cancel(commonring, alloced - i);
 			break;
 		}
@@ -1091,6 +1097,7 @@ static void brcmf_msgbuf_rxbuf_event_post(struct brcmf_msgbuf *msgbuf)
 
 static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct msgbuf_rx_event *event;
 	u32 idx;
 	u16 buflen;
@@ -1117,8 +1124,8 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	ifp = brcmf_get_ifp(msgbuf->drvr, event->msg.ifidx);
 	if (!ifp || !ifp->ndev) {
-		brcmf_err("Received pkt for invalid ifidx %d\n",
-			  event->msg.ifidx);
+		bphy_err(wiphy, "Received pkt for invalid ifidx %d\n",
+			 event->msg.ifidx);
 		goto exit;
 	}
 
@@ -1134,6 +1141,7 @@ static void brcmf_msgbuf_process_event(struct brcmf_msgbuf *msgbuf, void *buf)
 static void
 brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct msgbuf_rx_complete *rx_complete;
 	struct sk_buff *skb;
 	u16 data_offset;
@@ -1167,7 +1175,7 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 		ifp = msgbuf->drvr->mon_if;
 
 		if (!ifp) {
-			brcmf_err("Received unexpected monitor pkt\n");
+			bphy_err(wiphy, "Received unexpected monitor pkt\n");
 			brcmu_pkt_buf_free_skb(skb);
 			return;
 		}
@@ -1178,8 +1186,8 @@ brcmf_msgbuf_process_rx_complete(struct brcmf_msgbuf *msgbuf, void *buf)
 
 	ifp = brcmf_get_ifp(msgbuf->drvr, rx_complete->msg.ifidx);
 	if (!ifp || !ifp->ndev) {
-		brcmf_err("Received pkt for invalid ifidx %d\n",
-			  rx_complete->msg.ifidx);
+		bphy_err(wiphy, "Received pkt for invalid ifidx %d\n",
+			 rx_complete->msg.ifidx);
 		brcmu_pkt_buf_free_skb(skb);
 		return;
 	}
@@ -1206,6 +1214,7 @@ static void
 brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 					       void *buf)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct msgbuf_flowring_create_resp *flowring_create_resp;
 	u16 status;
 	u16 flowid;
@@ -1217,7 +1226,7 @@ brcmf_msgbuf_process_flow_ring_create_response(struct brcmf_msgbuf *msgbuf,
 	status =  le16_to_cpu(flowring_create_resp->compl_hdr.status);
 
 	if (status) {
-		brcmf_err("Flowring creation failed, code %d\n", status);
+		bphy_err(wiphy, "Flowring creation failed, code %d\n", status);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return;
 	}
@@ -1234,6 +1243,7 @@ static void
 brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 					       void *buf)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct msgbuf_flowring_delete_resp *flowring_delete_resp;
 	u16 status;
 	u16 flowid;
@@ -1245,7 +1255,7 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 	status =  le16_to_cpu(flowring_delete_resp->compl_hdr.status);
 
 	if (status) {
-		brcmf_err("Flowring deletion failed, code %d\n", status);
+		bphy_err(wiphy, "Flowring deletion failed, code %d\n", status);
 		brcmf_flowring_delete(msgbuf->flow, flowid);
 		return;
 	}
@@ -1258,6 +1268,7 @@ brcmf_msgbuf_process_flow_ring_delete_response(struct brcmf_msgbuf *msgbuf,
 
 static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 {
+	struct wiphy *wiphy = msgbuf->drvr->wiphy;
 	struct msgbuf_common_hdr *msg;
 
 	msg = (struct msgbuf_common_hdr *)buf;
@@ -1294,7 +1305,7 @@ static void brcmf_msgbuf_process_msgtype(struct brcmf_msgbuf *msgbuf, void *buf)
 		brcmf_msgbuf_process_rx_complete(msgbuf, buf);
 		break;
 	default:
-		brcmf_err("Unsupported msgtype %d\n", msg->msgtype);
+		bphy_err(wiphy, "Unsupported msgtype %d\n", msg->msgtype);
 		break;
 	}
 }
@@ -1367,6 +1378,7 @@ int brcmf_proto_msgbuf_rx_trigger(struct device *dev)
 void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 {
 	struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
+	struct wiphy *wiphy = drvr->wiphy;
 	struct msgbuf_tx_flowring_delete_req *delete;
 	struct brcmf_commonring *commonring;
 	void *ret_ptr;
@@ -1377,7 +1389,7 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	brcmf_commonring_lock(commonring);
 	ret_ptr = brcmf_commonring_reserve_for_write(commonring);
 	if (!ret_ptr) {
-		brcmf_err("FW unaware, flowring will be removed !!\n");
+		bphy_err(wiphy, "FW unaware, flowring will be removed !!\n");
 		brcmf_commonring_unlock(commonring);
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 		return;
@@ -1401,7 +1413,7 @@ void brcmf_msgbuf_delete_flowring(struct brcmf_pub *drvr, u16 flowid)
 	err = brcmf_commonring_write_complete(commonring);
 	brcmf_commonring_unlock(commonring);
 	if (err) {
-		brcmf_err("Failed to submit RING_DELETE, flowring will be removed\n");
+		bphy_err(wiphy, "Failed to submit RING_DELETE, flowring will be removed\n");
 		brcmf_msgbuf_remove_flowring(msgbuf, flowid);
 	}
 }
@@ -1468,6 +1480,7 @@ static void brcmf_msgbuf_debugfs_create(struct brcmf_pub *drvr)
 
 int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_bus_msgbuf *if_msgbuf;
 	struct brcmf_msgbuf *msgbuf;
 	u64 address;
@@ -1476,8 +1489,8 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 	if_msgbuf = drvr->bus_if->msgbuf;
 
 	if (if_msgbuf->max_flowrings >= BRCMF_FLOWRING_HASHSIZE) {
-		brcmf_err("driver not configured for this many flowrings %d\n",
-			  if_msgbuf->max_flowrings);
+		bphy_err(wiphy, "driver not configured for this many flowrings %d\n",
+			 if_msgbuf->max_flowrings);
 		if_msgbuf->max_flowrings = BRCMF_FLOWRING_HASHSIZE - 1;
 	}
 
@@ -1487,7 +1500,7 @@ int brcmf_proto_msgbuf_attach(struct brcmf_pub *drvr)
 
 	msgbuf->txflow_wq = create_singlethread_workqueue("msgbuf_txflow");
 	if (msgbuf->txflow_wq == NULL) {
-		brcmf_err("workqueue creation failed\n");
+		bphy_err(wiphy, "workqueue creation failed\n");
 		goto fail;
 	}
 	INIT_WORK(&msgbuf->txflow_work, brcmf_msgbuf_txflow_worker);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 456a1bf008b3..ff30fc934d7a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -434,6 +434,7 @@ static void brcmf_p2p_print_actframe(bool tx, void *frame, u32 frame_len)
  */
 static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	s32 ret = 0;
 
 	brcmf_fil_cmd_int_set(ifp, BRCMF_C_DOWN, 1);
@@ -450,7 +451,8 @@ static int brcmf_p2p_set_firmware(struct brcmf_if *ifp, u8 *p2p_mac)
 	ret = brcmf_fil_iovar_data_set(ifp, "p2p_da_override", p2p_mac,
 				       ETH_ALEN);
 	if (ret)
-		brcmf_err("failed to update device address ret %d\n", ret);
+		bphy_err(wiphy, "failed to update device address ret %d\n",
+			 ret);
 
 	return ret;
 }
@@ -570,13 +572,14 @@ static s32 brcmf_p2p_deinit_discovery(struct brcmf_p2p_info *p2p)
  */
 static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 {
+	struct wiphy *wiphy = p2p->cfg->wiphy;
 	struct brcmf_cfg80211_vif *vif;
 	s32 ret = 0;
 
 	brcmf_dbg(TRACE, "enter\n");
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (!vif) {
-		brcmf_err("P2P config device not available\n");
+		bphy_err(wiphy, "P2P config device not available\n");
 		ret = -EPERM;
 		goto exit;
 	}
@@ -590,13 +593,13 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 	ret = brcmf_fil_iovar_int_set(vif->ifp, "p2p_disc", 1);
 	if (ret < 0) {
-		brcmf_err("set p2p_disc error\n");
+		bphy_err(wiphy, "set p2p_disc error\n");
 		goto exit;
 	}
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	ret = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
 	if (ret < 0) {
-		brcmf_err("unable to set WL_P2P_DISC_ST_SCAN\n");
+		bphy_err(wiphy, "unable to set WL_P2P_DISC_ST_SCAN\n");
 		goto exit;
 	}
 
@@ -608,7 +611,7 @@ static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p)
 	 */
 	ret = brcmf_fil_bsscfg_int_set(vif->ifp, "wsec", AES_ENABLED);
 	if (ret < 0) {
-		brcmf_err("wsec error %d\n", ret);
+		bphy_err(wiphy, "wsec error %d\n", ret);
 		goto exit;
 	}
 
@@ -630,6 +633,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 			   u16 chanspecs[], s32 search_state,
 			   enum p2p_bss_type bss_type)
 {
+	struct wiphy *wiphy = p2p->cfg->wiphy;
 	s32 ret = 0;
 	s32 memsize = offsetof(struct brcmf_p2p_scan_le,
 			       eparams.params_le.channel_list);
@@ -648,7 +652,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 
 	vif = p2p->bss_idx[bss_type].vif;
 	if (vif == NULL) {
-		brcmf_err("no vif for bss type %d\n", bss_type);
+		bphy_err(wiphy, "no vif for bss type %d\n", bss_type);
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -676,7 +680,7 @@ static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
 		       BRCMF_P2P_WILDCARD_SSID_LEN);
 		break;
 	default:
-		brcmf_err(" invalid search state %d\n", search_state);
+		bphy_err(wiphy, " invalid search state %d\n", search_state);
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -760,6 +764,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 			       struct cfg80211_scan_request *request)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct wiphy *wiphy = cfg->wiphy;
 	s32 err = 0;
 	s32 search_state = WL_P2P_DISC_ST_SCAN;
 	struct brcmf_cfg80211_vif *vif;
@@ -822,7 +827,7 @@ static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
 	}
 exit:
 	if (err)
-		brcmf_err("error (%d)\n", err);
+		bphy_err(wiphy, "error (%d)\n", err);
 	return err;
 }
 
@@ -917,19 +922,20 @@ int brcmf_p2p_scan_prep(struct wiphy *wiphy,
 static s32
 brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
 {
+	struct wiphy *wiphy = p2p->cfg->wiphy;
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmu_chan ch;
 	s32 err = 0;
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 	if (!vif) {
-		brcmf_err("Discovery is not set, so we have nothing to do\n");
+		bphy_err(wiphy, "Discovery is not set, so we have nothing to do\n");
 		err = -EPERM;
 		goto exit;
 	}
 
 	if (test_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status)) {
-		brcmf_err("Previous LISTEN is not completed yet\n");
+		bphy_err(wiphy, "Previous LISTEN is not completed yet\n");
 		/* WAR: prevent cookie mismatch in wpa_supplicant return OK */
 		goto exit;
 	}
@@ -1046,6 +1052,7 @@ void brcmf_p2p_cancel_remain_on_channel(struct brcmf_if *ifp)
  */
 static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
 {
+	struct wiphy *wiphy = p2p->cfg->wiphy;
 	s32 err;
 	u32 channel_cnt;
 	u16 *default_chan_list;
@@ -1061,7 +1068,7 @@ static s32 brcmf_p2p_act_frm_search(struct brcmf_p2p_info *p2p, u16 channel)
 	default_chan_list = kcalloc(channel_cnt, sizeof(*default_chan_list),
 				    GFP_KERNEL);
 	if (default_chan_list == NULL) {
-		brcmf_err("channel list allocation failed\n");
+		bphy_err(wiphy, "channel list allocation failed\n");
 		err = -ENOMEM;
 		goto exit;
 	}
@@ -1103,6 +1110,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
 	struct brcmf_p2p_info *p2p = container_of(afx_hdl,
 						  struct brcmf_p2p_info,
 						  afx_hdl);
+	struct wiphy *wiphy = p2p->cfg->wiphy;
 	s32 err;
 
 	if (!afx_hdl->is_active)
@@ -1116,7 +1124,7 @@ static void brcmf_p2p_afx_handler(struct work_struct *work)
 		err = brcmf_p2p_act_frm_search(p2p, afx_hdl->peer_listen_chan);
 
 	if (err) {
-		brcmf_err("ERROR occurred! value is (%d)\n", err);
+		bphy_err(wiphy, "ERROR occurred! value is (%d)\n", err);
 		if (test_bit(BRCMF_P2P_STATUS_FINDING_COMMON_CHANNEL,
 			     &p2p->status))
 			complete(&afx_hdl->act_frm_scan);
@@ -1341,6 +1349,7 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
+	struct wiphy *wiphy = cfg->wiphy;
 	struct wireless_dev *wdev;
 	u32 mgmt_frame_len = e->datalen - sizeof(struct brcmf_rx_mgmt_data);
 	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
@@ -1409,7 +1418,7 @@ int brcmf_p2p_notify_action_frame_rx(struct brcmf_if *ifp,
 	mgmt_frame = kzalloc(offsetof(struct ieee80211_mgmt, u) +
 			     mgmt_frame_len, GFP_KERNEL);
 	if (!mgmt_frame) {
-		brcmf_err("No memory available for action frame\n");
+		bphy_err(wiphy, "No memory available for action frame\n");
 		return -ENOMEM;
 	}
 	memcpy(mgmt_frame->da, ifp->mac_addr, ETH_ALEN);
@@ -1492,6 +1501,7 @@ int brcmf_p2p_notify_action_tx_complete(struct brcmf_if *ifp,
 static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 				     struct brcmf_fil_af_params_le *af_params)
 {
+	struct wiphy *wiphy = p2p->cfg->wiphy;
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 	s32 timeout = 0;
@@ -1506,7 +1516,7 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 	err = brcmf_fil_bsscfg_data_set(vif->ifp, "actframe", af_params,
 					sizeof(*af_params));
 	if (err) {
-		brcmf_err(" sending action frame has failed\n");
+		bphy_err(wiphy, " sending action frame has failed\n");
 		goto exit;
 	}
 
@@ -1556,6 +1566,7 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 			       struct brcmf_config_af_params *config_af_params)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct wiphy *wiphy = cfg->wiphy;
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_p2p_pub_act_frame *act_frm;
 	s32 err = 0;
@@ -1634,8 +1645,8 @@ static s32 brcmf_p2p_pub_af_tx(struct brcmf_cfg80211_info *cfg,
 		config_af_params->extra_listen = false;
 		break;
 	default:
-		brcmf_err("Unknown p2p pub act frame subtype: %d\n",
-			  act_frm->subtype);
+		bphy_err(wiphy, "Unknown p2p pub act frame subtype: %d\n",
+			 act_frm->subtype);
 		err = -EINVAL;
 	}
 	return err;
@@ -1654,6 +1665,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct wiphy *wiphy = cfg->wiphy;
 	struct brcmf_fil_action_frame_le *action_frame;
 	struct brcmf_config_af_params config_af_params;
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
@@ -1692,7 +1704,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		if (brcmf_p2p_pub_af_tx(cfg, af_params, &config_af_params)) {
 			/* Just send unknown subtype frame with */
 			/* default parameters.                  */
-			brcmf_err("P2P Public action frame, unknown subtype.\n");
+			bphy_err(wiphy, "P2P Public action frame, unknown subtype.\n");
 		}
 	} else if (brcmf_p2p_is_gas_action(action_frame->data,
 					   action_frame_len)) {
@@ -1714,7 +1726,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 			af_params->dwell_time =
 				cpu_to_le32(P2P_AF_MIN_DWELL_TIME);
 		} else {
-			brcmf_err("Unknown action type: %d\n", action);
+			bphy_err(wiphy, "Unknown action type: %d\n", action);
 			goto exit;
 		}
 	} else if (brcmf_p2p_is_p2p_action(action_frame->data,
@@ -1722,8 +1734,8 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		/* do not configure anything. it will be */
 		/* sent with a default configuration     */
 	} else {
-		brcmf_err("Unknown Frame: category 0x%x, action 0x%x\n",
-			  category, action);
+		bphy_err(wiphy, "Unknown Frame: category 0x%x, action 0x%x\n",
+			 category, action);
 		return false;
 	}
 
@@ -1761,7 +1773,7 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 
 		if (brcmf_p2p_af_searching_channel(p2p) ==
 							P2P_INVALID_CHANNEL) {
-			brcmf_err("Couldn't find peer's channel.\n");
+			bphy_err(wiphy, "Couldn't find peer's channel.\n");
 			goto exit;
 		}
 
@@ -1783,7 +1795,8 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
 		tx_retry++;
 	}
 	if (ack == false) {
-		brcmf_err("Failed to send Action Frame(retry %d)\n", tx_retry);
+		bphy_err(wiphy, "Failed to send Action Frame(retry %d)\n",
+			 tx_retry);
 		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
 	}
 
@@ -1965,6 +1978,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 		       enum brcmf_fil_p2p_if_types if_type)
 {
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct wiphy *wiphy = cfg->wiphy;
 	struct brcmf_cfg80211_vif *vif;
 	struct brcmf_fil_p2p_if_le if_request;
 	s32 err;
@@ -1974,13 +1988,13 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
 	if (!vif) {
-		brcmf_err("vif for P2PAPI_BSSCFG_PRIMARY does not exist\n");
+		bphy_err(wiphy, "vif for P2PAPI_BSSCFG_PRIMARY does not exist\n");
 		return -EPERM;
 	}
 	brcmf_notify_escan_complete(cfg, vif->ifp, true, true);
 	vif = p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif;
 	if (!vif) {
-		brcmf_err("vif for P2PAPI_BSSCFG_CONNECTION does not exist\n");
+		bphy_err(wiphy, "vif for P2PAPI_BSSCFG_CONNECTION does not exist\n");
 		return -EPERM;
 	}
 	brcmf_set_mpc(vif->ifp, 0);
@@ -1998,7 +2012,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 	err = brcmf_fil_iovar_data_set(vif->ifp, "p2p_ifupd", &if_request,
 				       sizeof(if_request));
 	if (err) {
-		brcmf_err("p2p_ifupd FAILED, err=%d\n", err);
+		bphy_err(wiphy, "p2p_ifupd FAILED, err=%d\n", err);
 		brcmf_cfg80211_arm_vif_event(cfg, NULL);
 		return err;
 	}
@@ -2006,7 +2020,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err)  {
-		brcmf_err("No BRCMF_E_IF_CHANGE event received\n");
+		bphy_err(wiphy, "No BRCMF_E_IF_CHANGE event received\n");
 		return -EIO;
 	}
 
@@ -2080,7 +2094,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 
 	p2p_vif = brcmf_alloc_vif(p2p->cfg, NL80211_IFTYPE_P2P_DEVICE);
 	if (IS_ERR(p2p_vif)) {
-		brcmf_err("could not create discovery vif\n");
+		bphy_err(wiphy, "could not create discovery vif\n");
 		return (struct wireless_dev *)p2p_vif;
 	}
 
@@ -2088,7 +2102,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 
 	/* firmware requires unique mac address for p2pdev interface */
 	if (addr && ether_addr_equal(addr, pri_ifp->mac_addr)) {
-		brcmf_err("discovery vif must be different from primary interface\n");
+		bphy_err(wiphy, "discovery vif must be different from primary interface\n");
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -2101,7 +2115,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* Initialize P2P Discovery in the firmware */
 	err = brcmf_fil_iovar_int_set(pri_ifp, "p2p_disc", 1);
 	if (err < 0) {
-		brcmf_err("set p2p_disc error\n");
+		bphy_err(wiphy, "set p2p_disc error\n");
 		brcmf_fweh_p2pdev_setup(pri_ifp, false);
 		brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 		goto fail;
@@ -2113,7 +2127,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 	brcmf_fweh_p2pdev_setup(pri_ifp, false);
 	if (!err) {
-		brcmf_err("timeout occurred\n");
+		bphy_err(wiphy, "timeout occurred\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -2127,7 +2141,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	/* verify bsscfg index for P2P discovery */
 	err = brcmf_fil_iovar_int_get(pri_ifp, "p2p_dev", &bsscfgidx);
 	if (err < 0) {
-		brcmf_err("retrieving discover bsscfg index failed\n");
+		bphy_err(wiphy, "retrieving discover bsscfg index failed\n");
 		goto fail;
 	}
 
@@ -2201,7 +2215,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
-		brcmf_err("timeout occurred\n");
+		bphy_err(wiphy, "timeout occurred\n");
 		err = -EIO;
 		goto fail;
 	}
@@ -2209,7 +2223,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	/* interface created in firmware */
 	ifp = vif->ifp;
 	if (!ifp) {
-		brcmf_err("no if pointer provided\n");
+		bphy_err(wiphy, "no if pointer provided\n");
 		err = -ENOENT;
 		goto fail;
 	}
@@ -2218,7 +2232,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	ifp->ndev->name_assign_type = name_assign_type;
 	err = brcmf_net_attach(ifp, true);
 	if (err) {
-		brcmf_err("Registering netdevice failed\n");
+		bphy_err(wiphy, "Registering netdevice failed\n");
 		free_netdev(ifp->ndev);
 		goto fail;
 	}
@@ -2373,6 +2387,7 @@ void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev)
  */
 s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 {
+	struct wiphy *wiphy = cfg->wiphy;
 	struct brcmf_p2p_info *p2p;
 	struct brcmf_if *pri_ifp;
 	s32 err = 0;
@@ -2387,7 +2402,7 @@ s32 brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg, bool p2pdev_forced)
 	if (p2pdev_forced) {
 		err_ptr = brcmf_p2p_create_p2pdev(p2p, NULL, NULL);
 		if (IS_ERR(err_ptr)) {
-			brcmf_err("P2P device creation failed.\n");
+			bphy_err(wiphy, "P2P device creation failed.\n");
 			err = PTR_ERR(err_ptr);
 		}
 	} else {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index 37b403877228..6e32b5cc18c7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -109,6 +109,7 @@ static int brcmf_pno_channel_config(struct brcmf_if *ifp,
 static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 			    u32 mscan, u32 bestn)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_pno_param_le pfn_param;
 	u16 flags;
 	u32 pfnmem;
@@ -132,13 +133,13 @@ static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 		/* set bestn in firmware */
 		err = brcmf_fil_iovar_int_set(ifp, "pfnmem", pfnmem);
 		if (err < 0) {
-			brcmf_err("failed to set pfnmem\n");
+			bphy_err(wiphy, "failed to set pfnmem\n");
 			goto exit;
 		}
 		/* get max mscan which the firmware supports */
 		err = brcmf_fil_iovar_int_get(ifp, "pfnmem", &pfnmem);
 		if (err < 0) {
-			brcmf_err("failed to get pfnmem\n");
+			bphy_err(wiphy, "failed to get pfnmem\n");
 			goto exit;
 		}
 		mscan = min_t(u32, mscan, pfnmem);
@@ -152,7 +153,7 @@ static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_set", &pfn_param,
 				       sizeof(pfn_param));
 	if (err)
-		brcmf_err("pfn_set failed, err=%d\n", err);
+		bphy_err(wiphy, "pfn_set failed, err=%d\n", err);
 
 exit:
 	return err;
@@ -160,6 +161,7 @@ static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 
 static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_pno_macaddr_le pfn_mac;
 	u8 *mac_addr = NULL;
 	u8 *mac_mask = NULL;
@@ -194,7 +196,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_macaddr", &pfn_mac,
 				       sizeof(pfn_mac));
 	if (err)
-		brcmf_err("pfn_macaddr failed, err=%d\n", err);
+		bphy_err(wiphy, "pfn_macaddr failed, err=%d\n", err);
 
 	return err;
 }
@@ -202,6 +204,7 @@ static int brcmf_pno_set_random(struct brcmf_if *ifp, struct brcmf_pno_info *pi)
 static int brcmf_pno_add_ssid(struct brcmf_if *ifp, struct cfg80211_ssid *ssid,
 			      bool active)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_pno_net_param_le pfn;
 	int err;
 
@@ -218,12 +221,13 @@ static int brcmf_pno_add_ssid(struct brcmf_if *ifp, struct cfg80211_ssid *ssid,
 	brcmf_dbg(SCAN, "adding ssid=%.32s (active=%d)\n", ssid->ssid, active);
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_add", &pfn, sizeof(pfn));
 	if (err < 0)
-		brcmf_err("adding failed: err=%d\n", err);
+		bphy_err(wiphy, "adding failed: err=%d\n", err);
 	return err;
 }
 
 static int brcmf_pno_add_bssid(struct brcmf_if *ifp, const u8 *bssid)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_pno_bssid_le bssid_cfg;
 	int err;
 
@@ -234,7 +238,7 @@ static int brcmf_pno_add_bssid(struct brcmf_if *ifp, const u8 *bssid)
 	err = brcmf_fil_iovar_data_set(ifp, "pfn_add_bssid", &bssid_cfg,
 				       sizeof(bssid_cfg));
 	if (err < 0)
-		brcmf_err("adding failed: err=%d\n", err);
+		bphy_err(wiphy, "adding failed: err=%d\n", err);
 	return err;
 }
 
@@ -258,6 +262,7 @@ static bool brcmf_is_ssid_active(struct cfg80211_ssid *ssid,
 
 static int brcmf_pno_clean(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	int ret;
 
 	/* Disable pfn */
@@ -267,7 +272,7 @@ static int brcmf_pno_clean(struct brcmf_if *ifp)
 		ret = brcmf_fil_iovar_data_set(ifp, "pfnclear", NULL, 0);
 	}
 	if (ret < 0)
-		brcmf_err("failed code %d\n", ret);
+		bphy_err(wiphy, "failed code %d\n", ret);
 
 	return ret;
 }
@@ -392,6 +397,7 @@ static int brcmf_pno_config_networks(struct brcmf_if *ifp,
 
 static int brcmf_pno_config_sched_scans(struct brcmf_if *ifp)
 {
+	struct wiphy *wiphy = ifp->drvr->wiphy;
 	struct brcmf_pno_info *pi;
 	struct brcmf_gscan_config *gscan_cfg;
 	struct brcmf_gscan_bucket_config *buckets;
@@ -416,7 +422,7 @@ static int brcmf_pno_config_sched_scans(struct brcmf_if *ifp)
 	/* clean up everything */
 	err = brcmf_pno_clean(ifp);
 	if  (err < 0) {
-		brcmf_err("failed error=%d\n", err);
+		bphy_err(wiphy, "failed error=%d\n", err);
 		goto free_gscan;
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
index c5ff551ec659..495722064092 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.c
@@ -30,6 +30,7 @@
 
 int brcmf_proto_attach(struct brcmf_pub *drvr)
 {
+	struct wiphy *wiphy = drvr->wiphy;
 	struct brcmf_proto *proto;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -47,8 +48,8 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 		if (brcmf_proto_msgbuf_attach(drvr))
 			goto fail;
 	} else {
-		brcmf_err("Unsupported proto type %d\n",
-			  drvr->bus_if->proto_type);
+		bphy_err(wiphy, "Unsupported proto type %d\n",
+			 drvr->bus_if->proto_type);
 		goto fail;
 	}
 	if (!proto->tx_queue_data || (proto->hdrpull == NULL) ||
@@ -56,7 +57,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	    (proto->configure_addr_mode == NULL) ||
 	    (proto->delete_peer == NULL) || (proto->add_tdls_peer == NULL) ||
 	    (proto->debugfs_create == NULL)) {
-		brcmf_err("Not all proto handlers have been installed\n");
+		bphy_err(wiphy, "Not all proto handlers have been installed\n");
 		goto fail;
 	}
 	return 0;
-- 
2.20.1

