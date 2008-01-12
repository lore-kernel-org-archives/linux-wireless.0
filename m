Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:28159 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbYALLnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 06:43:11 -0500
Received: by wa-out-1112.google.com with SMTP id v27so2359987wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2008 03:43:08 -0800 (PST)
Message-ID: <1ba2fa240801120343v2e60acc8kc56469106cf56df1@mail.gmail.com> (sfid-20080112_114320_144700_31C5C106)
Date: Sat, 12 Jan 2008 13:43:08 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 07/10] mac80211: A-MPDU Tx change tx_status to support Block Ack data
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, yi.zhu@intel.com
In-Reply-To: <1200070609.3861.208.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857502772-git-send-email-ron.rindjunsky@intel.com>
	 <1200070609.3861.208.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 11, 2008 6:56 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > + * @ampdu_ack_len: number of aggregated frames.
> > + *   relevant only if IEEE80211_TX_STATUS_AMPDU was set.
> > + * @ampdu_ack_map: block ack bit map for the aggregation.
> > + *   relevant only if IEEE80211_TX_STATUS_AMPDU was set.
>
> Can you explain what that bitmap contains?
>

This actually represents Block Ack frame. This is bitmap of received
and failed frames in the aggregation.
Rate scale algorithm should not be concern with parsing BACK frame so
the info is summarized to something useful to rate scale algorithm
at least to what we believe is. We don't have much information as
other vendor view this.
The bitmap is useful to keep statistic window accurate.
All the frames are sent in same rate (currently we didn't see other
implementation)

> Broadcom hardware is able to give intermediate status notifications,
> would there be any use in those?

Can you explain?

Tomas
> johannes
>
