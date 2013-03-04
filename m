Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:33901 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498Ab3CDSbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 13:31:17 -0500
Received: by mail-we0-f179.google.com with SMTP id p43so4837402wea.24
        for <linux-wireless@vger.kernel.org>; Mon, 04 Mar 2013 10:31:16 -0800 (PST)
Date: Mon, 4 Mar 2013 19:28:41 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH 2/2] mac80211: fix the check for mcs rates masking
Message-ID: <20130304182841.GA27905@magnum.frso.rivierawaves.com> (sfid-20130304_193131_862809_F35DC309)
References: <1361966434-28343-1-git-send-email-karl.beldan@gmail.com>
 <1361966434-28343-2-git-send-email-karl.beldan@gmail.com>
 <20130227133802.GA28291@magnum.frso.rivierawaves.com>
 <1362412228.21028.36.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1362412228.21028.36.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 04:50:28PM +0100, Johannes Berg wrote:
> On Wed, 2013-02-27 at 14:38 +0100, Karl Beldan wrote:
> 
> > >  	mask = txrc->rate_idx_mask;
> > > -	memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
> > > -	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
> > > +	if (mask != (1 << txrc->sband->n_bitrates) - 1 ||
> > > +		memcmp(txrc->sband->ht_cap.mcs.rx_mask, txrc->rate_idx_mcs_mask,
> > > +		       sizeof(txrc->rate_idx_mcs_mask))) {
> > > +		memcpy(mcs_mask, txrc->rate_idx_mcs_mask, sizeof(mcs_mask));
> > > +
> > >  		if (sta) {
> > > 
> > 
> > I don't know why I refrained myself from getting rid of the copies of
> > the masks altogether.
> 
> Are you going to resend?
> 
Just did.

