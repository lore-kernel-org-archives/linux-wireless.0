Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98865ECDE3D
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D5E420869
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 09:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IybuD/BZ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Cx/9uata"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D5E420869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbeJSRSX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 13:18:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbeJSRSX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 13:18:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3E63260769; Fri, 19 Oct 2018 09:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539940390;
        bh=tj72t6AZnmJOVK+1zB4Tze28n9pLlYcI6TZvhkoyjj4=;
        h=From:To:Cc:Subject:Date:From;
        b=IybuD/BZ4zAYHK2PgXYLeKTx2gbqccl7CuuEQF++o8wAMtm8dgHBEgOOcHyW1rcMW
         Uz2J7tZ85Xbt0Ji6dhsUlOgCEQT5aB2MC7NmJ1zJ8QDP1gKKXgoIQSjG07DwOSVpEq
         jOasGEkxEjJyPYeJtehXwuVdTar+O28gAo9zJOFw=
Received: from checstp253621-lin.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: srirrama@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C013960316;
        Fri, 19 Oct 2018 09:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539940389;
        bh=tj72t6AZnmJOVK+1zB4Tze28n9pLlYcI6TZvhkoyjj4=;
        h=From:To:Cc:Subject:Date:From;
        b=Cx/9uataeA9hZ+W/f6yOgXL4KC013uC3N+kBa0KGGviFZLlx3oObKvQH1a1Iog7IN
         yVg2l5Tx+4Kil2sJVLKM8hgFNjFbIbTsX/egXwSF9dy50CwH3poQiXz1loa6Y+dbI1
         wS5ZJ1WXrtSdJRqphUlu4n/AqhQB1AA5DnEY7g0w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C013960316
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=srirrama@codeaurora.org
From:   Sriram R <srirrama@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [PATCH] cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces
Date:   Fri, 19 Oct 2018 14:42:59 +0530
Message-Id: <1539940379-1395-1-git-send-email-srirrama@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently when an AP and STA interfaces are active in the same or different
radios, regulatory settings are restored whenever the STA disconnects. This
restores all channel information including dfs states in all radios.
For example, if an AP interface is active in one radio and STA in another,
when radar is detected on the AP interface, the dfs state of the channel
will be changed to UNAVAILABLE. But when the STA interface disconnects,
this issues a regulatory disconnect hint which restores all regulatory
settings in all the radios attached and thereby losing the stored dfs
state on the other radio where the channel was marked as unavailable
earlier. Hence prevent such regulatory restore whenever another active
beaconing interface is present in the same or other radios.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 net/wireless/sme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index d536b07..c7047c7 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -642,11 +642,15 @@ static bool cfg80211_is_all_idle(void)
 	 * All devices must be idle as otherwise if you are actively
 	 * scanning some new beacon hints could be learned and would
 	 * count as new regulatory hints.
+	 * Also if there is any other active beaconing interface we
+	 * need not issue a disconnect hint and reset any info such
+	 * as chan dfs state, etc.
 	 */
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			wdev_lock(wdev);
-			if (wdev->conn || wdev->current_bss)
+			if (wdev->conn || wdev->current_bss ||
+			    cfg80211_beaconing_iface_active(wdev))
 				is_all_idle = false;
 			wdev_unlock(wdev);
 		}
-- 
2.7.4

