Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3CSS2H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 14:28:07 -0400
Message-ID: <1363717676.8336.3.camel@jlt4.sipsolutions.net> (sfid-20130319_192811_797215_9BE924AB)
Subject: Re: [RFC V2 1/2] mac80211: Use a cfg80211_chan_def in
 ieee80211_hw_conf_chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Mahesh Palivela <maheshp@posedge.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Tue, 19 Mar 2013 19:27:56 +0100
In-Reply-To: <20130319122836.GA26078@magnum.frso.rivierawaves.com> (sfid-20130319_133144_369883_B8D75C15)
References: <1363652600-23223-1-git-send-email-karl.beldan@gmail.com>
	 <1363652600-23223-2-git-send-email-karl.beldan@gmail.com>
	 <1363693626.3355.14.camel@WLAN-SW-TEST-03>
	 <20130319122836.GA26078@magnum.frso.rivierawaves.com>
	 (sfid-20130319_133144_369883_B8D75C15)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-19 at 13:28 +0100, Karl Beldan wrote:

> > > +	cfreq_off = local->csa_channel->center_freq -
> > > +		local->_oper_chandef.chan->center_freq;
> > > +
> > > +	local->_oper_chandef.center_freq1 += cfreq_off;
> > > +	local->_oper_chandef.center_freq2 += cfreq_off;
> > 
> > can't add cfreq_off to center_freq2. Add only in case of non-zero
> > center_freq2?

Yeah this is certainly not right ... anyway no driver supports 80+80
now, so no harm done, but anyway I don't really like any of this. We
really need to handle extended chanswitch ...

Maybe we should just disconnect entirely (like we do for chanctx today)
if we have a channel that's wider than 20 MHz, since we don't handle
chanswitch properly.

johannes

