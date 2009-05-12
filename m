Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51073 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbZELGcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 02:32:35 -0400
Subject: Re: [PATCH] cfg80211: implement wext key handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	Samuel Ortiz <sameo@linux.intel.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <3ace41890905111516m2d5f9f70k83edbdef1ca6e2b8@mail.gmail.com>
References: <1242042898.18637.0.camel@johannes.local>
	 <1242049846.28322.12.camel@localhost.localdomain>
	 <1242050962.29777.12.camel@johannes.local>
	 <3ace41890905111516m2d5f9f70k83edbdef1ca6e2b8@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 12 May 2009 08:32:23 +0200
Message-Id: <1242109943.3873.51.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-05-11 at 23:16 +0100, Hin-Tak Leung wrote:

> Argh, is this the reason why compat-wireless(wireless-testing?) today
> doesn't quite work any more?
> NetworkManager no longer wants to work, with this message in syslog:
> 
> localhost NetworkManager: <WARN>  nm_device_wifi_disable_encryption():
> error setting key for device wlan2: Invalid argument

I don't think NM cares about the return value of this call.

> and trying to do it by hand give this error:
> 
> #iwconfig wlan2 key restrict <key>
> Error for wireless request "Set Encode" (8B2A) :
>     SET failed on device wlan2 ; Invalid argument.

Remove the "restrict", afaict we never supported that argument in
mac80211.

Anyway, I think there's a small bug when removing keys -- below patch
should fix it. wpa_supplicant worked fine with my patch fwiw.

johannes

---
 net/wireless/wext-compat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/net/wireless/wext-compat.c	2009-05-12 08:29:02.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-05-12 08:29:17.000000000 +0200
@@ -580,7 +580,7 @@ int cfg80211_wext_siwencode(struct net_d
 		params.cipher = WLAN_CIPHER_SUITE_WEP40;
 	else if (erq->length == 13)
 		params.cipher = WLAN_CIPHER_SUITE_WEP104;
-	else
+	else if (!remove)
 		return -EINVAL;
 
 	return cfg80211_set_encryption(rdev, dev, NULL, remove,


