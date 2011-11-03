Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45664 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754824Ab1KCSPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 14:15:21 -0400
Message-ID: <4EB2DA35.3040708@openwrt.org> (sfid-20111103_191525_039042_C42D647A)
Date: Thu, 03 Nov 2011 19:15:17 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com
Subject: Re: [RFC v2 2/2] ath9k: integrate initial DFS module
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com> <1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com> <4EB2AF36.9070608@openwrt.org> <4EB2D6DE.3050207@neratec.com>
In-Reply-To: <4EB2D6DE.3050207@neratec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-03 7:01 PM, Zefir Kurtisi wrote:
> Hi Felix,
>
> while I was waiting for your feedback on my related patch, I assumed
> you're okay with having those rx filter flags preserved in ath_calcrxfilter.
I did send some feedback on the rx filter preserve patch. I think it's 
unnecessary and should be left out. If calcrxfilter properly returns the 
ATH9K_RX_FILTER_PHYRADAR flag where necessary, then no preserve logic is 
needed.

> I'll check your proposal for v3.
>
> BTW, as the comment says, it is TODO enable radar detection only for
> DFS channels. Beside the lack of the management module to provide the
> relevant information, it comes handy to test pulse detection on non-DFS
> channels without the need to modify hostapd ;)
Yeah, but it would be nice to split hardware capability from runtime 
state early on.

- Felix
