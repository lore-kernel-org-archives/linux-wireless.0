Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64949 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbZKQRsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 12:48:35 -0500
Received: by fxm21 with SMTP id 21so245857fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 09:48:40 -0800 (PST)
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: marcel@holtmann.org
Cc: linux-wireless@vger.kernel.org,
	Janakiram Sistla <janakiram.sistla@gmail.com>
Subject: [PATCH 1/1] Adding radio type FM
Date: Tue, 17 Nov 2009 23:18:33 +0530
Message-Id: <1258480113-20841-1-git-send-email-janakiram.sistla@gmail.com>
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janakiram Sistla <janakiram.sistla@gmail.com>

Adding radio type FM in RFKILL_TYPE_.FM belongs to
same class of with both TX/RX capability.

Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
---
 include/linux/rfkill.h |    1 +
 net/rfkill/core.c      |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index 3392c59..03f5598 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -45,6 +45,7 @@ enum rfkill_type {
 	RFKILL_TYPE_WIMAX,
 	RFKILL_TYPE_WWAN,
 	RFKILL_TYPE_GPS,
+	RFKILL_TYPE_FM,
 	NUM_RFKILL_TYPES,
 };
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index ba2efb9..61b716e 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -590,6 +590,8 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
 		return "wimax";
 	case RFKILL_TYPE_WWAN:
 		return "wwan";
+	case RFKILL_TYPE_FM:
+		return "fm";
 	case RFKILL_TYPE_GPS:
 		return "gps";
 	default:
-- 
1.5.4.3

