Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:3967 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756Ab1GMMdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 08:33:06 -0400
Subject: Re: [PATCH 11/24] ath6kl: add htc.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <4E1D4D63.8000909@qca.qualcomm.com>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013444.8517.89603.stgit@localhost6.localdomain6>
	 <1310531449.1143.29.camel@Joe-Laptop>  <4E1D4D63.8000909@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Jul 2011 05:33:04 -0700
Message-ID: <1310560384.1662.11.camel@Joe-Laptop> (sfid-20110713_143310_070575_F9DC09DA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-07-13 at 10:46 +0300, Kalle Valo wrote:
> On 07/13/2011 07:30 AM, Joe Perches wrote:
> > On Wed, 2011-07-13 at 04:34 +0300, Kalle Valo wrote: 
> >> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> >> diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
> > [] 
> >> +static void htc_tx_comp_update(struct htc_target *target,
> >> +			       struct htc_endpoint *endpoint,
> >> +			       struct htc_packet *packet)
> >> +{
> > [] 
> >> 	ath6kl_dbg(ATH6KL_DBG_HTC_SEND, "ctxt:0x%lx dist:0x%lx\n",
> >> +		(unsigned long) target->cred_dist_cntxt,
> >> +		(unsigned long *) &target->cred_dist_list);
> > compiler warning?
> I haven't seen any. But all these unsigned long casts will be removed
> anyway.

You need to update debug.h [08/24]

> diff --git a/drivers/net/wireless/ath/ath6kl/debug.h b/drivers/net/wireless/ath/ath6kl/debug.h
[]
> +extern int ath6kl_printk(const char *level, const char *fmt, ...);

You're not seeing compiler warnings for mismatched
arguments because this should to be:

extern __attribute__((format (printf, 2, 3)))
int ath6kl_printk(const char *level, const char *fmt, ...);



