Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:63091 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbZJMTnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 15:43:20 -0400
Received: by mail-fx0-f227.google.com with SMTP id 27so10623464fxm.17
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2009 12:43:09 -0700 (PDT)
Date: Tue, 13 Oct 2009 21:37:16 +0200
From: Richard Zidlicky <rz@linux-m68k.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.31.[12] ath5k regression
Message-ID: <20091013193716.GA13427@linux-m68k.org>
References: <20090625083636.GA6323@linux-m68k.org> <20090705123105.GE2132@hash.localnet> <20091009143922.GA7848@linux-m68k.org> <20091010125824.GA18841@hash.localnet> <20091011122616.GA27105@linux-m68k.org> <20091011133010.GA21494@hash.localnet> <20091011220002.GA11603@linux-m68k.org> <20091011222142.M14763@bobcopeland.com> <20091012202316.GA8310@linux-m68k.org> <20091012235438.GA24539@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091012235438.GA24539@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 12, 2009 at 07:54:38PM -0400, Bob Copeland wrote:
> On Mon, Oct 12, 2009 at 10:23:16PM +0200, Richard Zidlicky wrote:
> > it works like in mainline and fails.
> 
> Huh, well it should be equivalent to your patch, so I'm stumped
> as to why.

mee too. I am trying to verify all variants because I do remember that adding the 
change_chan patch on top of clean 2.6.31 broke that while I do vaguely remember that
reverting this patch form 2.6.31.[23] did not make a working wlan.
However testing is time consuming - the machine requires allways a complete shutdown, 
power off reboot.

Strange things were happening even in 2.6.31 - for example my ad-hoc network was listed 
twice by iwlist scan - strangely one of the entries has 0db signal strength. Similar
listing on both ends.

Here is what the other end is reporting if that is of any help..

### ath5k end shut down here ###
[52262.000044] wlan0: expiring inactive STA 00:22:43:2c:76:0f
[52262.000050] phy6: Removed STA 00:22:43:2c:76:0f
[52262.003025] phy6: Destroyed STA 00:22:43:2c:76:0f
[52343.404540] wlan0: RX ProbeReq SA=00:60:b3:06:f4:17 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[52345.711165] wlan0: RX ProbeReq SA=00:60:b3:06:f4:17 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
...
...
...
...
[52350.930907] wlan0: RX ProbeReq SA=00:60:b3:06:f4:17 DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[52881.645705] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[52881.645711] wlan0: Sending ProbeResp to 00:22:43:2c:76:0f
[52883.886696] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[52883.886702] wlan0: Sending ProbeResp to 00:22:43:2c:76:0f
[52915.330070] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[52947.327315] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53011.323892] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53106.964036] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53138.613029] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53266.603257] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53298.604621] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53330.599864] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53362.598110] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53382.140098] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)
[53382.140104] wlan0: Sending ProbeResp to 00:22:43:2c:76:0f
[53413.898474] wlan0: RX ProbeReq SA=00:22:43:2c:76:0f DA=ff:ff:ff:ff:ff:ff BSSID=ff:ff:ff:ff:ff:ff (tx_last_beacon=1)

Richard
