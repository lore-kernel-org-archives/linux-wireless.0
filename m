Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37716 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbcAZGfr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 01:35:47 -0500
Received: by mail-wm0-f50.google.com with SMTP id n5so113862538wmn.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2016 22:35:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A66298.1000607@candelatech.com>
References: <1453382588-27105-1-git-send-email-michal.kazior@tieto.com>
	<56A66298.1000607@candelatech.com>
Date: Tue, 26 Jan 2016 07:35:45 +0100
Message-ID: <CA+BoTQmha9HveqrKE9qLKLHu8vWfv+V=Sbkd7rhWyk7ALoJOmg@mail.gmail.com> (sfid-20160126_073550_352982_501E73E6)
Subject: Re: [PATCH 1/2] mac80211: fix txq queue related crashes
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 January 2016 at 18:59, Ben Greear <greearb@candelatech.com> wrote:
> On 01/21/2016 05:23 AM, Michal Kazior wrote:
>>
>> The driver can access the queue simultanously
>> while mac80211 tears down the interface. Without
>> spinlock protection this could lead to corrupting
>> sk_buff_head and subsequently to an invalid
>> pointer dereference.
>
> Hard to know for certain, but this *appears* to fix the unexpectedly large
> amount of CE/AXI ath10k firmware crashes that we saw in the 4.2 kernel (4.0
> previously
> ran much better han 4.2 for us).

That's impossible.

Without wake_tx_queue() txqs aren't even allocated (sdata->vif.txq is NULL).


Michał
