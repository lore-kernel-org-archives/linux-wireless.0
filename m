Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:40425 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3IJF7z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 01:59:55 -0400
Message-ID: <522EB51A.2080004@ilande.co.uk> (sfid-20130910_080007_379578_991C56AF)
Date: Tue, 10 Sep 2013 06:58:50 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk> <522E896E.7000607@lwfinger.net>
In-Reply-To: <522E896E.7000607@lwfinger.net>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/13 03:52, Larry Finger wrote:

> We now know that the beacons are being lost. The last one was at
> 90600.642566 as shown below:
>
> Sep 10 00:29:48 kentang kernel: [90599.513526] rtlwifi: mode 2, state 2,
> is_beacon 1, is_probe_resp 0, length 153
> Sep 10 00:29:50 kentang kernel: [90600.642566] rtlwifi: mode 2, state 2,
> is_beacon 1, is_probe_resp 0, length 153
> Sep 10 00:29:57 kentang kernel: [90607.829051]
> rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now
> Sep 10 00:29:57 kentang kernel: [90607.829058] wlan1: Connection to AP
> 00:1f:9f:d5:a8:3b lost
> Sep 10 00:29:57 kentang kernel: [90607.830086] cfg80211: Calling CRDA to
> update world regulatory domain
>
> We have to conclude that your interface has been shut down as we have
> gotten no beacons or RX data packets received. Unfortunately, my
> restricting the output to only your AP does not let me know if any data
> are being received. I hate to do this, but the attached patch will dump
> all packets again with no limit. Once you get a disconnect, then you can
> stop the run before the log gets too full.

No worries - disk space is reasonably cheap these days ;)

dmesg output:
http://www.ilande.co.uk/tmp/rtl8192cu_patch-4-dmesg.txt

wpa_supplicant output:
http://www.ilande.co.uk/tmp/rtl8192cu_patch-4-wpa_supplicant.txt

I noticed that I got several re-authentication attempts in the dmesg 
output without the corresponding rtl_watchdog_wq_callback() line being 
emitted - this is again something I don't see with zd1211rw and iwlwifi. 
Once these drivers are associated, they seem to stay in that state for 
hours.

Whilst checking various parts of my kernel, I noticed for the first time 
during testing that my current kernel configuration doesn't have SMP 
enabled. This got me thinking that perhaps there are other build options 
which could have an effect on the driver. Hence I also uploaded a copy 
of my .config file to http://www.ilande.co.uk/tmp/rtl8192cu-config in 
the hope that maybe this can help you recreate the issue locally?


ATB,

Mark.
