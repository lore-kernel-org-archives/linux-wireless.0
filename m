Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n6.bullet.re3.yahoo.com ([68.142.237.91]:42663 "HELO
	n6.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753700AbZHYC51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 22:57:27 -0400
Message-ID: <622090.22128.qm@web23106.mail.ird.yahoo.com>
Date: Tue, 25 Aug 2009 02:51:27 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT] rtl8187: Implement rfkill support
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A933E87.7030600@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 25/8/09, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> > [PATCH] rtl8187: fix circular locking
> (rtl8187_stop/rtl8187_work)
> 
> This patch fixes the problem. You can add a Tested-by to
> it.

Hmm, I am still wondering about why NM insists on if up'ing the device. I read bits of things and apparently hal is supposed to know the device is rfkill'ed and let NM know. But lshal is not listing the device as having an killswitch. I don't know how hal is supposed to work out that info though. 

also I noted that /sys/class/rfkill_backport/rfkill0/state goes from 1 to 2 when I slide the switch to the 'off' position. Some says it should be 0?
Don't know if hal is affected by its being rfkill_backport (compat-wireless) rather than rfkill (stock vendor kernel). well, it should look there if it isn't :-).

It looks like it is a hal problem...


      

