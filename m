Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:5194 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759288AbXKOSGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:06:06 -0500
Received: by fk-out-0910.google.com with SMTP id z23so608550fkz
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 10:06:04 -0800 (PST)
Message-ID: <c85cb4470711151006j765831f9w2fb941317153712c@mail.gmail.com> (sfid-20071115_180618_350112_E111B5AD)
Date: Thu, 15 Nov 2007 20:06:02 +0200
From: "Ron Rindzonski" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate IEEE802.11n support
Cc: "Guy Cohen" <guy.cohen@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <1195142683.13846.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <1195056662.4091.29.camel@johannes.berg>
	 <247d6d340711150233h7988220fifb0d34170d16a979@mail.gmail.com>
	 <1195142683.13846.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Guy,
>
> > We understand that these two issues need to be taken care of, and they
> > will be. My concern is that if current patches won't be merged soon,
> > we will have to pay the effort to rebase the patches again. We are
> > very limited with resources dedicated to supporting the merge of
> > 802.11n to wireless-dev. This mailing list taught us in the "hard way"
> > in the recent months: submit often submit early... So for making Ron's
> > work efficient I suggest to merge his patches and let him do the fixes
> > on top of them, specially since the two fixes are not 802.11n core
> > critical issues and don't break any existing working flows. Do you
> > feel comfortable with this approach?
>
> I understand your concern, however, if for some reason this doesn't
> happen quickly enough we'll end up with code that is vulnerable in weird
> ways. I'd have no issue with these patches if deaggregation support was
> optional until we have the patchset that reworks that code. Can we do
> that?

I would have to mention at this point that A-MSDU deaggregation is
obligatory according to the 802.11n, so excluding it would be a spec
violation.
What I will do is to put some out-of-band effort here, fixing the
rx_h_data infrastructure, so it will be able to support rx_h_amsdu as
well, thus eliminating the EAPOL bug.
I hope that this fix will be ready soon in order to enable the merge,
and then i will move on to next steps.
Ron

> johannes
>
>
