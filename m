Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:38331 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907AbYDWJtA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 05:49:00 -0400
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <linux-wireless@vger.kernel.org>, <hostap@lists.shmoo.com>
Subject: RE: Roaming problems
Date: Wed, 23 Apr 2008 10:39:32 +0200
Message-ID: <001101c8a51d$8e5997d0$0b3ca8c0@gotws1589> (sfid-20080423_114948_059414_17607EB2)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <00ff01c8a48a$d4063d80$0b3ca8c0@gotws1589>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think I have found the problem.

When the wpa_supplicant configure the device it issues a number of ioctls.
Some of them, ieee80211_ioctl_siwgenie()
ieee80211_ioctl_siwessid() and ieee80211_ioctl_siwap() initiates a
ieee80211_sta_req_auth().
If there is a valid BSSID, ieee80211_sta_req_auth() will post a authenticate
work.

First roaming attempt, no problem since we do not have any valid BSSID.
All following roaming will have the old BSSID when the wpa_supplicant start
preparing for next AP.

So any of the ieee80211_ioctl_siwgenie() or ieee80211_ioctl_siwessid() will
force the mac80211 to start associate with the old BSSID. First when the
ieee80211_ioctl_siwap() arrives, mac80211 knows which AP to use.

If, by timing, the erroneous first association success before the real AP
arrives, the real one may fail, with an infinite 'timed out' as a result.

The below patch makes sure that we drop the BSSID when we disassociate.


/Lars


============================================================================
====
--- a/ieee80211_sta.c	Wed Apr 23 10:14:30 2008
+++ b/ieee80211_sta.c	Wed Apr 23 08:41:23 2008
@@ -479,6 +479,9 @@ static void ieee80211_set_associated(str
 		netif_carrier_off(dev);
 		ieee80211_reset_erp_info(dev);
 		memset(wrqu.ap_addr.sa_data, 0, ETH_ALEN);
+
+		// make sure no association start before we got a new BSSID
+		ifsta->flags &= ~IEEE80211_STA_BSSID_SET;
 	}
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
============================================================================
====



-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Lars Ericsson
Sent: den 22 april 2008 17:09
To: linux-wireless@vger.kernel.org; hostap@lists.shmoo.com
Subject: Roaming problems

Hi, 

I'm currently running a number of sites using the RT61 WLAN chipset.
>From time to time we have fatal roaming problems. 

I have collected a trace that show normal and problem situation.
Any help explaining the cause of the problem is appreciated.

Below is a summary of the trace. Attached it the complete trace.

/Lars


CASE 1: The above trace is a typical trace from a roaming atempt.
==========================================================
361830.763657	We lost conatct with current AP 00:0e:d7:ac:84:20
361831.252992	We have selected the new AP 00:0f:24:d1:5e:e0
361831.256287	Why do we try to authenticate with previous AP
00:0e:d7:ac:84:20 ? <-----
361831.261071	Finaly we selected the correct AP 00:0f:24:d1:5e:e0
361831.295573	We are up and running

CASE 2: The above trace is a typical trace from a roaming atempt.
==========================================================
362123.346748	We lost conatct with current AP 00:0f:24:d1:5e:e0
362123.842242	We have selected the new AP 00:0e:d7:ac:84:20
362123.861586	We try connect AP 00:0e:d7:ac:84:20
362123.874442	We are up and running

CASE 3: The above trace is a typical trace from a roaming atempt.
===================================================================
362441.946825   We lost conatct with current AP 00:0e:d7:ac:84:20
362442.449435	We have selected the new AP 00:0f:24:a3:b8:60
362442.466944	Why do we try to authenticate with previous AP
00:0e:d7:ac:84:20 ? <-----
362442.470147	Finaly we selected the correct AP 00:0f:24:a3:b8:60
361831.295573	We are up and running
362443.066379	Timeout.
362444.886776	New try with selected AP 00:0f:24:a3:b8:60
362444.904429	Associated
362444.904883	What initiate this 'Initial auth_alg=0' with the associated
AP ? <-----
362444.908677	What initiate this 'Initial auth_alg=0' with AP
00:0f:24:d1:5e:e0 ? <-----
362445.505964	No one reacts on the 'timed out' event  <-----

