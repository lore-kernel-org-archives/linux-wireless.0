Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f217.google.com ([209.85.219.217]:53307 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZJGCww (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 22:52:52 -0400
Received: by ewy17 with SMTP id 17so169810ewy.39
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 19:52:15 -0700 (PDT)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Cc: Hin-Tak Leung <HinTak.Leung@gmail.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>
Subject: [PATCH] compat-2.6: adjusting 01-netdev.patch for libertas cfg80211 support
Date: Wed,  7 Oct 2009 03:50:57 +0100
Message-Id: <1254883857-2252-1-git-send-email-HinTak.Leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjusting the netdev patch slightly to cope with recent change
in libertas regarding cfg80211 support:

    commit 6c65edc7a3e9452509a898cc9bbc210b0121617f
    Author: Holger Schurig <hs4233@mail.mn-solutions.de>
    Date:   Tue Oct 6 16:31:54 2009 +0200

        libertas: first stab at cfg80211 support

Signed-off-by: Hin-Tak Leung <htl10@users.sourceforge.net>
---
 compat/patches/01-netdev.patch |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/compat/patches/01-netdev.patch b/compat/patches/01-netdev.patch
index 141f80b..f6bca3e 100644
--- a/compat/patches/01-netdev.patch
+++ b/compat/patches/01-netdev.patch
@@ -416,9 +416,9 @@ without creating a headache on maintenance of the pathes.
  /**
   * @brief This function adds the card. it will probe the
 @@ -1270,7 +1272,16 @@
- 	priv->infra_open = 0;
+ 	wdev->netdev = dev;
+ 	priv->dev = dev;
  
- 	/* Setup the OS Interface to our functions */
 +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,29))
   	dev->netdev_ops = &lbs_netdev_ops;
 +#else
-- 
1.6.5.rc2

