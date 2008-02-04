Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.181]:8134 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbYBDNf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 08:35:57 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2948481wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 05:35:56 -0800 (PST)
Message-ID: <1ba2fa240802040535x32c2470fw807932fd4120a2a9@mail.gmail.com> (sfid-20080204_133605_871974_4F022B08)
Date: Mon, 4 Feb 2008 15:35:55 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Felix Fietkau" <nbd@openwrt.org>
In-Reply-To: <5605009721259660313@unknownmsgid>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240802040305u611bb7edk3c757b73f40c1037@mail.gmail.com>
	 <-4694429725714512287@unknownmsgid>
	 <1ba2fa240802040321s515e61deld176d79eef2b444d@mail.gmail.com>
	 <-2417195033053015320@unknownmsgid>
	 <1ba2fa240802040326v425fe147y52f2d8731e3012cb@mail.gmail.com>
	 <1ba2fa240802040330o5b9ffb2dk32b28f7f959e49f4@mail.gmail.com>
	 <5358276387473684738@unknownmsgid>
	 <1ba2fa240802040357vf517e6as374540e28dd1ab56@mail.gmail.com>
	 <5605009721259660313@unknownmsgid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 4, 2008 2:08 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Tomas Winkler wrote:
>
> >> Hmm? Not quite sure what you're asking. The tx_control has a pointer to
> >> the bitrate right now so that contains what bitrate the rate control
> >> algorithm selected (whether or not the hw downscales by itself).
> >
> > So we add rate flags and pointer to bit rate structure?
> > Correct?
>
> I thought we just agreed not to because they're not bit rate but rather
> rate control specific. Think of it this way: the rate control algorithm
> selects a bitrate and those control flags you mentioned (SISO/MIMO/...),
> right?
>
> So the rate control algorithm has to communicate the bitrate and the flags
> to the hardware. It currently communicates the bitrate selection by giving
> a bitrate structure pointer (it could simply give the bitrate in kbps or
> whatever but that would mean the driver needs to look up its hw_value so
> this is the reason for passing the pointer) and cannot currently
> communicate the control flags selection.
>
> So the way I see it we'd add something like "u32 rate_control_flags" to
> struct tx_control for the flags you wanted, and also add a similar field
> (to be able to reuse the flag definitions) to the tx status & rx status
> structs. It seems to me that makes most sense, no?

I think we're talking about the same

> johannes
>
