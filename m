Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94B54C43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 656B720679
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 09:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FrygCkTU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfDZJzN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 05:55:13 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:32785 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfDZJzN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 05:55:13 -0400
Received: by mail-pg1-f193.google.com with SMTP id k19so1394587pgh.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 02:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TWdmDAzMycfKX5qh9PSXESLf0Hjn7hPWGkjDGrWBES4=;
        b=FrygCkTU1Gjv2x+dN9W6aKWT0r3LDtAO4ElRcLhG9onRbpSO/HxX7KLgWPJU3kbvVQ
         lkLDrg9nNiRos3/uLZj6OKDlVAyA8hZkY4j0qQMoahlQ8R8LUnFr/AonAgBYyqDPKyNd
         p+8EBzsIXi2dmy8gITSVm278q6Za+LxrxS8xV/9gVYf/Pcvcol+I5heFBLgHPDVpRvym
         I8Esq82sO89zL6zr6/P0Q6jV/G7D2rPHsxTlzbUWZSc9meCunDLgDuWTXDnIXE5nwrgf
         jQbfYdEgQ20bEtKVEmYzbSnstDiR/41C2LGqBJUW9gQApBVbp7oae1Ufi60JqNqVzsTH
         NQxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=TWdmDAzMycfKX5qh9PSXESLf0Hjn7hPWGkjDGrWBES4=;
        b=mY2iJh6H2hA0RmhNbuqLe+GwAcBkToeVV8xTn2ZL5PB46EiMQ+/5gNDJoXky95/3/A
         xJTHJncjIncUkUchVMrZZv04lRyieUQR12yj1RGubwK0GtYvD3r346a7M1ooWZmnUVhH
         6GCtCiuCf/YWiuYtFwQMlGFCGy28duqbkhEONFVhwSp6kMBQ4q62BTMkx5XkGYPNm/tf
         1Kw3Aqnn3LIDks5VfSAhbskjTXzapyz+8niNcGT2NGHN1tfW/PTBlWMPIGGzrvjOyZ2C
         R2OKrplGnHPgJ9VjgplTjUtu/8aZKuI6jH89JCbbhIPk8uCcHrCnYRumJfNGiq55oQrr
         uLQA==
X-Gm-Message-State: APjAAAUHPogSi1c8xVibb7DcCFB/prkYp7lsH9CejRzEpMkFFkPSV4+5
        57bhszxWQTEonfyxVULlKqmBOmYY71Y=
X-Google-Smtp-Source: APXvYqw/TdsUfpY/VLpJNujoc5gT5j/T/A/Hk8MCEPk5procHzmp0yEimvntarYjUsSmCaUuRFADMw==
X-Received: by 2002:a63:4c26:: with SMTP id z38mr43523520pga.425.1556272512119;
        Fri, 26 Apr 2019 02:55:12 -0700 (PDT)
Received: from BWT-FWA-0475.bluwirelesstechnology.com ([103.248.210.66])
        by smtp.gmail.com with ESMTPSA id g67sm36858934pfg.94.2019.04.26.02.55.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 02:55:11 -0700 (PDT)
From:   chaitanya.mgit@gmail.com
To:     linux-wireless@vger.kernel.org
Cc:     Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
Subject: [PATCH] cfg80211: Handle bss expiry during connection
Date:   Fri, 26 Apr 2019 15:24:48 +0530
Message-Id: <20190426095448.3169-1-chaitanya.mgit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>

If the BSS is expired during connection, the connect result will
trigger a kernel warning. Ideally cfg80211 should hold the BSS
before the connection is attempted, but as the BSSID is not known
in case of auth/assoc MLME offload (connect op) it doesn't.

For those drivers without the connect op cfg80211 holds down the
reference so it wil not be removed from list.

Fix this by removing the warning and silently adding the BSS back to
the bss list which is return by the driver (with proper BSSID set).
The requirements for drivers are documented in the API's.

