Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33630 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2H0Kvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 06:51:40 -0400
Date: Mon, 27 Aug 2012 16:23:20 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC 1/3] ath9k: Fix BTCOEX timer triggering comparision
Message-ID: <20120827105318.GA2333@vmraj-lnx.qca.qualcomm.com> (sfid-20120827_125212_134606_343EF506)
References: <1345817851-8700-1-git-send-email-mohammed@qca.qualcomm.com>
 <20120825153919.GA23173@kamboji.qca.qualcomm.com>
 <8F3AF1C9F856774F8C8D67AA7EDFEC8801EEB120@aphydexd01b>
 <503B3E1F.1010804@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <503B3E1F.1010804@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 27, 2012 at 03:00:07PM +0530, Mohammed Shafi Shajakhan wrote:
> Hi Raj,
> 
> 
> On Friday 24 August 2012 10:28 PM, Manoharan, Rajkumar wrote:
> >On Fri, Aug 24, 2012 at 07:47:29PM +0530, Mohammed Shafi Shajakhan wrote:
> >>From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> >>
> >>Its safer to convert btcoex_period to 'us' while
> >>comparing with btcoex_no_stomp which is in 'us'.
> >>Did not find any functionality issues being fixed,
> >>as the generic hardware timer triggers are usually
> >>refreshed with the newer duty cycle.
> >>
> >In which way it is safer? What does the patch fix? It was intentionally
> >converted to msec by "ath9k: keep btcoex period in milliseconds".
> 
> we got btcoex_period is in 'us' while 'btcoex_no_stomp' in 'ms'
> when we are going to compare , both of them had to been in same time
> units. Rather then mentioning it as 'safer' the commit log should say
> its 'more correct' :-)  previously the comparison happened with same
> timeunits(ms).
> 
> I could not find any functionality issue being fixed,
> but i saw the difference, when putting debug prints for
> btcoex->btcoex_period, btcoex->btcoex_no_stomp), there was so
> much difference. Yet the check itself
> 
>         if (btcoex->btcoex_period != btcoex->btcoex_no_stomp)
> 
> seems to be true for almost all the cases. So fine with changing the
> commit log ?
> 
> thanks a lot for the review!
>
Oops. Its a regression. Can you please include the commit "ath9k: keep btcoex
period in milliseconds" that causes this regression in your commit log.

-Rajkumar
