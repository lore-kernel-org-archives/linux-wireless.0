Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:43663 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbYJ1OYJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 10:24:09 -0400
Received: by yw-out-2324.google.com with SMTP id 9so637037ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 07:24:07 -0700 (PDT)
Message-ID: <1ba2fa240810280724i54bfc61cqd2fde19bc37e3639@mail.gmail.com> (sfid-20081028_152416_573203_76A81C21)
Date: Tue, 28 Oct 2008 16:24:06 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <m.sujith@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <1225123449.3796.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224669827.28639.54.camel@johannes.berg>
	 <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	 <1224696170.30459.12.camel@johannes.berg>
	 <18688.15460.336059.400706@gargle.gargle.HOWL>
	 <1224773201.6002.35.camel@johannes.berg>
	 <18693.53054.116942.355275@localhost.localdomain>
	 <1225119894.3796.0.camel@johannes.berg>
	 <1ba2fa240810270856g7f585ddcvb1d0ef49aa31af45@mail.gmail.com>
	 <1225123449.3796.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 6:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-27 at 17:56 +0200, Tomas Winkler wrote:
>
>> In addition iwlwifi HW release TX packets in order to mac80211 i.e. no
>> need to maintain the transition window
>> so simple flag maybe shell revert the flow into regular tx response
>> flow in mac80211.
>> Only rate scaling is aware that the packets were transmitted
>> aggregated, we did some hacking there around this it should be cleaned
>> up.
>
> I wonder how we're going to pass them down to the driver anyway. And how
> about rate control, is that really done per sub-frame? Does that make
> any sense?

Sub frame? This is bit misleading in this context .This is not AMSDU.
This is rather a regular frame to be sent in a burst.

>I'm thinking that if we pass a fraglist down for the ampdu,

If you are able to do this you can also build AMSDU frame from the
frames, in AMPDU i prefer the streaming approach
and the decision about how many frames get into current TXOP is pushed
as low as possible, But maybe again I'm seeing this from iwlwifi
perspective.

> then we should have the fraglist in tx status too, in one go... If rate
> control is per subframe maybe it just needs to be made aware to walk the
> fraglist?

The rate scale should be aware of aggregation in order to be more
responsive (consider each aggregation as single transition) while
frame completion should be in order to preserve ordered definition of
802.11. protocol to upper layers (only completed sub window is
released up)

Tomas
