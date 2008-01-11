Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:10903 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759787AbYAKWsw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 17:48:52 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2020545wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jan 2008 14:48:52 -0800 (PST)
Message-ID: <1ba2fa240801111448p7b2274ewd31becc56e57fc66@mail.gmail.com> (sfid-20080111_224856_214289_78274620)
Date: Sat, 12 Jan 2008 00:48:52 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: handing cloned frames to netif_rx()?
Cc: netdev <netdev@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1200014246.3861.148.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1200014246.3861.148.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 11, 2008 3:17 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> In 802.11n, there is a case where multiple data frames are received
> aggregated into a single frame (A-MSDU).
>
> Currently, we copy each of these frames out into their own skb, but
> because of the alignment with that etc. I started to think that we could
> simply pass up a clone of the original skb with start/length adjusted
> properly so that it windows only the contained packet.
>
> The buffer would be shared but the data within the original window
> (starting with the 802.3 header) could even be written to, it won't be
> needed again by mac80211 once it's handed off to netif_rx(). The skb
> will obviously have lots of head- and tailroom but that space would be
> part of other packets.
>
> Is it ok to do this? Will something freak out if we pass a cloned skb to
> netif_rx()?
>
This would be great even in regular case. 4965 has ability to deliver
more frames per receiving buffer
Because of A-MSDU we keeps 8K receiving buffers which are
underutilized when A-MSDU is not used.

> johannes
>
