Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.ird.yahoo.com ([77.238.189.218]:31243 "HELO
	nm11-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755729Ab1CAIWD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 03:22:03 -0500
Message-ID: <888027.91829.qm@web29506.mail.ird.yahoo.com>
Date: Tue, 1 Mar 2011 08:22:01 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH V2] rtl8187: Change rate-control feedback
To: John W Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4d6c85c9.Gv0aZxorarbTk25I%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Tue, 1/3/11, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The driver for the RTL8187L chips
> returns IEEE80211_TX_STAT_ACK for all
> packets, even if the maximum number of retries was
> exhausted. In addition
> it fails to setup max_rates in the ieee80211_hw struct,
> This behavior
> may be responsible for the problems noted in Bug 14168. As
> the bug is very
> old, testers have not been found, and I do not have the
> case where the
> indicated signal is less than -70 dBm.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@kernel.org>
> ---
> 
> V1 => V2: Protect against zero divide, and the case
> where the 16-bit retry
>       counter wraps to zero. The latter
> is unlikely, but tested for
>       completeness.

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

This may be style-thing - the meaning of some of the variables changes mid-routine. I think one alternative way (not necessarily better) is to unlock the mutex and return if length ==0, and something similiar to the register wrap-around?

I'm okay with this as is though.



      
