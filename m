Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:61230 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758515AbXKOKdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 05:33:49 -0500
Received: by wr-out-0506.google.com with SMTP id 36so493555wra
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2007 02:33:48 -0800 (PST)
Message-ID: <247d6d340711150233h7988220fifb0d34170d16a979@mail.gmail.com> (sfid-20071115_103413_751727_22D7972C)
Date: Thu, 15 Nov 2007 12:33:48 +0200
From: "Guy Cohen" <guy.cohen@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate IEEE802.11n support
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <1195056662.4091.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <1195056662.4091.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

We understand that these two issues need to be taken care of, and they
will be. My concern is that if current patches won't be merged soon,
we will have to pay the effort to rebase the patches again. We are
very limited with resources dedicated to supporting the merge of
802.11n to wireless-dev. This mailing list taught us in the "hard way"
in the recent months: submit often submit early... So for making Ron's
work efficient I suggest to merge his patches and let him do the fixes
on top of them, specially since the two fixes are not 802.11n core
critical issues and don't break any existing working flows. Do you
feel comfortable with this approach?

Guy.

On 11/14/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> Overall, looks pretty good. I personally prefer things like (!xyz)
> rather than (xyz == NULL) but that's totally minor. I'll take a more
> detailed look later and check out the frame flow etc.
>
> >  - Changes to Rx handlers PAE and drop unencrypted (for EAPOL frames in amsdu)
> >  - Examine config flows in mac80211 (RFC is prepered)
>
> I'd prefer to have this patch series depend on these two items instead
> because as it stands, we have a weird behaviour here and quite a lot of
> duplicated code in the data/agg_data RX handlers. I thought your RFC was
> pretty good except that you didn't want to convert existing stuff to it,
> so...
>
> johannes
>
>
