Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-2.exch022.serverdata.net ([206.225.164.185]:4194 "EHLO
	HUB022-nj-2.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab2H0EPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 00:15:48 -0400
Message-ID: <503AF46A.4030704@posedge.com> (sfid-20120827_061631_919046_F011F2FD)
Date: Mon, 27 Aug 2012 09:45:38 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Subject: Re: [PATCH] cfg80211: VHT (11ac) Regulatory change
References: <502E85D9.5050301@posedge.com>   <1345480718.4459.37.camel@jlt3.sipsolutions.net>   <87d32k7kga.fsf@purkki.adurom.net> <20120821081839.GA2380@redhat.com>   <50338E84.3050709@posedge.com>   <1345564421.10280.9.camel@jlt3.sipsolutions.net>   <5033CE76.6040306@posedge.com>   <1345619008.4635.3.camel@jlt3.sipsolutions.net>   <20120822090104.GA4959@redhat.com>   <1345626282.4635.8.camel@jlt3.sipsolutions.net>   <20120822101252.GA6082@redhat.com> <50376671.7080007@posedge.com>  <1345809927.6991.0.camel@jlt3.sipsolutions.net>  <50377CD9.3090204@posedge.com> <1345970386.3622.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1345970386.3622.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/26/2012 02:09 PM, Johannes Berg wrote:
> On Fri, 2012-08-24 at 18:38 +0530, Mahesh Palivela wrote:
>
> We don't support 5/10 MHz (yet anyway), so we don't have to worry about
> that.
>

Oh, for legacy we still depend on chan_type setting for sometime?

>> so country might allow primary chan to fall in other frequency segment?
>
> Yes, but how's that related to how you specify the channel?
>

ok. I will change the channel config structure per 11ac spec.

dot11CurrentChannelBandwidth
       Channel bandwidth. Possible values represent 20 MHz, 40 MHz,
       80 MHz, 160 MHz and 80+80 MHz channels.

dot11CurrentChannelCenterFrequencyIndex0
       In 20 MHz, 40 MHz, 80 MHz and 160 MHz channels, denotes
       the channel center frequency.In 80+80 MHz channels, denotes the
       center frequency of the frequency segment 0, which is the
       frequency segment containing the primary channel.
       Valid range is 1 to 200.

dot11CurrentChannelCenterFrequencyIndex1
       In 80+80 MHz channels, denotes the center frequency of the fre-
       quency segment 1, which is the frequency segment that does not
       contain the primary channel.Valid range is 1 to 200.
       Undefined for 20 MHz, 40 MHz, 80 MHz and 160 MHz chan-
                                    nels.
dot11CurrentPrimaryChannel
       Denotes the location of the primary 20 MHz channel.
       Valid range is 1 to 200.


> joahnnes
>
