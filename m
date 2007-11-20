Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from there.is.no.cabal.ca ([134.117.69.58]:52774 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbXKTXqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 18:46:51 -0500
Date: Tue, 20 Nov 2007 18:46:50 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath5k: avoid oops when ah_capabilities.cap_mode not set
Message-ID: <20071120234650.GB8093@fattire.cabal.ca> (sfid-20071120_234656_079900_953EC1B8)
References: <1192647780430-git-send-email-linville@tuxdriver.com> <43e72e890710171436s2e18a19ene70d3b058c835a96@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890710171436s2e18a19ene70d3b058c835a96@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 17, 2007 at 05:36:33PM -0400, Luis R. Rodriguez wrote:
> On 10/17/07, John W. Linville <linville@tuxdriver.com> wrote:
> > ah_capabilities.cap_mode doesn't get set for some cards, causing the
> > kernel to oops when these unknown/unsupported cards are inserted.
> > Add some NULL checks to avoid this.
> >
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> Acked-by: Luis R. Rodriguez <mcgrof@gmail.com>
> 

Actually, this hunk in ath5k_getchannels can't return -EINVAL
immediately, since there are ath5k cards that do only MODE_IEEE80211A,
which is searched last.

comments?

cheers,
	Kyle

--- a/drivers/net/wireless/ath5k/base.c	2007-11-20 18:35:37.000000000 -0500
+++ b/drivers/net/wireless/ath5k/base.c	2007-11-20 18:35:46.000000000 -0500
@@ -1041,6 +1041,8 @@
 		}
 
 		hw_rates = ath5k_hw_get_rate_table(ah, mode->mode);
+		if (!hw_rates)
+			continue;
 		mode->num_rates    = ath5k_copy_rates(mode->rates, hw_rates,
 			max_r);
 		mode->num_channels = ath5k_copy_channels(ah, mode->channels,
--- a/drivers/net/wireless/ath5k/hw.c	2007-11-20 18:35:34.000000000 -0500
+++ b/drivers/net/wireless/ath5k/hw.c	2007-11-20 18:36:08.000000000 -0500
@@ -536,6 +536,8 @@
 	/* Get rate table for the current operating mode */
 	rt = ath5k_hw_get_rate_table(ah,
 		driver_mode);
+	if (!rt)
+		return -EINVAL;
 
 	/* Write rate duration table */
 	for (i = 0; i < rt->rate_count; i++) {
