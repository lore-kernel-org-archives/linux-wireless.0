Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n75.bullet.mail.sp1.yahoo.com ([98.136.44.51]:23933 "HELO
	n75.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752419AbZHYG56 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Aug 2009 02:57:58 -0400
Message-ID: <950315.98615.qm@web23105.mail.ird.yahoo.com>
Date: Tue, 25 Aug 2009 06:51:48 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A935C2D.5010308@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 25/8/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Hin-Tak Leung wrote:
> > --- On Tue, 25/8/09, Larry Finger <Larry.Finger@lwfinger.net>
> wrote:
> > 
> >>> [PATCH] rtl8187: fix circular locking
> >> (rtl8187_stop/rtl8187_work)
> >>
> >> This patch fixes the problem. You can add a
> Tested-by to
> >> it.
> > 
> > Hmm, I am still wondering about why NM insists on if
> up'ing the device. I read bits of things and apparently hal
> is supposed to know the device is rfkill'ed and let NM know.
> But lshal is not listing the device as having an killswitch.
> I don't know how hal is supposed to work out that info
> though. 
> > 
> > also I noted that
> /sys/class/rfkill_backport/rfkill0/state goes from 1 to 2
> when I slide the switch to the 'off' position. Some says it
> should be 0?
> > Don't know if hal is affected by its being
> rfkill_backport (compat-wireless) rather than rfkill (stock
> vendor kernel). well, it should look there if it isn't :-).
> > 
> > It looks like it is a hal problem...
> 
> The interpretation is as follows:
> 0 - blocked by software such as 'rfkill block 1'
> 1 - unblocked
> 2 - blocked by hardware
> 
> Your state is doing exactly what I would expect. When NM
> brings the
> device up, does the above state change? Does dmesg show
> anything?

dmesg and rfkill/state corresponds exactly to what the sliding switch does (in the on position, dmesg says it is on, states says 2, in the off position, dmesg says it is off, state says 1). NM basically ignores rfkill/state, and just if'up the device whenever it notices the device has gone down.

hal is supposed to have knowledge of the rfkill state (which it hasn't, from what I see of the lshal output - there is no killswitch entry in there), and let NM through dbus know to not bother the device. At the moment I think it is somewhere in hal that's not working properly.


      

