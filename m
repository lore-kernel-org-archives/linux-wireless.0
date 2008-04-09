Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36083 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbYDIEWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 00:22:08 -0400
Subject: Re: [PATCH] Add Realtek 8187B support
From: Pavel Roskin <proski@gnu.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804081931.07638.herton@mandriva.com.br>
References: <200804081931.07638.herton@mandriva.com.br>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 00:22:03 -0400
Message-Id: <1207714923.8539.26.camel@rd> (sfid-20080409_052214_850737_72E660AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

On Tue, 2008-04-08 at 19:31 -0300, Herton Ronaldo Krzesinski wrote:
> Hi, this patch (made against wireless-testing repository) adds support for
> 8187B to the rtl8187 module. It is based on code made by Realtek in their
> open source driver, plus contains code by initial patch made by John W.
> Linville and feedback/fixes to his initial patch by Pavel Roskin (thus I'm
> adding them to Signed-offs).

I appreciate your efforts, but I have to point out some mistakes.

I have never tested your patch.  Therefore, you cannot just put my name
on it.  Also, Signed-off-by has a certain legal meaning, and should be
generally used only by authors of the code and those forwarding it:
http://kerneltrap.org/taxonomy/term/245

Patches should start with the driver name followed by the semicolon.  At
this stage you should probably be posting an RFT (request for testing).
http://linuxwireless.org/en/developers/Documentation/SubmittingPatches

The patch produces a warning on x64_64:

/home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_dev.c: In
function 'rtl8187b_init_hw':
/home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_dev.c:586:
warning: cast to pointer from integer of different size

I see you introduce function rtl818x_ioread8_idx(), which takes pointer
to u8 as the second argument, but you cast u16 values to (u8*) in so
many places, that I wonder if that function should take u16 instead.

checkpatch.pl complains about "line over 80 characters" in many places.
I know that many developers don't like this limitation, but it's trivial
to fix in your case.  Thus, checkpatch.pl is only showing that you
didn't run it :-)

Then there are 2 sparse warnings introduced by your patch:

/home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_rtl8225.c:575:6:
warning: symbol 'rtl8225z2_b_rf_set_tx_power' was not declared. Should
it be static?
/home/proski/src/linux-2.6/drivers/net/wireless/rtl8187_rtl8225.c:827:6:
warning: symbol 'rtl8225z2_b_rf_init' was not declared. Should it be
static?

Finally, I tried your patch on my hardware (Trendnet TEW-424UB, USB ID
0bda:8189).  The driver loads and works:

phy2: Selected rate control algorithm 'pid'
phy2: hwaddr 00:14:d1:45:a9:0b, RTL8187BvE V0 + rtl8225z2
usbcore: registered new interface driver rtl8187

But bringing the interface up is very slow - it takes whole 28 seconds:

# time ifconfig wlan1 up

real    0m28.354s
user    0m0.000s
sys     0m0.140s

And the connection is rather bad.  I'm connecting to an AP in the next
room (one wall and 5 meters distance at most).  It starts rather fine at
1Mbps, but then it goes quickly to 54Mbsp, and I get 41% packet loss.
The rate never goes down.  The rate control algorithm is pid.

-- 
Regards,
Pavel Roskin
