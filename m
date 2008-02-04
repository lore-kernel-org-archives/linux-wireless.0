Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:60753 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYBDK1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 05:27:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2870676wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 02:27:54 -0800 (PST)
Message-ID: <1ba2fa240802040227g23fe41adu446adc8f0de22712@mail.gmail.com> (sfid-20080204_102804_728617_F540E02D)
Date: Mon, 4 Feb 2008 12:27:54 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <6231174111099834440@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1202114774.4188.127.camel@johannes.berg>
	 <1ba2fa240802040153g1d0c9902u6af2ddf3dead975d@mail.gmail.com>
	 <6231174111099834440@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 11:56 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > Where would be this pointer allocated? TX response is not the same
> > flow as TX where we keep it on the stack. It's will be very error
> > prone to be outside tx_status. From concept perspective you already
> > have all transimission information in that structure.
> > For iwlwifi I actually need only u32 value but I was looking for
> > something more general even it's a little pain.
>
> You don't need to allocate it, it can just point to the rate array you
> have registered, no? Rates information is static after all. Or do it like
> rx status where we pass the index into the rate array.

I prefer not. This is not just plcp rate there is also MCS flags that
have to passed. With all combinations the array will be huge.

Tomas

> johannes
>
