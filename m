Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:1118 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYBDSgw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 13:36:52 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3070980wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 10:36:51 -0800 (PST)
Message-ID: <1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com> (sfid-20080204_183656_183967_A8C227DD)
Date: Mon, 4 Feb 2008 20:36:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Felix Fietkau" <nbd@openwrt.org>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <47A72E13.8070305@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240802040330o5b9ffb2dk32b28f7f959e49f4@mail.gmail.com>
	 <5358276387473684738@unknownmsgid>
	 <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com>
	 <47A718CF.50303@openwrt.org> <-5971017268625562167@unknownmsgid>
	 <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>
	 <-7767648866191425885@unknownmsgid>
	 <1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com>
	 <47A72E13.8070305@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 5:24 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Tomas Winkler wrote:
> >> > Maybe we should add blob to tx_status let say of skb->cb[] size and
> >> > field for rate scale algorithm version/name.  Otherwise we will be
> >> > inventing API for each rate scale algorithm...
> >>
> >> I disagree, we should have something generic enough to allow some sort of
> >> "capability negotiation" between the driver and the rate control
> >> algorithm, otherwise we could just remove rate control algorithms
> >> completely and internalize them into drivers (with some "helper" functions
> >> for those who don't want to write their own)... Which I'm sure you might
> >> actually like but I don't ;)
> >
> > So Felix how many rates do you need for each packet?
> The algorithm is designed to work with 4 different rates with adjustable
> retry counts. A good description can be found here:
> http://madwifi.org/browser/madwifi/trunk/ath_rate/minstrel/minstrel.txt
>

Will this work work you?

ieee80211_tx_ratectrl {
  u32 bitrate ( or pointer to ieee80211_rate I prefer no)
  u32 flags
  u32 retry_count
}

ieee80211_tx_status {
    ieee80211_tx_ratectrl  retry_count[ X]  / * X >= 4 */
}


Thanks
Tomas

> - Felix
>
