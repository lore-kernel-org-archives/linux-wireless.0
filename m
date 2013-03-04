Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42283 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758409Ab3CDPud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:50:33 -0500
Message-ID: <1362412228.21028.36.camel@jlt4.sipsolutions.net> (sfid-20130304_165037_024524_D60BAF56)
Subject: Re: [PATCH 2/2] mac80211: fix the check for mcs rates masking
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Mon, 04 Mar 2013 16:50:28 +0100
In-Reply-To: <20130227133802.GA28291@magnum.frso.rivierawaves.com> (sfid-20130227_144045_935070_0B5F12BC)
References: <1361966434-28343-1-git-send-email-karl.beldan@gmail.com>
	 <1361966434-28343-2-git-send-email-karl.beldan@gmail.com>
	 <20130227133802.GA28291@magnum.frso.rivierawaves.com>
	 (sfid-20130227_144045_935070_0B5F12BC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 14:38 +0100, Karl Beldan wrote:

> >  	mask = txrc->rate_idx_mask;
> > -	memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
> > -	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
> > +	if (mask != (1 << txrc->sband->n_bitrates) - 1 ||
> > +		memcmp(txrc->sband->ht_cap.mcs.rx_mask, txrc->rate_idx_mcs_mask,
> > +		       sizeof(txrc->rate_idx_mcs_mask))) {
> > +		memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
> > +
> >  		if (sta) {
> > 
> 
> I don't know why I refrained myself from getting rid of the copies of
> the masks altogether.

Are you going to resend?

johannes

