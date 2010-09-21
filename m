Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42627 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232Ab0IUTcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:32:50 -0400
Message-ID: <4C990859.70709@openwrt.org>
Date: Tue, 21 Sep 2010 21:32:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>	 <4C98A022.7020106@candelatech.com> <4C98A2C4.8060108@openwrt.org>	 <4C98EAA1.7050908@candelatech.com>  <4C98F2D8.8020602@openwrt.org> <1285097307.12764.11.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285097307.12764.11.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-21 9:28 PM, Johannes Berg wrote:
> On Tue, 2010-09-21 at 20:00 +0200, Felix Fietkau wrote:
> 
>> > Could we just poke a pointer to the STA into the ath_buf structure?
> 
>> No, that doesn't work because of RCU.
> 
> Well, it could work, if you walk all the structures upon sta_notify and
> remove now stale pointers (or just drop the frames or something).
I think it would be much better to just add the helper function that
checks the RA on STA lookup. Keeps things simple, especially since
nothing else in the tx path needs the vif.

- Felix
