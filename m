Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:27265 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYHLGjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 02:39:02 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id BF59D14800A
	for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 08:38:59 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ORGucIzcKspc for <linux-wireless@vger.kernel.org>;
	Tue, 12 Aug 2008 08:38:59 +0200 (CEST)
Received: from lin01.mn-solutions.de (p578b4334.dip0.t-ipconnect.de [87.139.67.52])
	by mx51.mymxserver.com (Postfix) with ESMTP id 88765148009
	for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 08:38:59 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 79E971E00D4
	for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 08:38:53 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Pondering: how to improve mac80211 roaming ...
Date: Tue, 12 Aug 2008 08:38:52 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808120838.52888.hs4233@mail.mn-solutions.de> (sfid-20080812_083908_497329_43153C14)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

The last days I looked a bit at mac80211 and how it works. While
doing this, I detected that mac80211 does virtually no roaming.
That is, it is very usable for a hot-spot setup (Office, Home,
Starbucks), but not for a place where you have 20 Access-Points
and move between them.

It looks like that somebody (Jiri?) also detected this, because
I found he following TODO in mlme.c:

    /* TODO: start monitoring current AP signal quality and number of
     * missed beacons. Scan other channels every now and then and search
     * for better APs. */

While pondering about this, I had some thought which I wanted to
confirm with the greater community, so that I don't make a patch
that won't be accepted.


How to detect missed beacons?
-----------------------------
When I know the beacon period, I could setup a timer
with "beacon_period + beacon_period*0.5". In the timer function I
could then increase a missed beacon counter and act accordingly,
e.g. search for APs, roam etc.

But how would I determine the beacon period?


Is detection of missed beacons good enought?
--------------------------------------------
For me this approach seems like driving a car into the wall of a
house. Then crash-detection notifies me and I'd search for a new
way to drive.

Certainly it's better to act before the accident happens, so I'd
rather do it differently. With a fullmac driver I looked at the
RSSI and, when it fell below a certain threshhold, started the
roaming.

In mac80211, I could do this in ieee80211_rx_bss_info(), in the
vincinity of those lines:

        bss->timestamp = beacon_timestamp;
        bss->last_update = jiffies;
        bss->signal = rx_status->signal;
        bss->noise = rx_status->noise;
        bss->qual = rx_status->qual;
        if (!beacon && !bss->probe_resp)
                bss->probe_resp = true;

        /*
         * In STA mode, the remaining parameters should not be overridden
         * by beacons because they're not necessarily accurate there.
         */
        if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
            bss->probe_resp && beacon) {
                ieee80211_rx_bss_put(local, bss);
                return;
        }


In-kernel or in-userspace?   --- or hybrid?
-------------------------------------------
Some people say that in-userspace roaming is the way to go.
Maybe. But in-kernel, I have more information. In the mac80211
case, the above quoted code is executed whenever I receive a
beacon. So I can very quickly react to declining SNR. Userspace
would have to issue periodically scan requests and process them,
quite a bit of overhead.

But there is existing user-space code that does roaming, e.g. WPA
Supplicant and (probably, not sure) Network-Manager.

So I think I'd opt to a hybrid approach. Userspace uses cfg80211
to configure some roaming threshold to mac80211. mac80211 would
gain AP-is-about-to-fail detection and, if it detects this, it
would signal via cfg80211 (is this possible?) to user-space that
it should now roam.

Userspace then could, while still associated, scan for other APs
(e.g. first on preferred channels, like 1,6,11, then on all
channels) and if it finds something, trigger association to
another AP.


For a WEP or non-encrypted environment a in-kernel-roaming would
be possible, this would bring a similar behavior to mac80211 that
common fullmac drivers exhibit. But my first goal would not be in
this area.
