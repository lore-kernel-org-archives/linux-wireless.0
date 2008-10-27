Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:55288 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbYJ0QBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 12:01:46 -0400
Received: by gxk11 with SMTP id 11so198811gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 09:01:45 -0700 (PDT)
Message-ID: <1ba2fa240810270856g7f585ddcvb1d0ef49aa31af45@mail.gmail.com> (sfid-20081027_170153_040830_3ED2E04C)
Date: Mon, 27 Oct 2008 17:56:40 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: Sujith <m.sujith@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <1225119894.3796.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <18684.51206.771543.514682@localhost.localdomain>
	 <1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	 <1224669827.28639.54.camel@johannes.berg>
	 <1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	 <1224696170.30459.12.camel@johannes.berg>
	 <18688.15460.336059.400706@gargle.gargle.HOWL>
	 <1224773201.6002.35.camel@johannes.berg>
	 <18693.53054.116942.355275@localhost.localdomain>
	 <1225119894.3796.0.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 27, 2008 at 5:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-27 at 19:55 +0530, Sujith wrote:
>> Johannes Berg wrote:
>> > We have this "ampdu_ack_map" parameter in the TX status which could be
>> > set by the driver. But that assumes we only want a single TX status for
>> > all A-MPDU frames, do we really? Or do we want to split them up and
>> > handle it all in mac80211?
>>
>> I wasn't aware of this parameter at all. Looks useful.
>>
>> Atheros HW reports the Block Ack bitmap of the entire aggregate.
>> So passing that up to mac80211, and letting mac80211 handle retransmissions would work.
>> I am not sure about Intel.
>
> Intel does the retransmissions in hw. Not sure how we'd want to handle
> that difference.

In addition iwlwifi HW release TX packets in order to mac80211 i.e. no
need to maintain the transition window
so simple flag maybe shell revert the flow into regular tx response
flow in mac80211.
Only rate scaling is aware that the packets were transmitted
aggregated, we did some hacking there around this it should be cleaned
up.

Tomas
