Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62433 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab0EWBeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 May 2010 21:34:36 -0400
Received: by fxm5 with SMTP id 5so1701074fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 22 May 2010 18:34:34 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: dhlii@dlasys.net
Subject: Re: carl9170 1.0.9
Date: Sun, 23 May 2010 03:34:29 +0200
Cc: linux-wireless@vger.kernel.org, jal2@gmx.de
References: <4BDC001F.9050202@dlasys.net> <201005021452.01101.chunkeey@googlemail.com> <4BF82CEE.8020502@dlasys.net>
In-Reply-To: <4BF82CEE.8020502@dlasys.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201005230334.29866.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 22 May 2010 21:13:50 David H. Lynch Jr. wrote:
> 
> some items I have found while making my changes to the code.
patches are welcome :-D

> 	In firmware_source/carlfw/src/wlan.c you have aloop to read the TSF 
> timer to make sure there is no roll over. According to the docs I have 
> when TSF_LOW is read, TSF_HI is automatically concurrently copied to a 
> temp register so that an immediate read of TSF_HI will get the value 
> that was present when TSF_LO was read.
Thanks for that clarification. The code in question was actually a
adaptation from ar9170_op_get_tsf (patch author included in CC).

Since this is now settled, I made the necessary chances to the
kernel driver as well. (with a reference to your previous mail)

> 	I beleive the timer_init() routine in carlfw/src/timer.c can not be 
> called for more than one timer. Any subsequent call will clear the 
> interrupt and mode bits for the previous timer.

there's more than that.
Take a look at the (timer << 2) and so forth...

> 	I have not completely tracked these down, but the new config system 
> must be missing some dependencies, because I can configure and build 
> firmware that will not load.
> 	In carlfw/src/cmd.c the CARL9170_CMD_PSM case needs ifdef'd with 
> CONFIG_CARL9170FW_PSM or it will not build with PSM disabled.
> 
fixed.

Thanks for your comments. I've just released 1.0.9.1, which
contains fixes for all of your comments and some additional changes.


BTW:
> I have been playing with the assorted timers in the ar9170.
> My preliminary observations seem to be indicating that
> AR9170_TIMER_REG_TIMER0 might actually be running at 40mhz/25ns,
> But that all the other timers seem to be running far slower - i.e. 
> maybe they are cascaded of the overflow on timer0.
>
> I have specifically looked at timer1-4 and tic_timer and clock_low 
> and they all seem to be running very slow.
> The docs that I have imply but do not state that all these clocks 
> are directly off the 25ns/40mhz superH clock.
> Have you had any experience with the clocks and their rates ?

based on observation: Some timers(1-4) are *driven* by the cpu clock.
Which is of course determined by the operation mode and phy band.
As you know there are 7 (1 + 2 * 3) possible AHB/CPU clock settings:
 * 40MHz (refclock)
 * 20MHz (PSM, 5GHz) & 22MHz (PSM, 2.4GHz)
 * 40MHz (11an, 5GHz, HT20) & 44Mhz (11bgn, 2.4GHz, HT20)
 * 80MHz (11an, 5GHz, HT40) & 88MHz (11bgn, 2.4GHz, HT40)

Regards,
	Chr
