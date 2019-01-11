Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE132C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 09:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70E8B2146F
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 09:40:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BBTJaafC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W+IM2NiC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729608AbfAKJkr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 04:40:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40736 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbfAKJkq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 04:40:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2CFE3608CE; Fri, 11 Jan 2019 09:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547199645;
        bh=/LU2UatsiCJMwfqeE2ISqq6bVy4sAfFHsb2qENuweIo=;
        h=From:To:Cc:Subject:Date:From;
        b=BBTJaafC/ekVDFgl3m3thghNFqJifgeRfb3PbA0gEduLOjGo0RVZbhfonLHZNmceL
         e4Qyg4zC6k2Y4xLMvmF8047mooyJj2FiJnlRqKJa/r0QVQ6jD8eNuT0Befte95SeVT
         YCX7+8wiHt7E2006Iuxy8Ai4XF4E+rN68Ua0gvKc=
Received: from dasaris-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dasaris@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AA313608CB;
        Fri, 11 Jan 2019 09:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547199644;
        bh=/LU2UatsiCJMwfqeE2ISqq6bVy4sAfFHsb2qENuweIo=;
        h=From:To:Cc:Subject:Date:From;
        b=W+IM2NiCZIkwXBlGGeLn8aorYpMODbND8avNUGz07dj3JeZpRn2kzCdCzP5/8mvw/
         hWng4Ks6Dt+sf+Vcd/glwmzxyDPhxLUGnObJSxavOg75lsr60GCnv2oBW/TfSiR7BW
         5XY5gzr4cqf4Ly13RUefRvmzYKR9mJ3aJqkPVc98=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AA313608CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=dasaris@codeaurora.org
From:   Srinivas Dasari <dasaris@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@codeaurora.org>
Subject: [v2] cfg80211: Authentication offload to user space in AP mode
Date:   Fri, 11 Jan 2019 15:10:32 +0530
Message-Id: <1547199632-1302-1-git-send-email-dasaris@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

'commit 40cbfa90218b ("cfg80211/nl80211: Optional authentication
offload to userspace")' introduces authentication offload to user
space by the host drivers in station mode. This commit extends
the same for the AP mode too.

Extend NL80211_ATTR_EXTERNAL_AUTH_SUPPORT to also claim the
support of external authentication from the user space in AP mode.
A new flag parameter is introduced in cfg80211_ap_settings to
intend the same while "start ap" .

Host driver to use NL80211_CMD_FRAME interface to transmit and
receive the authentication frames to / from the user space.

Host driver to indicate the flag NL80211_RXMGMT_FLAG_EXTERNAL_AUTH
while sending the authentication frame to the user space. This
intends to the user space that the driver wishes it to process
the authentication frame for certain protocols, though it had
initially advertised the support for SME functionality.

User space shall accordingly do the authentication and indicate
its final status through the command NL80211_CMD_EXTERNAL_AUTH.
Allow the command even if userspace doesn't include the attribute
NL80211_ATTR_SSID for AP interface.

Host driver shall continue with the association sequence and
indicate the STA connection status through cfg80211_new_sta.

Also enhanced nl80211_external_auth to not mandate SSID in AP mode.

Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>

---
v2:
-Removed consideration of NL80211_IFTYPE_AP_VLAN and NL80211_IFTYPE_P2P_GO
 interfaces for external authentication.
-Removed addition of pmkid in cfg80211_external_auth_params as
 the 'commit 50eee495a5f16c ("cfg80211: Include the PMK and PMKID in
 NL80211_CMD_EXTERNAL_AUTH")' addresses the same.
