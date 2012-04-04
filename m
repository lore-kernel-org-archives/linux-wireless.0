Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:42339 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932392Ab2DDSvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 14:51:25 -0400
Message-ID: <1333565483.16978.26.camel@joe2Laptop> (sfid-20120404_205129_141353_CC1F7D59)
Subject: Re: [PATCH v2] ath9k:  Gather and report IRQ sync_cause errors.
From: Joe Perches <joe@perches.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org
Date: Wed, 04 Apr 2012 11:51:23 -0700
In-Reply-To: <4F7C922F.7060201@candelatech.com>
References: <1333513250-30478-1-git-send-email-greearb@candelatech.com>
	 <1333556182.16978.9.camel@joe2Laptop> <4F7C922F.7060201@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(added Luis R and the current ath9k-devel list to cc's)

On Wed, 2012-04-04 at 11:25 -0700, Ben Greear wrote:
> On 04/04/2012 09:16 AM, Joe Perches wrote:
> > On Tue, 2012-04-03 at 21:20 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> Report all defined sync_cause errors in debugfs
> >> to aid with debugging.
> >
> > just trivia:
> >
> >> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
> > []
> >> @@ -385,63 +385,130 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
> >>   				   size_t count, loff_t *ppos)
> >>   {
> >>   	struct ath_softc *sc = file->private_data;
> > []
> >>   	if (sc->sc_ah->caps.hw_caps&  ATH9K_HW_CAP_EDMA) {
> > []
> >> +		len += snprintf(buf + len, mxlen - len,
> >> +			"%21s: %10u\n", "RXLP", sc->debug.stats.istats.rxlp);
> >
> > Alignment is overrated.
> >
> > I wouldn't change any of the original block
> > though perhaps changing the sc pointer to an
> > istats pointer so these dereferences become
> > similar to istats->rxlp;
> 
> Other files in this driver are aligned, so it seems
> nice to continue the tradition.  debugfs files are
> for human consumption, so making them readable is
> a virtue.

It'd still be readable, it would just be a different block
separated by a new header line.

> If someone wants more efficient access to this data,
> then we can use ethtool stats (I'll add ethtool stats
> support for these counters if/when my first ethtool
> patches make it in...)

That'd be a good idea.

> >> +void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause)
> >> +{
> >> +	struct ath_softc *sc = common->priv;
> >> +	if (sync_cause)
> >> +		sc->debug.stats.istats.sync_cause_all++;
> >> +	if (sync_cause&  AR_INTR_SYNC_RTC_IRQ)
> >> +		sc->debug.stats.istats.sync_rtc_irq++;
> >
> > And nicer here to use a pointer to istats too.
> 
> Hopefully the compiler is smart enough that this
> doesn't really matter.

It is, but it's really for reader clarity not
compiler output.

> If the maintainers care, I'll respin the patch, but
> otherwise I'm not sure it's worth the effort.

The patch doesn't apply cleanly against next anyway.
There's a trivial #include mismatch.

cheers, Joe

