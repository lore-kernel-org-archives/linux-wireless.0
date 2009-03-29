Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42796 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZC2Ufl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 16:35:41 -0400
Received: by ewy9 with SMTP id 9so1804269ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 13:35:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903292109.55033.rossi.f@inwind.it>
References: <20090315202035.GC5246@makis>
	 <200903292109.55033.rossi.f@inwind.it>
Date: Sun, 29 Mar 2009 23:35:37 +0300
Message-ID: <40f31dec0903291335j2befd3b4r1b4f4619ae634113@mail.gmail.com> (sfid-20090329_223542_816994_9F799430)
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
From: Nick Kossifidis <mickflemm@gmail.com>
To: Fabio Rossi <rossi.f@inwind.it>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/3/29 Fabio Rossi <rossi.f@inwind.it>:
> On Sunday 15 March 2009, Nick Kossifidis wrote:
>
>> =C2=A0* Add tx power calibration support
>> =C2=A0* Add a few tx power limits
>> =C2=A0* Hardcode default power to 12.5dB
>> =C2=A0* Disable TPC for now
>>
>> =C2=A0v2: Address Jiri's comments
>>
>> =C2=A0Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> After bisecting I have found that this patch causes a regression with=
 my
> wireless PCI board:

[...]

>
> With the problematic patch there is no frequency sweep after the "iwc=
onfig
> essid" command and I can't associate anymore (the frequency remains s=
tuck to
> 5.18GHz but I work with 802.11G)
>
> Mar 29 11:08:45 kernel: cfg80211: Calling CRDA to update world regula=
tory
> domain
> Mar 29 11:08:45 kernel: ath5k 0000:00:0b.0: PCI INT A -> Link[LNKB] -=
> GSI 10
> (level, low) -> IRQ 10
> Mar 29 11:08:45 kernel: ath5k 0000:00:0b.0: registered as 'phy0'
> Mar 29 11:08:45 kernel: phy0: Selected rate control algorithm 'minstr=
el'
> Mar 29 11:08:45 kernel: ath5k phy0: Atheros AR5212 chip found (MAC: 0=
x56, PHY:
> 0x41)
> Mar 29 11:08:45 kernel: ath5k phy0: RF5112B multiband radio found (0x=
36)
> Mar 29 11:08:45 kernel: udev: renamed network interface wlan0 to ath0
> Mar 29 11:09:03 kernel: ath5k phy0: noise floor calibration timeout (=
5180MHz)
> Mar 29 11:09:36 last message repeated 3 times
> Mar 29 11:10:43 last message repeated 6 times
> Mar 29 11:11:48 last message repeated 6 times
> Mar 29 11:12:54 last message repeated 6 times
> Mar 29 11:14:00 last message repeated 6 times
> Mar 29 11:15:06 last message repeated 6 times
> Mar 29 11:16:12 last message repeated 6 times
>

I can understand how this patch may have resulted a noise floor
calibration timeout but i can't understand how it broke everything
else. I've tested it with a very similar card (same MAC and PHY chips
but from a different vendor) and it worked just fine. Also i know
there is still something more to fix for RF5112 while setting rf
buffer settings and we have 2 curves but i don't think that's related.

> and with "modprobe -r ath5k"
>
> Mar 29 11:23:59 kernel: ath0: deauthenticating by local choice (reaso=
n=3D3)
> Mar 29 11:24:05 kernel: ath5k phy0: noise floor calibration timeout (=
5180MHz)
> Mar 29 11:24:38 last message repeated 3 times
> Mar 29 11:24:49 kernel: ath5k phy0: noise floor calibration timeout (=
5180MHz)
>
> (I can't understand the deauthenticating line when before I don't see=
 an
> authenticate line). At this point it's impossible to remove the modul=
e and
> the execution of a top session identifies a "phy0" program which runs=
 forever
> with high CPU usage (I need to reboot the system)
>
> =C2=A0PID USER =C2=A0 =C2=A0 =C2=A0PR =C2=A0NI =C2=A0VIRT =C2=A0RES =C2=
=A0SHR S %CPU %MEM =C2=A0 =C2=A0TIME+ =C2=A0COMMAND
> 21548 root =C2=A0 =C2=A0 =C2=A015 =C2=A0-5 =C2=A0 =C2=A0 0 =C2=A0 =C2=
=A00 =C2=A0 =C2=A00 R 68.5 =C2=A00.0 =C2=A0 2:25.68 phy0
>

This is even more weird, do you have an SMP system ? That warning you
get is from the periodic calibration function, it seems you run this
function too often...



--=20
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
