Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41529 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbDJXcb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2015 19:32:31 -0400
Message-ID: <55285D8D.6070703@candelatech.com> (sfid-20150411_013240_684208_6E07DCEF)
Date: Fri, 10 Apr 2015 16:32:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Subject: CT ath10k firmware now supports IBSS + RSN
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, thanks to everyone that helped me with questions,
QCA/Tieto's upstream patches, etc.

This needs more testing, but it appears to at least mostly work.

I am using this 4.0 related kernel.  I think only the last 3 patches
are IBSS specific, but possibly there are others that matter as well.

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-4.0.dev.y/.git;a=summary

Firmware binaries and release notes are here:
http://www.candelatech.com/downloads/ath10k-fw-beta/

I'm using a very recent wpa_supplicant..upstream should work I think,
but I am using this one:

https://github.com/greearb/hostap-ct/tree/master/hostapd

supplicant needs to have this enabled, among other things:

CONFIG_IBSS_RSN=y


I suspect there are lingering bugs, perhaps in supplicant, as it seems to take
a few tries for the 4-way to happen properly, and I have to re-start hostapd
on each side each time I associate.

My supplicant config files look like this (you can comment out any options
your supplicant doesn't know about...I have a few extra features not specifically
related to IBSS in my hostapd tree)

ctrl_interface=/var/run/wpa_supplicant
fast_reauth=1
concurrent_assoc_ok=1
scan_cur_freq=1
min_scan_gap=5
freq_list=5180

bss_max_count=2000
network={
    ssid="ota-ibss-ssid"
    disable_ht=0
    disable_vht=0
    ieee80211w=0
    disable_ht40=1
    disable_sgi=0
    ht_mcs=""
    disable_max_amsdu=-1
    ampdu_factor=-1
    ampdu_density=-1
    freq_list=5180
    fixed_freq=1

    mode=1
    frequency=5180
    proto=RSN
    key_mgmt=WPA-PSK
    #psk="ben-ota-passwd"
    psk=fc29b6edf32abd7a9818af3c94b2aa5364c785eee33ed3df11605a3db8f905bc
    pairwise=CCMP
    group=CCMP
    proactive_key_caching=0

}


I'm curious to know if anyone tries it out.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

