Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:5429 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbZINLYU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 07:24:20 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: don't report SME connection errs at SIOCSIW{FREQ/AP/ESSID}
Date: Mon, 14 Sep 2009 13:23:44 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200909141254.14988.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909141254.14988.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909141323.44245.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

This fixes

1252921276.182218: Trying to associate with 00:1b:53:11:dc:40 (SSID='TEST' freq=2412 MHz)
ioctl[SIOCSIWFREQ]: No such file or directory
ioctl[SIOCSIWESSID]: No such file or directory
1252921276.268451: Association request to the driver failed
1252921276.355482: Associated with 00:1b:53:11:dc:40

and makes it

1252921276.182218: Trying to associate with 00:1b:53:11:dc:40 (SSID='TEST' freq=2412 MHz)
1252921276.355482: Associated with 00:1b:53:11:dc:40

However, otherwise this hasn't been greatly tested and I
don't have a great understanding of cfg80211, SME, etc ...

Index: linux-wl/net/wireless/wext-sme.c
===================================================================
--- linux-wl.orig/net/wireless/wext-sme.c	2009-09-14 12:05:54.000000000 +0200
+++ linux-wl/net/wireless/wext-sme.c	2009-09-14 12:06:09.000000000 +0200
@@ -110,7 +110,7 @@ int cfg80211_mgd_wext_siwfreq(struct net
 		goto out;
 	}
 
-	err = cfg80211_mgd_wext_connect(rdev, wdev);
+	cfg80211_mgd_wext_connect(rdev, wdev);
  out:
 	wdev_unlock(wdev);
 	mutex_unlock(&rdev->devlist_mtx);
@@ -196,7 +196,7 @@ int cfg80211_mgd_wext_siwessid(struct ne
 
 	wdev->wext.connect.crypto.control_port = false;
 
-	err = cfg80211_mgd_wext_connect(rdev, wdev);
+	cfg80211_mgd_wext_connect(rdev, wdev);
  out:
 	wdev_unlock(wdev);
 	mutex_unlock(&rdev->devlist_mtx);
@@ -283,7 +283,7 @@ int cfg80211_mgd_wext_siwap(struct net_d
 	} else
 		wdev->wext.connect.bssid = NULL;
 
-	err = cfg80211_mgd_wext_connect(rdev, wdev);
+	cfg80211_mgd_wext_connect(rdev, wdev);
  out:
 	wdev_unlock(wdev);
 	mutex_unlock(&rdev->devlist_mtx);

-- 
http://www.holgerschurig.de
