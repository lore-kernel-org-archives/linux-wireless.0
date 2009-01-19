Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:45777 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbZASA0w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 19:26:52 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Artur Skawina <art.08.09@gmail.com>
Subject: Re: wireless-testing, p54 and sinus 154 data no longer works
Date: Mon, 19 Jan 2009 01:26:58 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <494698AF.4020204@gmail.com> <497105D1.5040906@gmail.com> <4973BAC6.5020502@gmail.com>
In-Reply-To: <4973BAC6.5020502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901190126.58392.chunkeey@web.de> (sfid-20090119_012658_530151_B2A237BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 January 2009 00:27:02 Artur Skawina wrote:
> Artur Skawina wrote:
> > 
> > didn't trigger anything here, just the usual:
> > 
> > BUG kmalloc-4096: Poison overwritten
> 
 
> Still haven't found the corruptor, but at least i've narrowed it down a bit;
> what i'm seeing is:
> 
> 1) an skb "S" gets allocated in p54u_rx_cb and is submitted together w/ the urb.
> 2) "S" later comes back to p54u_rx_cb, where it is given to p54_rx (eventually
>    ieee80211_rx_irqsafe) and a new one is allocated.
> 3) a few (~15) rx/tx packets pass.
> 4) SLUB detects modified poison in what used to be S->head in (1) and (2) above;
>    usually 0x6b turns into 0x6a, but i have also seen 0x69, just a few times.
>    (the offset from skb->head to the decremented byte seems to stay the same,
>    at least during the few times i tried w/ the same kernel, last one was eg
>    684 bytes)
> 
> This is almost 100% reproducible; sometimes the machine freezes instead.

Do you know what is inside "S" when it handed over to ieee80211_rx_irqsafe?
Is it always the same content, or is it sometimes a data or mgmt frame?

Another shot in the dark: do you have a daemon that listen to mon.wlan0, wmaster / "any" other than hostapd?

Regards,
	Chr
