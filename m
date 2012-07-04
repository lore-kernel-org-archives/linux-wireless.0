Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40191 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab2GDFlP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 01:41:15 -0400
From: Vladimir Kondratiev <vkondrat_qca@qca.qualcomm.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] {nl,cfg}80211: support high bitrates
Date: Wed, 04 Jul 2012 08:41:08 +0300
Message-ID: <1631430.V8ZCGtcpIm@lx-vladimir> (sfid-20120704_074127_397525_7AEB2651)
In-Reply-To: <CAB=NE6WqzHkyg94hif7hZ2EqE5EQgAX8QbexhGNoQcu27Mt2cA@mail.gmail.com>
References: <1341304650-2593-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1341304650-2593-2-git-send-email-qca_vkondrat@qca.qualcomm.com> <CAB=NE6WqzHkyg94hif7hZ2EqE5EQgAX8QbexhGNoQcu27Mt2cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 03, 2012 09:04:38 AM Luis R. Rodriguez wrote:
> On Tue, Jul 3, 2012 at 1:37 AM, Vladimir Kondratiev
> 
> <qca_vkondrat@qca.qualcomm.com> wrote:
> > User space tools should switch to new bitrate. Old one is deprecated and
> > going to be removed in the future.
> 
> Removed?? No way. You can't make old userspace break.
> 
> > @@ -1638,12 +1638,16 @@ struct nl80211_sta_flag_update {
> > 
> >   *
> >   * These attribute types are used with %NL80211_STA_INFO_TXRATE
> >   * when getting information about the bitrate of a station.
> > 
> > + * Legacy bitrate represented with 16-bit value, while new
> > + * "high throughput" bitrate uses 32-bit value. User space tools
> > + * should use new bitrate.
> 
> Something a bit more clearer would say that we send both, and that
> userspace should use the new one given that new technologies required
> a higher data type. 

Agree - I'll rephrase

> Also explaining what gets sent to userspace for
> those high data bit rates on the old data type would help -- from what
> I read in your patch we set those high bit rates to 0 on the old data
> type.

Not exactly. If value is 0, it is just not send:
(bitrate_compat > 0 &&
	     nla_put_u16(msg, NL80211_RATE_INFO_BITRATE, bitrate_compat)

> 
> >   *
> >   * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
> >   * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
> >   * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
> >   * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
> >   * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
> > 
> > + * @NL80211_RATE_INFO_BITRATE_HT: total bitrate (u32, 100kbit/s)
> 
> NL80211_RATE_INFO_BITRATE_HT seems misleading as likely we will also
> use this for VHT, and whatever other fun acronym the industry comes up
> with for bitrates for 802.11.

In case "HT" for "High Throuput" is misleading, I am open to any
other proposals. What name can you suggest?

Thanks, Vladimir
