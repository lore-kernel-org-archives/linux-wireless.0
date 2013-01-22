Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:33049 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab3AVWTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 17:19:35 -0500
Date: Tue, 22 Jan 2013 23:19:35 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: print chip and firmware version by default
Message-ID: <20130122221935.GA2193@localhost.localdomain> (sfid-20130122_231938_902922_303F2040)
References: <20130122164914.GB25134@localhost.localdomain>
 <2BB3EFC8-0B36-47DA-9FE2-13159E367F85@gmail.com>
 <50FF00C0.1010402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FF00C0.1010402@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 22, 2013 at 10:12:32PM +0100, Xose Vazquez Perez wrote:
> On 01/22/2013 07:58 PM, Gertjan van Wingerde wrote:
> 
> > On 22 jan. 2013, at 17:49, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> > 
> >> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> >> Tested-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> >> ---
> >> drivers/net/wireless/rt2x00/rt2x00.h    |    2 +-
> >> drivers/net/wireless/rt2x00/rt2x00mac.c |    6 +++---
> >> 2 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> >> index 3e37c19..bef449c 100644
> >> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> >> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> >> @@ -92,7 +92,7 @@
> >> #define NOTICE(__dev, __msg, __args...) \
> >>    DEBUG_PRINTK(__dev, KERN_NOTICE, "Notice", __msg, ##__args)
> >> #define INFO(__dev, __msg, __args...) \
> >> -    DEBUG_PRINTK(__dev, KERN_INFO, "Info", __msg, ##__args)
> >> +    DEBUG_PRINTK_MSG(__dev, KERN_INFO, "Info", __msg, ##__args)
> >> #define DEBUG(__dev, __msg, __args...) \
> >>    DEBUG_PRINTK(__dev, KERN_DEBUG, "Debug", __msg, ##__args)
> >> #define EEPROM(__dev, __msg, __args...) \
> > 
> 
> > I think this change is good, but we should also change WARNING and
> > NOTICE. Otherwise they won't be displayed if CONFIG_RT2X00_DEBUG is
> > disabled, but INFO will, which would be strange.

We have those "TX status report missed" messages which spam logs,
I think we should move them to DEBUG level then.

NOTICE is only used in suspend/resume, it should be DEBUG too and NOTICE
macro could be removed.

> I believe this patch is so useful and trivial enough to be included,
> as is, in the next 3.8-rc .
> 
> The next steps can be done for 3.9

If Gertjan will be so kind and ACK this patch, I'll post further
changes as incremental patch :-)

Stanislaw
