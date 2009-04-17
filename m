Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:35421 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752411AbZDQBWq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 21:22:46 -0400
Message-ID: <530731.29613.qm@web23105.mail.ird.yahoo.com> (sfid-20090417_032251_590929_F38A6CE4)
Date: Fri, 17 Apr 2009 01:22:44 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFT/RFC V4] rtl8187: Implement TX/RX blink for LED
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- On Fri, 17/4/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> No, I think that it is ready to be submitted. I also
> checked that it compiles OK
> when the conditions are such that CONFIG_RTL8187_LED is not
> defined.

Yes, I mispelled that - CONFIG_RTL8187_LEDS with an S at the end, and I missed the S like you :-) - in config.mk and it still built with V3 but the dmesg lines were gone. I looked at symbols with nm, objdump to search for the led routines in the assembler, before I realized the mispelling :-). 

> Do we have any information on how that radio LED is
> activated on your device?
> Presumably, that customer code of 0xo4 has some
> significance. Do you have a
> radio on/off switch, or how is it activated. I know that
> Johannes is working on
> the rfkill setup on Toshiba notebooks. Perhaps that will
> show something. When he
> has that ready, I'll send you a patch to see if we get any
> events through a
> radio LED when the radio is activated/deactivated.

It isn't in the realtek doc, and whether it is in the vendor driver I haven't looked close enough. e.g. Realtek people couldn't/won't say how the 0x8198/0x8199 pid differ from 0x8197 - I think they hinted that 0x8199 is sold entirely in such laptop components, and they actually don't know how Toshiba hook it up.

Next to the LED on my laptop is a slide toggle switch. The LED comes on when you slide it to the right, and off when it is to the left. The MS Windows Realtek driver is sensitive to the switch's position, and is deactivated when the switch turns the LED off, but the linux driver works regardless of the position of the switch - if the LED is tied to the radio hardware, it is a bit curious how the radio still works under linux when the LED is off. All I can say is that the windows driver is aware of the state of the switch or the on/of state of the LED, and the linux driver ignores it. 

It would be nice to honour the state of the switch and have a "hardware override" instead of doing ifconfig down/modprobe -r :-).


      
