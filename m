Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37101 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3EJDLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 23:11:45 -0400
Received: by mail-pd0-f178.google.com with SMTP id w11so2424467pde.23
        for <linux-wireless@vger.kernel.org>; Thu, 09 May 2013 20:11:44 -0700 (PDT)
Subject: Re: atheros AR5B22, using ath9k, can't switch between inscure and
 WEP/WPA
From: Wally <wally.yeh@a-trust.com.tw>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
In-Reply-To: <20875.9473.525821.266607@gargle.gargle.HOWL>
References: <1368015905.17674.11.camel@bigdick-desktop>
	 <20875.9473.525821.266607@gargle.gargle.HOWL>
Content-Type: multipart/mixed; boundary="=-y4owzFGAc1KfqIEduf+U"
Date: Fri, 10 May 2013 11:16:33 +0800
Message-ID: <1368155793.17674.116.camel@bigdick-desktop> (sfid-20130510_051150_057925_8CDE5468)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y4owzFGAc1KfqIEduf+U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit

於 四，2013-05-09 於 09:54 +0530，Sujith Manoharan 提到：
> Wally wrote:
> >     Recently I got a atheros mini-PCIE wifi module AR5B22, so I download
> > the latest version of compat-driver(compat-drivers-2013-03-28.tar.gz),
> > and build it for armel on my arm board, it works great but with one
> > little problem:
> > 
> > If I connect to an inscure AP then change to a WEP/WPA AP, I can't
> > connect the inscure one again, I have to run "modprobe -r ath9k;
> > modprobe ath9k" to connect the inscure AP.
> > 
> >     I think this may be a bug in the ath9k driver, I also search this
> > bug on web but without an answer, so I send this letter for help.
> 
> What commands do you use to connect to the APs ? Also, can you post the
> kernel log / wpa_supplicant log when the issue happens ?
> 
> Sujith

Hi, Sujjth:
    I do following steps to reproduce this problem:
/**********************************************************************/        
    first step, I connect to an inscure AP
        1. sudo iwconfig wlan0 mode managed key off essid "dlink FRANCE"
        2. sudo dhclient wlan0

    dmesg give these messages:
[  224.937500] wlan0: authenticate with 00:1c:f0:eb:9a:ed
[  224.945312] wlan0: send auth to 00:1c:f0:eb:9a:ed (try 1/3)
[  224.953125] wlan0: authenticated
[  224.953125] ath9k 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not
supported by the AP
[  224.953125] ath9k 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is
not supported by the AP
[  224.960937] wlan0: associate with 00:1c:f0:eb:9a:ed (try 1/3)
[  224.960937] wlan0: RX AssocResp from 00:1c:f0:eb:9a:ed (capab=0x421
status=0 aid=2)
[  224.960937] wlan0: associated



    second step, I connect to another WEP AP:
        1. sudo dhclient -r
        2. sudo iwconfig wlan0 mode managed essid "sw-wifi"
        3. sudo wpa_supplicant -B -D wext -i wlan0 -c ./auth_file
        4. sudo dhclient wlan0

    dmesg give these messages:
[ 1425.843750] wlan0: deauthenticating from 00:1c:f0:eb:9a:ed by local
choice (reason=3)
[ 1436.296875] wlan0: authenticate with 00:26:5a:ff:c9:6d
[ 1436.312500] wlan0: send auth to 00:26:5a:ff:c9:6d (try 1/3)
[ 1436.312500] wlan0: deauthenticating from 00:26:5a:ff:c9:6d by local
choice (reason=3)
[ 1436.312500] wlan0: authenticate with 00:26:5a:ff:c9:6d
[ 1436.328125] wlan0: send auth to 00:26:5a:ff:c9:6d (try 1/3)
[ 1436.328125] wlan0: send auth to 00:26:5a:ff:c9:6d (try 2/3)
[ 1436.328125] wlan0: authenticated
[ 1436.328125] ath9k 0000:01:00.0: wlan0: disabling HT/VHT due to
WEP/TKIP use
[ 1436.328125] ath9k 0000:01:00.0: wlan0: disabling HT as WMM/QoS is not
supported by the AP
[ 1436.328125] ath9k 0000:01:00.0: wlan0: disabling VHT as WMM/QoS is
not supported by the AP
[ 1436.335937] wlan0: associate with 00:26:5a:ff:c9:6d (try 1/3)
[ 1436.335937] wlan0: RX AssocResp from 00:26:5a:ff:c9:6d (capab=0x431
status=0 aid=16)
[ 1436.335937] wlan0: associated

    third step, I reconnect the inscure AP agian and failed:
        1. sudo dhclient -r
        2. sudo killall wpa_supplicant
        2. sudo iwconfig wlan0 mode managed key off essid "dlink FRANCE"
        3. sudo dhclient wlan0 <-- system can't get an IP forever...

    dmesg give these messages:
[ 2049.585937] wlan0: deauthenticating from 00:26:5a:ff:c9:6d by local
choice (reason=3)
[ 2049.609375] cfg80211: Calling CRDA to update world regulatory domain
/**********************************************************************/

    very weird, at third step, dmesg only print two messages, and not
start to do authenticate anymore. if I retry second step, it still can
connect WEP/WPA APs.

    Hope this messages helps. the attach file is my auth_file using in
second step.

Wally

--=-y4owzFGAc1KfqIEduf+U
Content-Disposition: attachment; filename="auth_file"
Content-Type: text/plain; name="auth_file"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

ctrl_interface=/var/run/wpa_supplicant
network={
scan_ssid=0
ssid="sw-wifi"
key_mgmt=NONE
wep_key0="3616atrust361"
wep_tx_keyidx=0
priority=5
}

--=-y4owzFGAc1KfqIEduf+U--

