Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:22050 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXJZKcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 06:32:36 -0400
Received: by nf-out-0910.google.com with SMTP id g13so747376nfb
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 03:32:35 -0700 (PDT)
Message-ID: <4721C23E.501@gmail.com> (sfid-20071026_113241_843637_E3FA45E0)
Date: Fri, 26 Oct 2007 12:32:30 +0200
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Dan Williams <dcbw@redhat.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>, Jean Tourrilhes <jt@hpl.hp.com>
Subject: [PATCH] Re: [ipw3945-devel] iwl3945/mac80211 cannot connect to dynamic
 wep network
References: <f6ca9fed0710230054i2b2849bfpc79c6090627b8625@mail.gmail.com>	 <1193127280.3069.261.camel@debian.sh.intel.com>	 <1193148453.8648.20.camel@localhost.localdomain>	 (sfid-20071023_150810_118446_E87EE8F5)  <1193161034.7733.38.camel@johannes.berg>	 <1193238423.2557.41.camel@localhost.localdomain> <1193318969.6092.19.camel@johannes.berg>
In-Reply-To: <1193318969.6092.19.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2007-10-24 at 11:07 -0400, Dan Williams wrote:
>   
>
>> Could you educate me a bit more about the problem if you've got a bit of
>> time?
>>     
>
> As much as I've understood, the problem comes from the privacy mismatch
> function returning non-zero. This means that wpa_supplicant doesn't set
> IW_AUTH_KEY_MGMT_802_1X because if you check the function then the
> key_manegement_enabled variable is checked first thing.
>
>   
I can't verify it right now (won't have access to the dynamic wep ap for 
~10 days), but I tryed to find out whats wrong by reading the code 
(wpa_supplicant and mac80211).



ieee80211_ioctl_siwauth in ieee80211_ioctl.c sets the 
key_management_enabled variable if the value passed to the ioctl is not 
0 to true:
sdata->u.sta.key_management_enabled = !!data->value;
why !!data->value ?  that should be the same as data->value ...

later its in the array ieee80211_handler (same file)
(iw_handler) ieee80211_ioctl_siwauth,        /* SIOCSIWAUTH */

now to wpa_supplicant:
wpa_driver_wext_keymgmt2wext in driver_wext.c  returns 
IW_AUTH_KEY_MGMT_802_1 (which is defined as 1) (when dynamic wep is 
used) wpa_driver_wext_set_auth_param than passes the value using 
ioctl(drv->ioctl_sock, SIOCSIWAUTH, &iwr) to mac80211.

ieee80211_privacy_mismatch checks for
if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL) ||
        ifsta->key_management_enabled)

and returns 0 because ifsta->key_management_enabled  true in this case 
!!1 -> 1
so the attached patch should fix it by doing !data->value (which would 
result in ifsta->key_management_enabled to be 0 here and therefor 
ieee80211_privacy_mismatch won't return 0).

so the problem is that it returns 0 when ifsta->key_management_enabled 
is enabled (resturns 0 for dynamic wep).

the attached (untested!) patch (against 2.6.24-rc1) should fix it:
(I will build a kernel and test with static wep later today to see if I 
broke something)

also please correct me if I am completly wrong.

---

Fix handling of key_management_enabled to make dynamic wep work.

Signed-off-by: Adel Gadllah <adel.gadllah@gmx.net>
---
diff -upNr linux-2.6.23.orign/net/mac80211/ieee80211_ioctl.c 
linux-2.6.23/net/mac80211/ieee80211_ioctl.c
--- linux-2.6.23.orign/net/mac80211/ieee80211_ioctl.c    2007-10-26 
11:14:00.000000000 +0200
+++ linux-2.6.23/net/mac80211/ieee80211_ioctl.c    2007-10-26 
12:23:25.000000000 +0200
@@ -938,7 +938,7 @@ static int ieee80211_ioctl_siwauth(struc
              * that has privacy enabled regardless of not
              * having a key.
              */
-            sdata->u.sta.key_management_enabled = !!data->value;
+            sdata->u.sta.key_management_enabled = data->value;
         }
         break;
     case IW_AUTH_80211_AUTH_ALG:
diff -upNr linux-2.6.23.orign/net/mac80211/ieee80211_sta.c 
linux-2.6.23/net/mac80211/ieee80211_sta.c
--- linux-2.6.23.orign/net/mac80211/ieee80211_sta.c    2007-10-26 
11:14:00.000000000 +0200
+++ linux-2.6.23/net/mac80211/ieee80211_sta.c    2007-10-26 
12:23:35.000000000 +0200
@@ -707,7 +707,7 @@ static int ieee80211_privacy_mismatch(st
     int res = 0;
 
     if (!ifsta || (ifsta->flags & IEEE80211_STA_MIXED_CELL) ||
-        ifsta->key_management_enabled)
+        !ifsta->key_management_enabled)
         return 0;
 
     bss = ieee80211_rx_bss_get(dev, ifsta->bssid, local->hw.conf.channel,




