Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4702DECDE46
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 19:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0136B2082E
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 19:49:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="xWBfJbfS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0136B2082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bobcopeland.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbeJZEXZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 00:23:25 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:33289 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbeJZEXZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 00:23:25 -0400
Received: by mail-io1-f68.google.com with SMTP id l25-v6so6260438ioj.0
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2018 12:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fycvqBAtfE40J048mJ8Ij50lgVhHr4bugNStCwA6+d4=;
        b=xWBfJbfS6rhTOv7t3QBNSk3T3frc9V339TXE3dS7uOpd7PbsKgIMLQ2FA43HmpHJeD
         WOrA1+hXlOoyZmMFsODRG1Fa2eVxZihDedJ9q33tkwYyD1GUaWXAz+hWyeENzM/AG263
         IRr+grdaoJtp7+xIk3PLXbjc+1NqrF0thXLau+vZSMLltyBkbXxIzNye5e6wzlL9+5xc
         YjNOU81XlMlwfGz4zCHYIAn663k4Bk3mw0J/0yNjIyMjRkJ4gF5tsWuNgYS7g2y9Ow0V
         eJxN4rggXEDdmKqkNbefALywdMddRqP8oq5Q4cjcYbZV8T1gLIYSBO4Rtp9Vlja939yK
         pHQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fycvqBAtfE40J048mJ8Ij50lgVhHr4bugNStCwA6+d4=;
        b=js7QkbuEWhSqyYcM1Xo6S5svX5Ohw/8XwtrX59jSH72Ohmg+Hc8riqCqGt6ct+sU43
         IjcLIAhPb2cUWc4HrsbPyPlyTurD7XNJHTvvCdyaHJIhKMXUeB8HgGTOAcmAPciVh1Vv
         YFopUxFWA6chfuPI098XtFpYYK6hC/GIahoH45IphTxLMHvBVrJyXilWg3aVFsuAed4x
         XyS7rPG9f6m2N8k105r+hC99C/ttt39WGhw84gOo0JTXKlHMXE0UMwXCiIhJePp8vLkg
         uGHfedymlD5U0CCR4vzxo0+A83n0+GUx3PKwgN88dkKwfDpqHuSuGQrqNwOLFtIY5ANz
         nhSQ==
X-Gm-Message-State: AGRZ1gLZXUqA4cI6S1svuLX6Knq1gt3ONGC8OQ8dCBbwJ/L/LGZ2ig07
        lMJRa1hk3XVfMJtqAAsjzaV15A==
X-Google-Smtp-Source: AJdET5cuaJjv8HI01wSndqDrzcElJNr4uOpiXHDsP2SC2UdAFniKdoPp6SlMjG3d/Yvj5/0n1ZD+uQ==
X-Received: by 2002:a6b:b2d0:: with SMTP id b199-v6mr397851iof.140.1540496957713;
        Thu, 25 Oct 2018 12:49:17 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id s20-v6sm3131017ioa.1.2018.10.25.12.49.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Oct 2018 12:49:17 -0700 (PDT)
Received: from bob by hash with local (Exim 4.89)
        (envelope-from <me@bobcopeland.com>)
        id 1gFld6-00034Y-A0; Thu, 25 Oct 2018 15:49:16 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <me@bobcopeland.com>,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH 3/3] {nl,mac}80211: add dot11MeshConnectedToMeshGate to meshconf
Date:   Thu, 25 Oct 2018 15:48:54 -0400
Message-Id: <20181025194854.11676-3-me@bobcopeland.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20181025194854.11676-1-me@bobcopeland.com>
References: <20181025194854.11676-1-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When userspace is controlling mesh routing, it may have better
knowledge about whether a mesh STA is connected to a mesh
gate than the kernel mpath table.  Add dot11MeshConnectedToMeshGate
to the mesh config so that such applications can explicitly
signal that a mesh STA is connected to a gate, which will then
be advertised in the beacon.

