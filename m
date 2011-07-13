Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58669 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1GMNih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 09:38:37 -0400
Date: Wed, 13 Jul 2011 19:08:08 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 11/24] ath6kl: add htc.c
Message-ID: <20110713133807.GA3424@vasanth-laptop> (sfid-20110713_153842_313126_374CD6C0)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6> <20110713013444.8517.89603.stgit@localhost6.localdomain6> <1310531449.1143.29.camel@Joe-Laptop> <4E1D4D63.8000909@qca.qualcomm.com> <1310560384.1662.11.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1310560384.1662.11.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2011 at 05:33:04AM -0700, Joe Perches wrote:
> On Wed, 2011-07-13 at 10:46 +0300, Kalle Valo wrote:
> > On 07/13/2011 07:30 AM, Joe Perches wrote:
> > > On Wed, 2011-07-13 at 04:34 +0300, Kalle Valo wrote: 
> > >> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> > >> diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
> > > [] 
> > >> +static void htc_tx_comp_update(struct htc_target *target,
> > >> +			       struct htc_endpoint *endpoint,
> > >> +			       struct htc_packet *packet)
> > >> +{
> > > [] 
> > >> 	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%lx dist:0x%lx\n",
> > >> +		(unsigned long) target->cred_dist_cntxt,
> > >> +		(unsigned long *) &target->cred_dist_list);
> > > compiler warning?
> > I haven't seen any. But all these unsigned long casts will be removed
> > anyway.
> 
> You need to update debug.h [08/24]
> 
> > diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
> []
> > +extern int ath6kl_printk(const char *level, const char *fmt, ...);
> 
> You're not seeing compiler warnings for mismatched
> arguments because this should to be:
> 
> extern __attribute__((format (printf, 2, 3)))
> int ath6kl_printk(const char *level, const char *fmt, ...);

Right, format attribute exposes quite a few mismatch in format
string, we'll address them in next version. Thanks for pointing this out

Vasanth
