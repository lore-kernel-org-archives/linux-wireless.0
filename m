Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:30331 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763164AbYBEXPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 18:15:36 -0500
Received: by wa-out-1112.google.com with SMTP id v27so139485wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2008 15:15:35 -0800 (PST)
Message-ID: <1ba2fa240802051515y4028608cj38047fcebeec0898@mail.gmail.com> (sfid-20080205_231557_082551_A728F850)
Date: Wed, 6 Feb 2008 01:15:34 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Stefano Brivio" <stefano.brivio@polimi.it>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: "Felix Fietkau" <nbd@openwrt.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080205222340.70e043cd@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>
	 <-7767648866191425885@unknownmsgid>
	 <1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com>
	 <47A72E13.8070305@openwrt.org>
	 <1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com>
	 <47A75BF5.90101@openwrt.org>
	 <1ba2fa240802041103v622db90co2ddc24eda3347ffc@mail.gmail.com>
	 <1ba2fa240802041105g1e11ba99ldaca4acee4a07c35@mail.gmail.com>
	 <20080205222340.70e043cd@morte>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 5, 2008 11:23 PM, Stefano Brivio <stefano.brivio@polimi.it> wrote:
> On Mon, 4 Feb 2008 21:05:25 +0200
> "Tomas Winkler" <tomasw@gmail.com> wrote:
>
> > Sorry I meant
> > ieee80211_tx_status {
> > >          size_t nrates;
> > >          ieee80211_tx_ratectrl  rates[0] ;
> > > }
>
> FWIW, I'm OK with this. BTW, further changes to this may be required in
> the future as I plan to rework a bit the whole tx_status thing so that
> drivers won't have to report ACKed frames but failed and retransmitted
> frames only - this would reduce the load on slow buses such as USB.
>
Just keep in mind that some driver requires to report ACKed frames to
make rate scaling algorithm to work properly, this should be optional
only.
Second I believe for some management frames it's good to notify mac
about successful transmission regardless of rate scaling algorithm.

Thanks
Tomas
> --
> Ciao
> Stefano
>
