Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-1.exch022.serverdata.net ([206.225.164.184]:51852
	"EHLO HUB022-nj-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885Ab2HXLdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 07:33:11 -0400
Message-ID: <50376671.7080007@posedge.com> (sfid-20120824_133315_053662_D757BC25)
Date: Fri, 24 Aug 2012 17:03:05 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <502E85D9.5050301@posedge.com> <1345480718.4459.37.camel@jlt3.sipsolutions.net> <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com> <50338E84.3050709@posedge.com> <1345564421.10280.9.camel@jlt3.sipsolutions.net> <5033CE76.6040306@posedge.com> <1345619008.4635.3.camel@jlt3.sipsolutions.net> <20120822090104.GA4959@redhat.com> <1345626282.4635.8.camel@jlt3.sipsolutions.net> <20120822101252.GA6082@redhat.com>
In-Reply-To: <20120822101252.GA6082@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> I see, we could add helper function that will calculate
> center_freq/bandwidth, but starting from defining new channel
> structure and accompanying code in nl80211/mac80211 is more
> reasonable.
>
> Stanislaw
>
How about below new channel config structure? wanted to fit 80+80 config 
as well.

/**
  * enum ieee80211_chan_width - channel bandwidths
  *
  * @IEEE80211_CHAN_WIDTH_20MHZ: 20 MHz chan bandwidth
  * @IEEE80211_CHAN_WIDTH_40MHZ: 40 MHz chan bandwidth
  * @IEEE80211_CHAN_WIDTH_80MHZ: 80 MHz chan bandwidth
  * @IEEE80211_CHAN_WIDTH_160MHZ: 160 MHz chan bandwidth
  */
enum ieee80211_chan_width {
         IEEE80211_CHAN_WIDTH_20MHZ = 20,
         IEEE80211_CHAN_WIDTH_40MHZ = 40,
         IEEE80211_CHAN_WIDTH_80MHZ = 80,
         IEEE80211_CHAN_WIDTH_160MHZ = 160
};

/**
  * struct ieee80211_channel_config - channel config definition
  *
  * This structure describes channel configuration
  *
  * @chan_width1: channel bandwidth 1
  * @center_freq1: center frequency 1 for entire chan width
  * @control_offset1: control chan offset 1
  * @chan_width2: channel bandwidth 2
  * @center_freq2: center frequency 2 for entire chan width
  * @control_offset2: control chan offset 2
  */
struct ieee80211_channel_config {
         enum ieee80211_chan_width chan_width1;
         u16 center_freq1;
         u16 control_offset1;
         enum ieee80211_chan_width chan_width2;
         u16 center_freq2;
         u16 control_offset2;
};