Signed-off-by: Bob Copeland <bobcopeland@fb.com>
---
 include/net/cfg80211.h        | 5 +++++
 include/uapi/linux/nl80211.h  | 6 ++++++
 net/mac80211/cfg.c            | 3 +++
 net/mac80211/debugfs_netdev.c | 3 +++
 net/mac80211/mesh.c           | 3 ++-
 net/wireless/nl80211.c        | 8 +++++++-
 6 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f2cb1a3c9651..cddaa9dacb27 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1562,6 +1562,10 @@ struct bss_parameters {
  * @plink_timeout: If no tx activity is seen from a STA we've established
  *	peering with for longer than this time (in seconds), then remove it
  *	from the STA's list of peers.  Default is 30 minutes.
+ * @dot11MeshConnectedToMeshGate: if set to true, advertise that this STA is
+ *      connected to a mesh gate in mesh formation info.  If false, the
+ *      value in mesh formation is determined by the presence of root paths
+ *      in the mesh path table
  */
 struct mesh_config {
 	u16 dot11MeshRetryTimeout;
@@ -1581,6 +1585,7 @@ struct mesh_config {
 	u16 dot11MeshHWMPperrMinInterval;
 	u16 dot11MeshHWMPnetDiameterTraversalTime;
 	u8 dot11MeshHWMPRootMode;
+	bool dot11MeshConnectedToMeshGate;
 	u16 dot11MeshHWMPRannInterval;
 	bool dot11MeshGateAnnouncementProtocol;
 	bool dot11MeshForwarding;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f2d79f9b4b5a..d04391ae4acd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3898,6 +3898,11 @@ enum nl80211_mesh_power_mode {
  *	remove it from the STA's list of peers. You may set this to 0 to disable
  *	the removal of the STA. Default is 30 minutes.
  *
+ * @NL80211_MESHCONF_CONNECTED_TO_GATE: If set to true then this mesh STA
+ *	will advertise that it is connected to a gate in the mesh formation
+ *	field.  If left unset then the mesh formation field will only
+ *	advertise such if there is an active root mesh path.
+ *
  * @__NL80211_MESHCONF_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_meshconf_params {
@@ -3930,6 +3935,7 @@ enum nl80211_meshconf_params {
 	NL80211_MESHCONF_POWER_MODE,
 	NL80211_MESHCONF_AWAKE_WINDOW,
 	NL80211_MESHCONF_PLINK_TIMEOUT,
+	NL80211_MESHCONF_CONNECTED_TO_GATE,
 
 	/* keep last */
 	__NL80211_MESHCONF_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 51622333d460..6d1c54f28df7 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2028,6 +2028,9 @@ static int ieee80211_update_mesh_config(struct wiphy *wiphy,
 			nconf->dot11MeshAwakeWindowDuration;
 	if (_chg_mesh_attr(NL80211_MESHCONF_PLINK_TIMEOUT, mask))
 		conf->plink_timeout = nconf->plink_timeout;
+	if (_chg_mesh_attr(NL80211_MESHCONF_CONNECTED_TO_GATE, mask))
+		conf->dot11MeshConnectedToMeshGate =
+			nconf->dot11MeshConnectedToMeshGate;
 	ieee80211_mbss_info_change_notify(sdata, BSS_CHANGED_BEACON);
 	return 0;
 }
diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index c813207bb123..cff0fb3578c9 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -641,6 +641,8 @@ IEEE80211_IF_FILE(dot11MeshHWMPconfirmationInterval,
 IEEE80211_IF_FILE(power_mode, u.mesh.mshcfg.power_mode, DEC);
 IEEE80211_IF_FILE(dot11MeshAwakeWindowDuration,
 		  u.mesh.mshcfg.dot11MeshAwakeWindowDuration, DEC);
+IEEE80211_IF_FILE(dot11MeshConnectedToMeshGate,
+		  u.mesh.mshcfg.dot11MeshConnectedToMeshGate, DEC);
 #endif
 
 #define DEBUGFS_ADD_MODE(name, mode) \
@@ -762,6 +764,7 @@ static void add_mesh_config(struct ieee80211_sub_if_data *sdata)
 	MESHPARAMS_ADD(dot11MeshHWMPconfirmationInterval);
 	MESHPARAMS_ADD(power_mode);
 	MESHPARAMS_ADD(dot11MeshAwakeWindowDuration);
+	MESHPARAMS_ADD(dot11MeshConnectedToMeshGate);
 #undef MESHPARAMS_ADD
 }
 #endif
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 19205c821dee..4869280a6413 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -255,7 +255,8 @@ int mesh_add_meshconf_ie(struct ieee80211_sub_if_data *sdata,
 	u8 *pos, neighbors;
 	u8 meshconf_len = sizeof(struct ieee80211_meshconf_ie);
 	bool is_connected_to_gate = ifmsh->num_gates > 0 ||
-		ifmsh->mshcfg.dot11MeshGateAnnouncementProtocol;
+		ifmsh->mshcfg.dot11MeshGateAnnouncementProtocol ||
+		ifmsh->mshcfg.dot11MeshConnectedToMeshGate;
 
 	if (skb_tailroom(skb) < 2 + meshconf_len)
 		return -ENOMEM;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ce8c082e6389..05ac44d6d5c4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6123,7 +6123,9 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	    nla_put_u16(msg, NL80211_MESHCONF_AWAKE_WINDOW,
 			cur_params.dot11MeshAwakeWindowDuration) ||
 	    nla_put_u32(msg, NL80211_MESHCONF_PLINK_TIMEOUT,
-			cur_params.plink_timeout))
+			cur_params.plink_timeout) ||
+	    nla_put_u8(msg, NL80211_MESHCONF_CONNECTED_TO_GATE,
+		       cur_params.dot11MeshConnectedToMeshGate))
 		goto nla_put_failure;
 	nla_nest_end(msg, pinfoattr);
 	genlmsg_end(msg, hdr);
@@ -6180,6 +6182,7 @@ nl80211_meshconf_params_policy[NL80211_MESHCONF_ATTR_MAX+1] = {
 				 NL80211_MESH_POWER_MAX),
 	[NL80211_MESHCONF_AWAKE_WINDOW] = { .type = NLA_U16 },
 	[NL80211_MESHCONF_PLINK_TIMEOUT] = { .type = NLA_U32 },
+	[NL80211_MESHCONF_CONNECTED_TO_GATE] = { .type = NLA_U8 },
 };
 
 static const struct nla_policy
@@ -6291,6 +6294,9 @@ do {									\
 	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, rssi_threshold, mask,
 				  NL80211_MESHCONF_RSSI_THRESHOLD,
 				  nla_get_s32);
+	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshConnectedToMeshGate, mask,
+				  NL80211_MESHCONF_CONNECTED_TO_GATE,
+				  nla_get_u8);
 	/*
 	 * Check HT operation mode based on
 	 * IEEE 802.11-2016 9.4.2.57 HT Operation element.
-- 
2.11.0

