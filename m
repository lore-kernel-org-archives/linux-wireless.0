Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42E3AC46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAE6220834
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 21:36:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bobcopeland-com.20150623.gappssmtp.com header.i=@bobcopeland-com.20150623.gappssmtp.com header.b="wH0OIHcf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAE6220834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bobcopeland.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbeJZGK6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 02:10:58 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:40855 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbeJZGK6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 02:10:58 -0400
Received: by mail-it1-f196.google.com with SMTP id i191-v6so3697252iti.5
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2018 14:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bobcopeland-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5uucghljxNNTQEuwopWLWD3CkofJTErGCS/hWk+8+xE=;
        b=wH0OIHcfilflpxjdbw29yTvv9Eq8nInbeHOdxJyEJ0QY1vKm8mUmpcUP/PYAtLhILk
         8VEA1ZdID3QEfY93SA32tHeaJzmx3BiWMVXzMqvB+K3DqLqWk6FYGEMXJH0ArdDxN/QD
         ufU87qJHExoarpP6WevfSfPFb1QEyNWyXguUnH79p57M9PRNIjJz79XdD6uPTsCkpTUj
         F4FIXIm4kliInd3yFn+2Aw8VB2Nzt5663LxzzEVrxpd0zy2V2WZOsFB16wlECHBYe1lk
         J1JiIFLTG1KvRsiv0KOKiz7igKFUN5f7Bco+oevOyUs/iAc3/CKgWPWShE6aN6C96TLv
         b1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5uucghljxNNTQEuwopWLWD3CkofJTErGCS/hWk+8+xE=;
        b=aaXp9j3EIbyNX5sblBelwWBCLmXLjjD4QI07M9/9tbl29npfjxPWXTYYh8NxHe6oNL
         LI1G2yVj/LQk/g9G6d8xR8tTw1Vr9V+2DB7IShGYCsaEavR8RMyzOsExzWAyrmbR+2DM
         fY9MvZOAZKrlf1SLXM7G1niIRBn9AFOT7DvzOKPvebcDEIOC00hnWPmPKdhUYpeiMlM5
         WgVkb7Yj2SnbbeDE+aAyVfQZXAly8FfwPqdlqKJbOLgm8YFj54ArI2ZstAfz6tVa2f76
         lMoBO5ytdjLhCvsyI68i45wyAHHatao3cw5cui3CjyoaE96kqDhCyhc+sI6c8jnbOh9g
         0lxQ==
X-Gm-Message-State: AGRZ1gJKmVCJYhe5m06bGcy4/89hLPqH15rFn/duUgpFI7cOYZ/kr5RN
        mo9AtJqHQNZvmosqEgq3/s3SMw==
X-Google-Smtp-Source: AJdET5fe0Ay6gIEIPfisMfoui4vXjWt0L6vEu7CR4CRY7EgNkQFcJbf43vEhUJwoYYQWrgQwoFx62g==
X-Received: by 2002:a05:660c:487:: with SMTP id a7mr2188778itk.90.1540503395929;
        Thu, 25 Oct 2018 14:36:35 -0700 (PDT)
Received: from hash (CPE30b5c2fb365b-CM18593342f28f.cpe.net.cable.rogers.com. [99.232.51.173])
        by smtp.gmail.com with ESMTPSA id p128-v6sm1184499itp.5.2018.10.25.14.36.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Oct 2018 14:36:35 -0700 (PDT)
Received: from bob by hash with local (Exim 4.89)
        (envelope-from <me@bobcopeland.com>)
        id 1gFnIw-0004hw-90; Thu, 25 Oct 2018 17:36:34 -0400
Date:   Thu, 25 Oct 2018 17:36:34 -0400
From:   Bob Copeland <me@bobcopeland.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, kernel-team@fb.com,
        Bob Copeland <bobcopeland@fb.com>
Subject: [PATCH v2 3/3] {nl,mac}80211: add dot11MeshConnectedToMeshGate to
 meshconf
Message-ID: <20181025213634.hicyzvgfo3xpqusk@localhost>
References: <20181025194854.11676-1-me@bobcopeland.com>
 <20181025194854.11676-3-me@bobcopeland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025194854.11676-3-me@bobcopeland.com>
User-Agent: NeoMutt/20170113 (1.7.2)
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

v2: add policy range and type comment

 include/net/cfg80211.h        | 5 +++++
 include/uapi/linux/nl80211.h  | 8 +++++++-
 net/mac80211/cfg.c            | 3 +++
 net/mac80211/debugfs_netdev.c | 3 +++
 net/mac80211/mesh.c           | 3 ++-
 net/wireless/nl80211.c        | 8 +++++++-
 6 files changed, 27 insertions(+), 3 deletions(-)

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
index f2d79f9b4b5a..ba0dc0afdc29 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3075,7 +3075,7 @@ enum nl80211_sta_bss_param {
  *	some packets with an FCS error due to TA corruption. Hence this counter
  *	might not be fully accurate.
  * @NL80211_STA_INFO_CONNECTED_TO_GATE: set to true if STA has a path to a
- *	mesh gate
+ *	mesh gate (u8, 0 or 1)
  * @__NL80211_STA_INFO_AFTER_LAST: internal
  * @NL80211_STA_INFO_MAX: highest possible station info attribute
  */
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
index ce8c082e6389..12cfd747e59e 100644
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
+	[NL80211_MESHCONF_CONNECTED_TO_GATE] = NLA_POLICY_RANGE(NLA_U8, 0, 1),
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

