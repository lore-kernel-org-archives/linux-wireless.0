Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:36502 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbYBDTDT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 14:03:19 -0500
Received: by wr-out-0506.google.com with SMTP id c48so1653458wra.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 11:03:16 -0800 (PST)
Message-ID: <1ba2fa240802041103v622db90co2ddc24eda3347ffc@mail.gmail.com> (sfid-20080204_190326_439229_F96EF059)
Date: Mon, 4 Feb 2008 21:03:14 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Felix Fietkau" <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <47A75BF5.90101@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com>
	 <47A718CF.50303@openwrt.org> <-5971017268625562167@unknownmsgid>
	 <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>
	 <-7767648866191425885@unknownmsgid>
	 <1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com>
	 <47A72E13.8070305@openwrt.org>
	 <1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com>
	 <47A75BF5.90101@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 8:39 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Tomas Winkler wrote:
> > Will this work work you?
> >
> > ieee80211_tx_ratectrl {
> >   u32 bitrate ( or pointer to ieee80211_rate I prefer no)
> >   u32 flags
> >   u32 retry_count
> > }
> >
> > ieee80211_tx_status {
> >     ieee80211_tx_ratectrl  retry_count[ X]  / * X >= 4 */
> > }
> I guess that would work, but shouln't the array below be dynamic based on
> what the driver can do? Many drivers can only work with one or two rates, IMHO.

The problem that this structure is passed with each packett I don't
like the idea that anybody would even try to allocate and free this
structure as packets goes. However what about the following?

ieee80211_tx_status {
         size_t nrates;
         ieee80211_tx_ratectrl  retry_count[0] ;
}

> - Felix
>
