Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:36426 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002AbXHUASF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 20:18:05 -0400
Message-ID: <46CA2F3B.1060500@lwfinger.net>
Date: Mon, 20 Aug 2007 19:18:03 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Ulrich Kunitz <kune@deine-taler.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: fix software decryption with b43legacy
References: <1187346385.23489.157.camel@johannes.berg> <46C5CC0D.2040609@lwfinger.net> <1187384230.6090.7.camel@johannes.berg> <46C612E8.4020604@lwfinger.net> <1187387215.6090.13.camel@johannes.berg> <46C64777.1000602@lwfinger.net> <1187453173.6090.33.camel@johannes.berg> <46C752FE.4030706@lwfinger.net> <20070820224333.GA6363@deine-taler.de>
In-Reply-To: <20070820224333.GA6363@deine-taler.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ulrich Kunitz wrote:
> Larry Finger wrote:
> 
>> I have added the lists to this message.
>>
>> I got b43legacy up and running with the software decryption modifications. 
>> It started OK with WPA-PSK TKIP encryption, but soon thereafter, I got this 
>> message:
>>
>> eth1: No ProbeResp from current AP 00:1a:70:46:ba:b1 - assume out of range
>>
> 
> Since the git tree reorg wireless-dev branch created comparable
> problems for zd1211rw-mac80211 too. It might be related:
> 
> Aug 19 07:08:51 keks kernel: [   83.572628] wlan0: CCMP replay detected for RX frame from 00:04:0e:68:ad:70 (RX PN 00000000000c <= prev. PN 00000000000c)
> Aug 19 07:08:54 keks kernel: [   87.432010] usb 1-2: handle_regs_int() regs interrupt ignored
> Aug 19 07:08:55 keks kernel: [   87.898447] wlan0: No ProbeResp from current AP 00:04:0e:68:ad:70 - assume out of range
> Aug 19 07:08:55 keks kernel: [   87.899649] wmaster0: Removed STA 00:04:0e:68:ad:70
> Aug 19 07:08:55 keks kernel: [   87.901406] wlan0: set_encrypt - unknown addr 00:04:0e:68:ad:70
> 
> The first message might be a simple duplicate. The
> handle_regs_int() is absolutely suspicious and I cannot really
> explain it right now. The "No ProbeResp" might be a follow-up
> problem. The whole USB subsystem becomes absolutely instable to
> the point that I can't use keyboard and mouse anymore. 
> 
> I will try Johannes' patch tomorrow.
> 
> BTW the wireless-dev reorg makes it impossible to actually use
> git-bisect to find the patch, which caused the problem. 
> 
> BTW the current Linus tree following patch doesn't work with the
> current zd1211rw-mac80211. The offending patch is the following one:
> 
> commit b9bf1e60a294fc7795d5198f94a917290e52865b
> Author: John W. Linville <linville@tuxdriver.com>
> Date:   Tue Aug 7 16:33:15 2007 -0400
> 
>     [PATCH] mac80211: probe for hidden SSIDs in pre-auth scan
>     
>     Probe for hidden SSIDs if initiating pre-authentication scan and SSID
>     is set for STA interface.
>     
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 

This patch is not in my tree, but adding it breaks WEP. WPA fails with it in or out at the moment. 
I'm still looking at that problem.

Larry

