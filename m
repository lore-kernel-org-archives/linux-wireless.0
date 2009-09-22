Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:44676 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZIVK7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 06:59:35 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: hostap@lists.shmoo.com
Subject: Re: Comparison of wpa_supplicant with -Dnl80211 and -Dwext, WEP and WPA
Date: Tue, 22 Sep 2009 12:58:44 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909221118.04569.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909221118.04569.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909221258.44921.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> wep_nl80211
> -----------
>  0.00000  0.00000: Initializing interface ...
>  0.03985  0.03985: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
>  0.03992  0.00007: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
>  0.03998  0.00006: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)
>  0.04004  0.00006: ##ERROR: nl80211: set_key failed; err=-67 Link has been severed)

This is because of net/wireless/nl80211.c, function nl80211_key_allowed():

        switch (wdev->iftype) {
	...
        case NL80211_IFTYPE_STATION:
                if (wdev->sme_state != CFG80211_SME_CONNECTED)
                        return -ENOLINK;
                break;


> wep_wext
> --------
>  0.00000  0.00000: Initializing interface ...
>  0.08801  0.08801: Setting scan request: 0 sec 100000 usec
>  0.25167  0.16365: ioctl[SIOCGIWSCAN]: Resource temporarily unavailable

This is because wpa_supplicant very early - in
wpa_driver_wext_finish_drv_init() - calls
wpa_driver_wext_disconnect(). This in turn sets a random 32
character long ESSID, as a desparate means to disconnect.

Now that an essid is set, the calling chain in the kernel

   cfg80211_netdev_notifier_call(), case NETDEV_UP
   cfg80211_mgd_wext_connect()
   __cfg80211_connect()
  cfg80211_conn_scan(

get's executed. This starts a scan.

Later, when wpa_supplicant tries to get a scan result, it will
only get an -EBUSY because of net/wireless/scan.c, function
cfg80211_wext_siwscan():

        if (rdev->scan_req) {
                err = -EBUSY;
                goto out;
        }



However, I'm wondering: if several scan commands are
supposed to add up into the BSS list anyway (and each BSS list
entry by default pruned after 15 seconds), why is it an error
to access the current state of the BSS list while a scan is
in progress?

In other words, I think the following sequence should be ok:

Request Scan
scan finishes
get scan result (2 BSS entries)
request scan
get scan result (2 BSS entries)
scan finishes   (the scan is still in process)
get scan result (5 BSS entries)

If user-space ask for intermediate results, it should be
allowed to do so at any time. If user-space wants full
results, it can wait for the scan-done event.



This would mean that the BSS entries get individual locks
and that rdev->scan_req isn't used as an implicit lock.

-- 
http://www.holgerschurig.de
