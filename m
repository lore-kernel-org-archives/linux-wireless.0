Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50220 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3BVEYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 23:24:44 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20774.62135.517866.874519@gargle.gargle.HOWL> (sfid-20130222_052450_678271_EC338C7E)
Date: Fri, 22 Feb 2013 09:53:19 +0530
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 3.7.6+:  ath9k:  tx logic locks up after taking attenuation very
 high.
In-Reply-To: <5126A993.8060408@candelatech.com>
References: <511935F2.8080103@candelatech.com>
	<20761.34987.125000.908722@gargle.gargle.HOWL>
	<511BC243.8010409@candelatech.com>
	<20770.57339.20017.225929@gargle.gargle.HOWL>
	<51255360.6060603@candelatech.com>
	<51257304.10109@candelatech.com>
	<20773.31380.740958.31338@gargle.gargle.HOWL>
	<5125B39F.3010200@candelatech.com>
	<51265AC3.5030304@candelatech.com>
	<5126A993.8060408@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> Ok, I think I see the problem, or at least some of it.
> 
> When the attenuation goes very high (signal of -80 or lower),
> all transmit basically stops, at least for a bit (possibly while
> rate-control algorithms adjust).
> 
> During this time, the ath_tx_complete_poll_work logic can hit,
> causing a reset of the NIC.

Doing a chip reset because a station goes out of range doesn't seem correct.

Sujith
