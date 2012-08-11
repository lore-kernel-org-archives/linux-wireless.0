Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47836 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab2HKLFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2012 07:05:48 -0400
Date: Sat, 11 Aug 2012 19:05:43 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [wireless-testing:master 68/100]
 drivers/net/wireless/p54/eeprom.c:291:15: warning: comparison of distinct
 pointer types lacks a cast
Message-ID: <20120811110543.GA9348@localhost> (sfid-20120811_130630_108874_F8E8F394)
References: <20120811084404.GA7755@localhost>
 <201208111229.35167.chunkeey@googlemail.com>
 <20120811104133.GA9132@localhost>
 <201208111257.26417.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201208111257.26417.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 11, 2012 at 12:57:26PM +0200, Christian Lamparter wrote:
> On Saturday 11 August 2012 12:41:33 Fengguang Wu wrote:
> > On Sat, Aug 11, 2012 at 12:29:34PM +0200, Christian Lamparter wrote:
> > > On Saturday 11 August 2012 11:59:51 Fengguang Wu wrote:
> > > > On Sat, Aug 11, 2012 at 11:49:47AM +0200, Christian Lamparter wrote:
> > > >   CC [M]  drivers/net/wireless/p54/eeprom.o
> > > [...]
> > > >   LD [M]  drivers/net/wireless/p54/p54common.o
> > > > make: Leaving directory `/c/wfg/tip'
> > > > wfg@bee ~/tip/obj-compiletest% ..
> > > > wfg@bee ~/tip% q pop
> > > > Removing patch patches/mutt-wfg-t420-1000-8534-5234451332105763812
> > > > Restoring drivers/net/wireless/p54/eeprom.c
> > > > 
> > > Is this patch 1, or patch 2... or both?
> > 
> > It's the only applied patch (and is from you).
> 
> Ok, either I'm confusing, or I confused myself.
> 
> In the original response I sent you two patches.
> take a look: There's "patch 1: make rawpower __u16"
> 
> and the other one is:
> 
> "patch2: use max_t"
> 
> what I want to know: Which patch fixed the warning as
> it looks like from your response that you have applied
> both on the same time on that try:
> > Removing patch patches/mutt-wfg-t420-1000-8534-5234451332105763812
> 
> I have the suspicion that "patch1" actually
> doesn't do anything in this regard, but you
> never know.

Ah sorry! I blindly imported the email and thus both patches are
applied:

wfg@bee ~/tip% q dif
--- tip.orig/drivers/net/wireless/p54/eeprom.c  2012-08-11 17:56:16.945732793 +0800
+++ tip/drivers/net/wireless/p54/eeprom.c       2012-08-11 19:00:29.077671218 +0800
@@ -283,15 +283,15 @@ static int p54_get_maxpower(struct p54_c
        case PDR_SYNTH_FRONTEND_LONGBOW: {
                struct pda_channel_output_limit_longbow *pda = data;
                int j;
-               u16 rawpower = 0;
+               __u16 rawpower = 0;
                pda = data;
                for (j = 0; j < ARRAY_SIZE(pda->point); j++) {
                        struct pda_channel_output_limit_point_longbow *point =
                                &pda->point[j];
-                       rawpower = max(rawpower, le16_to_cpu(point->val_qpsk));
-                       rawpower = max(rawpower, le16_to_cpu(point->val_bpsk));
-                       rawpower = max(rawpower, le16_to_cpu(point->val_16qam));
-                       rawpower = max(rawpower, le16_to_cpu(point->val_64qam));
+                       rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_qpsk));
+                       rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_bpsk));
+                       rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_16qam));
+                       rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_64qam));
                }
                /* longbow seems to use 1/16 dBm units */
                return rawpower / 16;

> Regards,
> 	Chr
> 
> BTW: I've attached just one patch (patch2 - this time)
> So, you don't need to extract it from the other mail
> and can just apply this one. Thanks!

Tests show that this patch2 alone works. The other patch1 alone won't work.

Thanks,
Fengguang
> ---
> diff --git a/drivers/net/wireless/p54/eeprom.c b/drivers/net/wireless/p54/eeprom.c
> index d4d8610..0a9a3e7 100644
> --- a/drivers/net/wireless/p54/eeprom.c
> +++ b/drivers/net/wireless/p54/eeprom.c
> @@ -288,10 +288,10 @@ static int p54_get_maxpower(struct p54_common *priv, void *data)
>  		for (j = 0; j < ARRAY_SIZE(pda->point); j++) {
>  			struct pda_channel_output_limit_point_longbow *point =
>  				&pda->point[j];
> -			rawpower = max(rawpower, le16_to_cpu(point->val_qpsk));
> -			rawpower = max(rawpower, le16_to_cpu(point->val_bpsk));
> -			rawpower = max(rawpower, le16_to_cpu(point->val_16qam));
> -			rawpower = max(rawpower, le16_to_cpu(point->val_64qam));
> +			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_qpsk));
> +			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_bpsk));
> +			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_16qam));
> +			rawpower = max_t(u16, rawpower, le16_to_cpu(point->val_64qam));
>  		}
>  		/* longbow seems to use 1/16 dBm units */
>  		return rawpower / 16;
