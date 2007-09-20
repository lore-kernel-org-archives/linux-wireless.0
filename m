Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.228]:22042 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXITCjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 22:39:35 -0400
Received: by nz-out-0506.google.com with SMTP id s18so324555nze
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2007 19:39:34 -0700 (PDT)
Message-ID: <40f31dec0709191939l6f99b59gd31d5291057692a2@mail.gmail.com>
Date: Thu, 20 Sep 2007 05:39:33 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: AR5006 - should it work?
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <m3ir66s1zn.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <m3odg0dji3.fsf@maximus.localdomain>
	 <40f31dec0709190755h5ea62e0cv578f2a5ed0788d80@mail.gmail.com>
	 <m3ir66s1zn.fsf@maximus.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/9/20, Krzysztof Halasa <khc@pm.waw.pl>:
> "Nick Kossifidis" <mickflemm@gmail.com> writes:
>
> > Are you sure 5413 didn't work ? (it has poor signal quality etc,
> > perhaps you can try getting closer to the AP -just for testing-).
>
> I don't currently have any AP, just few cards and two IXP425
> boxes (and PCI-miniPCI converter).
> People around here use APs and they easily show up on 5004X.
> BTW the IXP425 (ARM) CPU is usually in big-endian mode.
>
> > 02:09.0 Ethernet controller: Atheros Communications, Inc. AR5006X
> > 802.11abg NIC (rev 01)
> >         Subsystem: Atheros Communications, Inc. EnGenius EMP-8602
> > (400mw) or Compex WLM54AG
>
> Same cards here.
>
> > (http://madwifi.org/browser/trunk/tools/ath_info.c) it'll give us more
> > infos about your hardware ;-)
>
> Well...
> # modprobe ath5k
> PCI: enabling device 0000:00:0d.0 (0140 -> 0142)
>
> # setpci -s d command
> 0146
> # setpci -s d cache_line_size
> 08
>
> # ath_info -v 0x48000000
> #DBG main: sleep_ctl reg 00000000   reset_ctl reg 00000000
> (pressed ^C)
>
> # ath_info -v 0x48000000
> Unable to handle kernel paging request at virtual address e1a00fc0 :-)
>
> (rebooting little-endian system)
>

hmm my fault i forgot to swap values for big endian machines...

> #DBG main: sleep_ctl reg 00000000   reset_ctl reg 00000000
>  -==Device Information==-
> MAC Version:  2424 (0xa0)
> MAC Revision: 5413 (0xa4)
> 5Ghz PHY Revision: SChip(0x63)
> 2Ghz PHY Revision: SChip(0x63)

It's a 5413 i must fix that function that matches ids with names soon :P

>  -==EEPROM Information==-
> EEPROM Version:     5.2
> EEPROM Size:        16K
> Regulatory Domain:  0x37

FYI later 5424/2424 have a 4K EEPROM (v 5.3) that is not supported
yet, also your regulatory domain is ETSI1_WORLD

>  -==== Capabilities ====-
> |  802.11a Support: yes  |
> |  802.11b Support: yes  |
> |  802.11g Support: yes  |
> |  RFKill  Support: no   |
> |  32KHz   Crystal: no   |
>  ========================
> GPIO registers: CR 00000000 DO 00000000 DI 00000012
>

32KHz crystal is used for power saving

> > AR5004X series worked ok in all of my tests, i guess that if you try
> > with the binary HAL (madwifi driver) you'll get the same results.
>
> It works for me as well, 5006X doesn't.
>
> Is it possible that a signal which shows as 20/127 on 5004X
> is too weak for 5006X to be detected by scanning?
>

Nope it's fine, it might be that 5006X's RF part is not initialized
propertly so it doesn't "hear" 5004X.

> BTW: on the 5004X I'm connecting the antenna to AUX connector
> (CM9 card - AUX in the middle), it doesn't work in MAIN (the corner).
> Should I connect the antenna to AUX (the corner) or to MAIN (middle)
> on 5006X?

Typicaly you should connect the antenna on main (actually on my CM9
-lol we also have the same 5004X card- i connected both antennas so i
haven't checked that).

> Is the antenna selectable?
>

yup but it's not implemented yet in ath5k (hw functions for this are
ok we just don't use them yet as far as i know -i'll check it out to
be sure).


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
