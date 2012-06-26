Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2FZMJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:09:00 -0400
Message-ID: <1340712536.14634.13.camel@jlt3.sipsolutions.net> (sfid-20120626_140905_688272_B2564890)
Subject: Re: [PATCH] mac80211: use legacy mode for all ACs
From: Johannes Berg <johannes@sipsolutions.net>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 14:08:56 +0200
In-Reply-To: <1340712213-10193-1-git-send-email-eyal@wizery.com> (sfid-20120626_140342_634660_99A0DCE2)
References: <1340712213-10193-1-git-send-email-eyal@wizery.com>
	 (sfid-20120626_140342_634660_99A0DCE2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 15:03 +0300, Eyal Shapira wrote:
> AVM FritzBox 7390 has a weird behaviour where once we enable
> U-APSD only on the VO AC it limits the rate of the packets
> it sends to 39Mbps and doesn't do AMPDU aggregation.
> This causes a big degradation in throughput obviously.
> It's important to note that this isn't related to PS and happens
> also when ACTIVE is forced. The traffic affected is sent in BE AC.
> Once legacy mode for all ACs is used the AP begins using higher rates
> as well as AMPDU aggregation which improves throughput significantly.
> 
> In order to deal with this AP and potentially others switch to
> using legacy mode for all ACs by default.

This actually somewhat makes sense if they have a bad aggregation
implementation, because you don't want VO to have latency, *especially*
not when uAPSD was enabled, indicating that you want VO-like low-latency
behaviour.

I don't see why you're optimising for TPT on VO rather then latency?

johannes