Signed-off-by: Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
---
Tested this using the below hack in cfg80211_connect_done():
	cfg80211_bss_age(rdev, get_seconds() - 30);
	cfg80211_bss_expire(rdev);
---
 include/net/cfg80211.h | 13 ++++++++++---
 net/wireless/core.h    |  5 +++++
 net/wireless/scan.c    |  2 +-
 net/wireless/sme.c     | 13 ++++++++-----
 4 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb307a11ee63..91fee5ab2433 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -6137,8 +6137,12 @@ struct cfg80211_fils_resp_params {
  *	case.
  * @bssid: The BSSID of the AP (may be %NULL)
  * @bss: Entry of bss to which STA got connected to, can be obtained through
- *	cfg80211_get_bss() (may be %NULL). Only one parameter among @bssid and
- *	@bss needs to be specified.
+ *	cfg80211_get_bss() (may be %NULL) but it is recommended to store the
+ *	bss from the connect_request and hold a reference to it and return
+ *	through this param to avoid warning if the bss is expired during the
+ *	connection, esp. for those drivers implementing connect op.
+ *	Only one parameter among @bssid and @bss needs to be specified.
+
  * @req_ie: Association request IEs (may be %NULL)
  * @req_ie_len: Association request IEs length
  * @resp_ie: Association response IEs (may be %NULL)
@@ -6187,7 +6191,10 @@ void cfg80211_connect_done(struct net_device *dev,
  * @dev: network device
  * @bssid: the BSSID of the AP
  * @bss: entry of bss to which STA got connected to, can be obtained
- *	through cfg80211_get_bss (may be %NULL)
+ *	through cfg80211_get_bss (may be %NULL), but it is recommended to store
+ *	the bss from the connect_request and hold a reference to it and return
+ *	through this param to avoid warning if the bss is expired during the
+ *	connection, esp. for those drivers implementing connect op.
  * @req_ie: association request IEs (maybe be %NULL)
  * @req_ie_len: association request IEs length
  * @resp_ie: association response IEs (may be %NULL)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 84d36ca7a7ab..7ad461845d07 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -531,6 +531,11 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 		       struct wireless_dev *wdev);
 
+struct cfg80211_internal_bss *
+cfg80211_bss_update(struct cfg80211_registered_device *rdev,
+		    struct cfg80211_internal_bss *tmp,
+		    bool signal_valid);
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 287518c6caa4..0f5ae54c7644 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1035,7 +1035,7 @@ struct cfg80211_non_tx_bss {
 };
 
 /* Returned bss is reference counted and must be cleaned up appropriately. */
-static struct cfg80211_internal_bss *
+struct cfg80211_internal_bss *
 cfg80211_bss_update(struct cfg80211_registered_device *rdev,
 		    struct cfg80211_internal_bss *tmp,
 		    bool signal_valid)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 7d34cb884840..6881d0b151b2 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -795,14 +795,17 @@ void cfg80211_connect_done(struct net_device *dev,
 	unsigned long flags;
 	u8 *next;
 
+	/* bss is not NULL, so even though bss might have expired, the driver
+	 * is still holding a reference to it.
+	 */
 	if (params->bss) {
-		/* Make sure the bss entry provided by the driver is valid. */
 		struct cfg80211_internal_bss *ibss = bss_from_pub(params->bss);
 
-		if (WARN_ON(list_empty(&ibss->list))) {
-			cfg80211_put_bss(wdev->wiphy, params->bss);
-			return;
-		}
+		/* Meanwhile if BSS is expired then add it back to the list as
+		 * we have just connected with it.
+		 */
+		if (list_empty(&ibss->list))
+			cfg80211_bss_update(rdev, ibss, ibss->pub.signal);
 	}
 
 	ev = kzalloc(sizeof(*ev) + (params->bssid ? ETH_ALEN : 0) +
-- 
2.17.1

