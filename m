Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.235]:62452 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYBDOVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 09:21:46 -0500
Received: by wr-out-0506.google.com with SMTP id c48so1514832wra.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 06:21:45 -0800 (PST)
Message-ID: <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com> (sfid-20080204_142152_630412_C0824B8E)
Date: Mon, 4 Feb 2008 16:21:44 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: "Felix Fietkau" <nbd@openwrt.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <-5971017268625562167@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <-4694429725714512287@unknownmsgid>
	 <1ba2fa240802040321s515e61deld176d79eef2b444d@mail.gmail.com>
	 <-2417195033053015320@unknownmsgid>
	 <1ba2fa240802040326v425fe147y52f2d8731e3012cb@mail.gmail.com>
	 <1ba2fa240802040330o5b9ffb2dk32b28f7f959e49f4@mail.gmail.com>
	 <5358276387473684738@unknownmsgid>
	 <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com>
	 <47A718CF.50303@openwrt.org> <-5971017268625562167@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 4:04 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Felix Fietkau wrote:
>
> > I'd like to have multiple rates in the tx status, including the number of
> > attempts for each rate. The Minstrel rate control needs these to build its
> > statistics properly.

> Maybe we should add two new structures:
>  (a) struct ieee80211_ratectrl_tx_status
> and
>  (b) struct ieee80211_tx_ratectrl
>
> both containing a struct ieee80211_bitrate * and u32 rate_ctrl_flags, then
> we can build arrays of these where necessary and/or embed them in
> tx_status and tx_control.

I think we should also remove ieee80211_tx_control from  ieee80211_tx_status.
Maybe we should add blob to tx_status let say of skb->cb[] size and
field for rate scale algorithm version/name.  Otherwise we will be
inventing API for each rate scale algorithm... or maybe I'm giving up
to reach something general...

Tomas



> johannes
>
