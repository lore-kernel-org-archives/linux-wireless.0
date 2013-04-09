Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lerya.net ([213.251.186.118]:49576 "EHLO mx.lerya.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936191Ab3DIQEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 12:04:34 -0400
Date: Tue, 9 Apr 2013 18:04:32 +0200
From: Vincent Brillault <gentoo@lerya.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
Message-ID: <20130409160431.GA13599@Fea.lerya.net> (sfid-20130409_180442_384043_4A1896C2)
References: <513B7E58.9000505@lwfinger.net>
 <20130311183825.GG3009@Fea.lerya.net>
 <20130313080048.GB3484@Fea.lerya.net>
 <20130317141201.GA2557@Fea.lerya.net>
 <20130325182910.GA10274@Fea.lerya.net>
 <5150A15F.20600@lwfinger.net>
 <20130325195104.GA11212@Fea.lerya.net>
 <5150AE0F.2040306@lwfinger.net>
 <20130409094542.GA26503@Fea.lerya.net>
 <51643491.80302@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51643491.80302@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue  9.Apr'13 at 10:32:33 -0500, Larry Finger wrote:
> On 04/09/2013 04:47 AM, Vincent Brillault wrote:
> > I still have the deconnection/reconnection issue. After looking on the
> > reason, I think I have found a bug. Please look at the patched included
> > in this mail: I think the rtlpriv->link_info.num_rx_inperiod is set to 0
> > too early, as the '/* <4> roaming */' part uses it to see if the AP is
> > still alive. What do you think ?
> 
> Does that change help your issue?
I cannot say for sure that it helped. I have now disactivated the
powersave features of the driver and all my problems disappeared.
The only thing I can say for sure is that my deconnections were detected
by this part of the code, as the error message was
"rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now",
and that this bugs seems to increase the probability to take the 'wrong'
branch.

Anyway, I think this line is missplaced: why would lines 1433-1434 use
rtlpriv->link_info.num_rx_inperiod if its value is always 0 ?

Vincent
