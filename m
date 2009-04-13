Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:57673 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZDMWQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 18:16:46 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFT/RFC V2] rtl8187: Implement TX/RX blink for LED
Date: Mon, 13 Apr 2009 19:16:42 -0300
Cc: "Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <49e3624d.kMco99OS/EWv0szt%Larry.Finger@lwfinger.net>
In-Reply-To: <49e3624d.kMco99OS/EWv0szt%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Message-Id: <200904131916.42818.herton@mandriva.com.br> (sfid-20090414_001650_229934_D825A22C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Segunda-feira 13 Abril 2009, =E0s 13:03:25, Larry Finger escreveu:
> The following patch implements some control over the LED on RTL8187B =
and
> RTL8187L devices. Triggers are registered for TX and RX. Whenever the
> trigger event occurs, the LED is turned off for 1/20 second, then tur=
ned
> back on.
>
> Note: For those RTL8187X devices that are built into the computer and=
 have
> a LED that is expected to be controlled with a radio switch, this pat=
ch
> will not operate that LED. That will take a separate patch to be prep=
ared
> later.
>
> Please test and comment.
>
> The behavior described above is found for my Level One RTL8187B. Prio=
r to
> this patch, the LED was on continuously. On a Netgear WG111V2 RTL8187=
L, the
> LED blinks erratically. Before the patch, the LED was off.
>
> If you test, please report the status of the LED before and after app=
lying
> the patch. In addition, find the line that looks like "rtl8187: Custo=
mer ID
> 0x00" in the dmesg output and report it. I also need to know if you h=
ave a
> B or L model.

I tested here on a Quanta IL1 mini-notebook with rtl8187b:
- Reports Customer ID 0x00
- Before the patch, on a cold boot, when driver loads, the wireless led=
 lights=20
up and stays forever on (expected, one of the register writes from=20
rtl8187b_reg_table turns it on: {0x91, 0x03, 0}, this should be removed=
 from=20
the code and turn led up now in rtl8187_leds_init may be?).
- After the patch it continues to turn on as expected (nothing changed)=
, and=20
blinks on activity, is working fine. But it doesn't turn off led on unr=
egister,=20
missing led_turn_off at rtl8187_unregister_led. Otherwise looks fine.

BTW, thanks for doing this, led support is a nice feature :)

>
> A number of problems with version 1 of this patch have been fixed. Th=
e most
> important of these was a locking problem that caused the RTL8187L to =
fail.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>
<snip>

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
