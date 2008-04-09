Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:48476 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916AbYDIRg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 13:36:28 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] Add Realtek 8187B support
Date: Wed, 9 Apr 2008 14:36:23 -0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200804081931.07638.herton@mandriva.com.br> <1207714923.8539.26.camel@rd>
In-Reply-To: <1207714923.8539.26.camel@rd>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804091436.23685.herton@mandriva.com.br> (sfid-20080409_183633_048460_DF808752)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Wednesday 09 April 2008 01:22:03 Pavel Roskin escreveu:
> Hello!
> 
> On Tue, 2008-04-08 at 19:31 -0300, Herton Ronaldo Krzesinski wrote:
> > Hi, this patch (made against wireless-testing repository) adds support for
> > 8187B to the rtl8187 module. It is based on code made by Realtek in their
> > open source driver, plus contains code by initial patch made by John W.
> > Linville and feedback/fixes to his initial patch by Pavel Roskin (thus I'm
> > adding them to Signed-offs).
> 
> I appreciate your efforts, but I have to point out some mistakes.
> 
> I have never tested your patch.  Therefore, you cannot just put my name
> on it.  Also, Signed-off-by has a certain legal meaning, and should be
> generally used only by authors of the code and those forwarding it:
> http://kerneltrap.org/taxonomy/term/245

Hi, I thought Signed-off was more of a credit assigment, and as you had placed
some code in response to John's patch I included you (I used the same fixes),
no problem, I'll read the above link and request that people place their
Signed-offs if they want in next patch (and use my signed-off only).

> 
> Patches should start with the driver name followed by the semicolon.  At
> this stage you should probably be posting an RFT (request for testing).
> http://linuxwireless.org/en/developers/Documentation/SubmittingPatches

Will fix in next submit.

> 
> The patch produces a warning on x64_64:
> 
> /home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_dev.c: In
> function 'rtl8187b_init_hw':
> /home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_dev.c:586:
> warning: cast to pointer from integer of different size
> 
> I see you introduce function rtl818x_ioread8_idx(), which takes pointer
> to u8 as the second argument, but you cast u16 values to (u8*) in so
> many places, that I wonder if that function should take u16 instead.

In fact I didn't introduce the function, I just extended it with one more
argument as was needed by rtl8187b setup (that needs an index to be passed
to usb_control_msg != 0). The function was already before using u8*. I agree
that the casts aren't needed, for now I just followed the style that was on the
driver (iowrite functions could well use just u16 instead of u8*, __le16*,
__le32*).

Before my patch there are the same type casts:
$ grep '(u8 \*)' rtl*
rtl8187_dev.c:  rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x10);
rtl8187_dev.c:  rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x11);
rtl8187_dev.c:  rtl818x_iowrite8(priv, (u8 *)0xFE18, 0x00);
rtl8187_dev.c:  reg = rtl818x_ioread8(priv, (u8 *)0xFE53);
rtl8187_dev.c:  rtl818x_iowrite8(priv, (u8 *)0xFE53, reg | (1 << 7));
rtl8187_dev.c:  rtl818x_iowrite8(priv, (u8 *)0xFFFF, 0x60);
rtl8187_dev.c:                           ((u8 *)conf->mac_addr)[i]);
rtl8187_dev.c:  priv->asic_rev = rtl818x_ioread8(priv, (u8 *)0xFFFE) & 0x3;
rtl8187_rtl8225.c:      rtl818x_iowrite8(priv, (u8 *)0xFF5B, 0x0D); msleep(1);

The warning on x86_64 seems related to sign extension, I found this reference:
http://gcc.gnu.org/ml/gcc-patches/2005-12/msg00942.html
I'll fix it making a double cast for now:
(u8 *)(uintptr_t)(rtl8187b_reg_table[i][0] | 0xFF00)
instead of
(u8 *)(rtl8187b_reg_table[i][0] | 0xFF00)

This would gone of course if we were just using u16, I can make a patch
following this, test and submit it.

> 
> checkpatch.pl complains about "line over 80 characters" in many places.
> I know that many developers don't like this limitation, but it's trivial
> to fix in your case.  Thus, checkpatch.pl is only showing that you
> didn't run it :-)

I run checkpatch.pl, I just didn't fixed these because they were lines already
this way, my patch got these because I moved reset code common to rtl8187b
and rtl8187 (new rtl8187_cmd_reset function) out of rtl8187_init_hw. Also I
introduced some new ones, these lines are over 80 characters:
rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);

Should I fix all of these ocurrences in rtl8187b patch or in a new patch?

> 
> Then there are 2 sparse warnings introduced by your patch:
> 
> /home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_rtl8225.c:575:6:
> warning: symbol 'rtl8225z2_b_rf_set_tx_power' was not declared. Should
> it be static?
> /home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_rtl8225.c:827:6:
> warning: symbol 'rtl8225z2_b_rf_init' was not declared. Should it be
> static?

Will fix making functions static.

> 
> Finally, I tried your patch on my hardware (Trendnet TEW-424UB, USB ID
> 0bda:8189).  The driver loads and works:
> 
> phy2: Selected rate control algorithm 'pid'
> phy2: hwaddr 00:14:d1:45:a9:0b, RTL8187BvE V0 + rtl8225z2
> usbcore: registered new interface driver rtl8187
> 
> But bringing the interface up is very slow - it takes whole 28 seconds:
> 
> # time ifconfig wlan1 up
> 
> real    0m28.354s
> user    0m0.000s
> sys     0m0.140s

Wow, 28 seconds is too much... indeed it's slow, but should be not as much as 28
seconds, here I get 11/12 seconds. The delay is huge as there are many sleeps
in Realtek initialization.

> 
> And the connection is rather bad.  I'm connecting to an AP in the next
> room (one wall and 5 meters distance at most).  It starts rather fine at
> 1Mbps, but then it goes quickly to 54Mbsp, and I get 41% packet loss.
> The rate never goes down.  The rate control algorithm is pid.
> 

I forgot to say about this when I submitted the patch, indeed rate control
doesn't work for 8187b, for 8187 it never worked too. If you set rate manually
to something lower (I found that for 2-3 meters from AP 11M seems to be the
best setting) it works much better (there aren't stalls/packet drops). I'll try to
take a look on this problem and see if I can enhance startup time and add rate
control, unfortunately in these two areas there isn't much that I can do as I
did this work only basing on opensource realtek driver and I don't have any
documentation for the hardware. The same realtek driver from where I based the
work also has the two problems (no rate control, long startup time).

--
[]'s
Herton
