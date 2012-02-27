Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50407 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab2B0PK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 10:10:28 -0500
Received: by wejx9 with SMTP id x9so334325wej.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 07:10:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
References: <1330343374.3483.46.camel@jlt3.sipsolutions.net>
Date: Mon, 27 Feb 2012 16:10:27 +0100
Message-ID: <CAA93jw4X-8x=V6WZstAwM8GyicN_ds8WHv8uYz4zF8d-KdNTsg@mail.gmail.com> (sfid-20120227_161032_285935_9E3C6676)
Subject: Re: mac80211 queue handling in multi-channel
From: Dave Taht <dave.taht@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 12:49 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:

> As a consequence, I'm thinking that we should redesign the mac80211 /
> driver queue API to mirror more closely the kind of queues hardware
> really has.

I'd like the driver queues to mirror more closely the kinds of
connections the hardware really has. I realize that this is more of an
AP orientation than a wireless client orientation, but with wildly
different rates between connected devices bad things happen.

Secondly, my take on 802.11e QoS and wireless-n aggregation is that
aggregation wins nearly every time; all
802.11e does is bloat up the buffers.

> To recap: today, almost all drivers expose four queues to mac80211 for
> the four ACs. In reality, many have many more queues, e.g. in iwlwifi:
>  * 4 for the first vif
>  * 4 for the second vif
>  * 1 for CAB (content after [DTIM] beacon)
>  * 1 for off-channel
>
> They are mapped as follows:
>  * all vif ACs -> 4 ACs
>  * off-channel -> BE
>  * CAB         -> BE (I believe, maybe all?)
>
> Thus when e.g. in our driver the BE queue for the second VIF is full, we
> stop all traffic across all VIFs. When both VIFs are on the same
> channel, this isn't really a problem. However, when they are on
> different channels, there could be vastly different performance
> characteristics on those two channels due to interference etc.

And even more differences based on the destination's characteristics.




-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
http://www.bufferbloat.net
