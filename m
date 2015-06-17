Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56515 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbbFQJmj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:42:39 -0400
Message-ID: <55814109.7030100@openwrt.org> (sfid-20150617_114251_641123_637D2FB2)
Date: Wed, 17 Jun 2015 11:42:33 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>	<21889.11726.101648.552280@gargle.gargle.HOWL>	<55812FB5.1070005@openwrt.org>	<21889.14109.54454.563245@gargle.gargle.HOWL>	<CALhHN=ro4K6mALLHqgVRGm50UGg5hh9mnSSAnNHwZdZ5ywOk-Q@mail.gmail.com> <21889.16487.258289.588207@gargle.gargle.HOWL>
In-Reply-To: <21889.16487.258289.588207@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-06-17 11:39, Sujith Manoharan wrote:
> Janusz Dziedzic wrote:
>> This is what I have with use_chanctx=1
>> Jun 17 06:57:54 dell6430 kernel: [53297.753256] xxx ath_calcrxfilter
>> filter: 0x207
>> 
>> 0x000000080 is for probe_req
> 
> Ok, so the probe_req filter is set before actually initiating
> RoC - this appears to be the current design in wpa_s.
> 
> I am not sure if using a global filter that disregards
> the opmode of a context is the right approach, though...
The filter is intended to be global in the mac80211 API.
Treating it as per channel-context inside the driver is a bug.

- Felix