---
 include/net/cfg80211.h       | 13 +++++++++++++
 include/uapi/linux/nl80211.h | 13 +++++++++----
 net/wireless/nl80211.c       | 21 ++++++++++++++-------
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 15ff426..a87c642 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -836,6 +836,17 @@ struct cfg80211_bitrate_mask {
 };
 
 /**
+ * enum cfg80211_ap_settings_flags - AP settings flags
+ *
+ * Used by cfg80211_ap_settings
+ *
+ * @AP_SETTINGS_EXTERNAL_AUTH_SUPPORT: AP supports external authentication
+ */
+enum cfg80211_ap_settings_flags {
+	AP_SETTINGS_EXTERNAL_AUTH_SUPPORT = BIT(0),
+};
+
+/**
  * struct cfg80211_ap_settings - AP configuration
  *
  * Used to configure an AP interface.
@@ -865,6 +876,7 @@ struct cfg80211_bitrate_mask {
  * @he_cap: HE capabilities (or %NULL if HE isn't enabled)
  * @ht_required: stations must support HT
  * @vht_required: stations must support VHT
+ * @flags: flags, as defined in enum cfg80211_ap_settings_flags
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -890,6 +902,7 @@ struct cfg80211_ap_settings {
 	const struct ieee80211_vht_cap *vht_cap;
 	const struct ieee80211_he_cap_elem *he_cap;
 	bool ht_required, vht_required;
+	u32 flags;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e4486cbb..30e1bb6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2262,10 +2262,10 @@ enum nl80211_commands {
  *     &enum nl80211_external_auth_action value). This is used with the
  *     %NL80211_CMD_EXTERNAL_AUTH request event.
  * @NL80211_ATTR_EXTERNAL_AUTH_SUPPORT: Flag attribute indicating that the user
- *     space supports external authentication. This attribute shall be used
- *     only with %NL80211_CMD_CONNECT request. The driver may offload
- *     authentication processing to user space if this capability is indicated
- *     in NL80211_CMD_CONNECT requests from the user space.
+ *	space supports external authentication. This attribute shall be used
+ *	with %NL80211_CMD_CONNECT and %NL80211_CMD_START_AP request. The driver
+ *	may offload authentication processing to user space if this capability
+ *	is indicated in the respective requests from the user space.
  *
  * @NL80211_ATTR_NSS: Station's New/updated  RX_NSS value notified using this
  *	u8 attribute. This is used with %NL80211_CMD_STA_OPMODE_CHANGED.
@@ -5608,9 +5608,14 @@ enum nl80211_crit_proto_id {
  * Used by cfg80211_rx_mgmt()
  *
  * @NL80211_RXMGMT_FLAG_ANSWERED: frame was answered by device/driver.
+ * @NL80211_RXMGMT_FLAG_EXTERNAL_AUTH: Host driver intends to offload
+ *	the authentication. Exclusively defined for host drivers that
+ *	advertises the SME functionality but would like the userspace
+ *	to handle certain authentication algorithms (e.g., SAE).
  */
 enum nl80211_rxmgmt_flags {
 	NL80211_RXMGMT_FLAG_ANSWERED = 1 << 0,
+	NL80211_RXMGMT_FLAG_EXTERNAL_AUTH = 1 << 1,
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 73345c6..0af5db3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4540,6 +4540,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
 	nl80211_calculate_ap_params(&params);
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_EXTERNAL_AUTH_SUPPORT]))
+		params.flags |= AP_SETTINGS_EXTERNAL_AUTH_SUPPORT;
+
 	wdev_lock(wdev);
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
@@ -13045,7 +13048,8 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->external_auth)
 		return -EOPNOTSUPP;
 
-	if (!info->attrs[NL80211_ATTR_SSID])
+	if (!info->attrs[NL80211_ATTR_SSID] &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP)
 		return -EINVAL;
 
 	if (!info->attrs[NL80211_ATTR_BSSID])
@@ -13062,12 +13066,15 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 
 	memset(&params, 0, sizeof(params));
 
-	params.ssid.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
-	if (params.ssid.ssid_len == 0 ||
-	    params.ssid.ssid_len > IEEE80211_MAX_SSID_LEN)
-		return -EINVAL;
-	memcpy(params.ssid.ssid, nla_data(info->attrs[NL80211_ATTR_SSID]),
-	       params.ssid.ssid_len);
+	if (info->attrs[NL80211_ATTR_SSID]) {
+		params.ssid.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+		if (params.ssid.ssid_len == 0 ||
+		    params.ssid.ssid_len > IEEE80211_MAX_SSID_LEN)
+			return -EINVAL;
+		memcpy(params.ssid.ssid,
+		       nla_data(info->attrs[NL80211_ATTR_SSID]),
+		       params.ssid.ssid_len);
+	}
 
 	memcpy(params.bssid, nla_data(info->attrs[NL80211_ATTR_BSSID]),
 	       ETH_ALEN);
-- 
1.9.1

