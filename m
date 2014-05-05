Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36124 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773AbaEEJhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 05:37:54 -0400
Received: by mail-ig0-f177.google.com with SMTP id l13so2022649iga.10
        for <linux-wireless@vger.kernel.org>; Mon, 05 May 2014 02:37:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <536757DA.1010205@openwrt.org>
References: <1399150555-36041-1-git-send-email-nbd@openwrt.org>
	<1399275222.22235.2.camel@jlt4.sipsolutions.net>
	<536757DA.1010205@openwrt.org>
Date: Mon, 5 May 2014 11:37:53 +0200
Message-ID: <CAFED-j=t-XiCyjM2U66h-yWeWZBs9-_2FfHgvudoLmF-uTHyEQ@mail.gmail.com> (sfid-20140505_113805_191576_2156B468)
Subject: Re: [PATCH 3.15] cfg80211: allow restricting supported dfs regions
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-05-05 11:20 GMT+02:00 Felix Fietkau <nbd@openwrt.org>:
> On 2014-05-05 09:33, Johannes Berg wrote:
>> On Sat, 2014-05-03 at 22:55 +0200, Felix Fietkau wrote:
>>> At the moment, the ath9k/ath10k DFS module only supports detecting ETSI
>>> radar patterns.
>>
>> It seems this should also be advertised to the userspace.
> Right.
>
>>> Add a bitmap in the interface combinations, indicating which DFS regions
>>> are supported by the detector.
>>
>> Does that make sense? It seems unlikely to me that it would be interface
>> combination specific?
> Having it there made about as much sense to me as having the supportede
> channel width there :)
> Got any better suggestions?
>
>> I think it's already questionable to put this in after -rc4, in
>> particular with the userspace advertising part. Can we do anything
>> else?
> I mostly pushed it for 3.15, because right now you can already enable
> DFS and it will bring it up on a FCC regdomain and it will appear to be
> working (but probably just not recognize any radars).
>
In case you will choose FCC/JP which is not supported yet, single
pulse will trigger
radar detected event.
In case of supported patterns (ETSI) many pulses are checked (pattern)
and next we decide if that is an
radar or not.
So, after you will choose FCC/JP even single (even false) pulse will
trigger radar detected event and next switch to new channel ...
In practice this mean FCC/JP DFS channels became unusable.

BR
Janusz
