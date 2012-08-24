Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53127 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2HXMFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 08:05:34 -0400
Message-ID: <1345809927.6991.0.camel@jlt3.sipsolutions.net> (sfid-20120824_140538_748161_656AABCA)
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Fri, 24 Aug 2012 14:05:27 +0200
In-Reply-To: <50376671.7080007@posedge.com>
References: <502E85D9.5050301@posedge.com>
	 <1345480718.4459.37.camel@jlt3.sipsolutions.net>
	 <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>
	 <50338E84.3050709@posedge.com>
	 <1345564421.10280.9.camel@jlt3.sipsolutions.net>
	 <5033CE76.6040306@posedge.com>
	 <1345619008.4635.3.camel@jlt3.sipsolutions.net>
	 <20120822090104.GA4959@redhat.com>
	 <1345626282.4635.8.camel@jlt3.sipsolutions.net>
	 <20120822101252.GA6082@redhat.com> <50376671.7080007@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-08-24 at 17:03 +0530, Mahesh Palivela wrote:

> /**
>   * enum ieee80211_chan_width - channel bandwidths
>   *
>   * @IEEE80211_CHAN_WIDTH_20MHZ: 20 MHz chan bandwidth
>   * @IEEE80211_CHAN_WIDTH_40MHZ: 40 MHz chan bandwidth
>   * @IEEE80211_CHAN_WIDTH_80MHZ: 80 MHz chan bandwidth
>   * @IEEE80211_CHAN_WIDTH_160MHZ: 160 MHz chan bandwidth
>   */

We might need 20MHZ_NOHT or something?

>          enum ieee80211_chan_width chan_width2;
>          u16 control_offset2;

Those shouldn't be necessary, I think? The secondary 80 MHz channel
can't have a control channel, it seems, and the width should be the same
as well? Plus this is only allowed in 80+80 anyway.

johannes

