Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B80C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 17:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1BA6218AE
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 17:22:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hqMmqeD+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ol69F50t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbeLSRWr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 12:22:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51228 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbeLSRWq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 12:22:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 423CA61B51; Wed, 19 Dec 2018 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545240165;
        bh=hwXd0IWZWSPPXC/8cFwSIKyZw7oDHb+s1VmLXTGnDZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hqMmqeD+H0RGh2uu7ddKcr//fR8SD3bCIofeu7bPMJ8cphamWQP4+/Ff69luEH+Oc
         6w3sSRCkHGdrhS6YgOwAtDWqvn7MLtOUpSwvCFXJNXBX622Xr/MHTjritso7wSyh9t
         MWpvh4u/RKqpCxYtDCUdQNbebgeg6SJ1xs3Kacy4=
Received: from vjakkam-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: vjakkam@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5560160C8A;
        Wed, 19 Dec 2018 17:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545240163;
        bh=hwXd0IWZWSPPXC/8cFwSIKyZw7oDHb+s1VmLXTGnDZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ol69F50tD8r0FOHqE43yArKXi0ptTFtx18zC5ezd3qjtZw+fvuX1Pf9pCRHCkbwjw
         5uz2ymMGSJq9xW+e0Qvj/ubg0ov2zPho25z2rVC37cHBhz7QsnAdd/CTOQGTuRVrnc
         D5VEw22/J+S8TE7DrXxlN8ETaer+47t0m/izekLk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5560160C8A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=vjakkam@codeaurora.org
From:   Veerendranath Jakkam <vjakkam@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Veerendranath Jakkam <vjakkam@codeaurora.org>
Subject: [PATCH v2] cfg80211: Allow drivers to advertise supported AKM suites
Date:   Wed, 19 Dec 2018 22:52:25 +0530
Message-Id: <1545240145-4442-1-git-send-email-vjakkam@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1542368582-3153-1-git-send-email-vjakkam@codeaurora.org>
References: <1542368582-3153-1-git-send-email-vjakkam@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There was no such capability advertisement from the driver and thus the
current user space has to assume the driver to support all the AKMs. While
that may be the case with some drivers (e.g., mac80211-based ones), there
are cfg80211-based drivers that implement SME and have constraints on
which AKMs can be supported (e.g., such drivers may need an update to
support SAE AKM using NL80211_CMD_EXTERNAL_AUTH). Allow such drivers to
advertise the exact set of supported AKMs so that user space tools can
determine what network profile options should be allowed to be configured.

Signed-off-by: Veerendranath Jakkam <vjakkam@codeaurora.org>
---

Changes since v1:
 * Made commit message more clear
 * Made %NL80211_ATTR_AKM_SUITES doc more clear
 * Used single if statement instead of nested if statement

 include/net/cfg80211.h       | 5 +++++
 include/uapi/linux/nl80211.h | 6 ++++++
 net/wireless/nl80211.c       | 6 ++++++
 3 files changed, 17 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0c41eb..ac68792 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4112,6 +4112,8 @@ struct cfg80211_pmsr_capabilities {
  * @signal_type: signal type reported in &struct cfg80211_bss.
  * @cipher_suites: supported cipher suites
  * @n_cipher_suites: number of supported cipher suites
+ * @akm_suites: supported AKM suites
+ * @n_akm_suites: number of supported AKM suites
  * @retry_short: Retry limit for short frames (dot11ShortRetryLimit)
  * @retry_long: Retry limit for long frames (dot11LongRetryLimit)
  * @frag_threshold: Fragmentation threshold (dot11FragmentationThreshold);
@@ -4310,6 +4312,9 @@ struct wiphy {
 	int n_cipher_suites;
 	const u32 *cipher_suites;
 
+	int n_akm_suites;
+	const u32 *akm_suites;
+
 	u8 retry_short;
 	u8 retry_long;
 	u32 frag_threshold;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 31ae5c7..50099a1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1565,6 +1565,12 @@ enum nl80211_commands {
  *	(a u32 with flags from &enum nl80211_wpa_versions).
  * @NL80211_ATTR_AKM_SUITES: Used with CONNECT, ASSOCIATE, and NEW_BEACON to
  *	indicate which key management algorithm(s) to use (an array of u32).
+ *	This attribute is also sent in response to @NL80211_CMD_GET_WIPHY,
+ *	indicating the supported AKM suites, intended for specific drivers which
+ *	implement SME and have constraints on which AKMs are supported and also
+ *	the cases where an AKM support is offloaded to the driver/firmware.
+ *	If there is no such notification from the driver, user space should
+ *	assume the driver supports all the AKM suites.
  *
  * @NL80211_ATTR_REQ_IE: (Re)association request information elements as
  *	sent out by the card, for ROAM and successful CONNECT events.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 71a54ad..182110b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2278,6 +2278,12 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 		if (nl80211_send_pmsr_capa(rdev, msg))
 			goto nla_put_failure;
 
+		if (rdev->wiphy.akm_suites &&
+		    nla_put(msg, NL80211_ATTR_AKM_SUITES,
+			    sizeof(u32) * rdev->wiphy.n_akm_suites,
+			    rdev->wiphy.akm_suites))
+			goto nla_put_failure;
+
 		/* done */
 		state->split_start = 0;
 		break;
-- 
1.9.1

