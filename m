Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:24765 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbYBDJxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 04:53:39 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2856206wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 01:53:38 -0800 (PST)
Message-ID: <1ba2fa240802040153g1d0c9902u6af2ddf3dead975d@mail.gmail.com> (sfid-20080204_095343_674450_52CF9DC1)
Date: Mon, 4 Feb 2008 11:53:38 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <1202114774.4188.127.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1202114774.4188.127.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 10:46 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index 460da54..a700ea6 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -342,6 +342,7 @@ enum ieee80211_tx_status_flags {
> >   *
> >   * @control: a copy of the &struct ieee80211_tx_control passed to the driver
> >   *   in the tx() callback.
> > + * @rate: rate at which the packet was actually transmitted
> >   * @flags: transmit status flags, defined above
> >   * @retry_count: number of retries
> >   * @excessive_retries: set to 1 if the frame was retried many times
> > @@ -356,6 +357,7 @@ enum ieee80211_tx_status_flags {
> >   */
> >  struct ieee80211_tx_status {
> >       struct ieee80211_tx_control control;
> > +     struct ieee80211_rate rate;
>
> Shouldn't that rather be a rate pointer? Seems a bit odd to me to copy
> that information. Felix, could this help you as well?

Where would be this pointer allocated? TX response is not the same
flow as TX where we keep it on the stack. It's will be very error
prone to be outside tx_status. From concept perspective you already
have all transimission information in that structure.
For iwlwifi I actually need only u32 value but I was looking for
something more general even it's a little pain.
I'm not sure but I guess we may as well separate ieee80211_tx_control
form ieee80211_tx_status as they carry different information

Thanks
Tomas

> johannes
>
