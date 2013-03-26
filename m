Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40312 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172Ab3CZU6w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 16:58:52 -0400
Received: from sycorax.lbl.gov (romosan@localhost [127.0.0.1])
	by sycorax.lbl.gov (8.14.4/8.14.4/Debian-4) with ESMTP id r2QKqd58022373
	for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 13:52:39 -0700
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: linux-wireless@vger.kernel.org
Subject: iwlwifi unable to reconnect after suspend since v3.9-rc1
Date: Tue, 26 Mar 2013 13:52:39 -0700
Message-ID: <87li993mug.fsf@sycorax.lbl.gov> (sfid-20130326_215912_863066_7A8A33F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

since v3.9-rc1 i have been unable to reconnect to my access point. the
access point is a netgear n600 and the my card is a Centrino Advanced-N
6205 [Taylor Peak] (rev 34). the last kernel that worked was 3.8. when i
boot up the laptop the connection is established but if i bring down the
network with ifdown then i cannot reconnect. this is what i see in the
logs:

 iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
 iwlwifi 0000:03:00.0: Radio type=0x1-0x2-0x0
 wlan0: authenticate with xx:xx:xx:xx:xx:xx
 wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
 wlan0: send auth to xx:xx:xx:xx:xx:xx (try 2/3)
 wlan0: send auth to xx:xx:xx:xx:xx:xx (try 3/3)
 wlan0: authentication with xx:xx:xx:xx:xx:xx timed out

today i discovered that this happens only if i connect to the 5GHz.
connecting to 2.4GHz works on resume. i tried to do a 'git bisect start
-- drivers/net/wireless' and i ended up with

Bisecting: 0 revisions left to test after this (roughly 0 steps)
[e1a0c6b3a4b27ed5f21291d0bbee2167ec201ef5] mac80211: stop toggling IEEE80211_HT_CAP_SUP_WIDTH_20_40

but i haven't been able to revert it cleanly so i don't know if that's
the problem or not?

any ideas? thanks.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
