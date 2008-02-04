Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:20959 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbYBDPNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 10:13:44 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2988527wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 07:13:44 -0800 (PST)
Message-ID: <1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com> (sfid-20080204_151351_488552_A4AA9B82)
Date: Mon, 4 Feb 2008 17:13:40 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: "Felix Fietkau" <nbd@openwrt.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <-7767648866191425885@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <-2417195033053015320@unknownmsgid>
	 <1ba2fa240802040326v425fe147y52f2d8731e3012cb@mail.gmail.com>
	 <1ba2fa240802040330o5b9ffb2dk32b28f7f959e49f4@mail.gmail.com>
	 <5358276387473684738@unknownmsgid>
	 <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com>
	 <47A718CF.50303@openwrt.org> <-5971017268625562167@unknownmsgid>
	 <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>
	 <-7767648866191425885@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 4:25 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Tomas Winkler wrote:
>
> > I think we should also remove ieee80211_tx_control from
> > ieee80211_tx_status.
>
> Not sure. Where is it used?

Let's try, if it's break we won't be in worst situation then now :)

>
> > Maybe we should add blob to tx_status let say of skb->cb[] size and
> > field for rate scale algorithm version/name.  Otherwise we will be
> > inventing API for each rate scale algorithm...
>
> I disagree, we should have something generic enough to allow some sort of
> "capability negotiation" between the driver and the rate control
> algorithm, otherwise we could just remove rate control algorithms
> completely and internalize them into drivers (with some "helper" functions
> for those who don't want to write their own)... Which I'm sure you might
> actually like but I don't ;)

So Felix how many rates do you need for each packet?

Thanks
Tomas



> johannes
>
