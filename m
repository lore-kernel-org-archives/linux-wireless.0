Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:35472 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab0BAFQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 00:16:27 -0500
Message-ID: <4B6663A7.3070608@openwrt.org>
Date: Mon, 01 Feb 2010 06:16:23 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix PAE frame handling
References: <4B65F735.1020509@openwrt.org> <19302.24837.154697.822430@gargle.gargle.HOWL>
In-Reply-To: <19302.24837.154697.822430@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-02-01 6:05 AM, Sujith wrote:
> Felix Fietkau wrote:
>> ath9k's tx handling code contains a special case for PAE frames, which
>> looks like it was intended to be improving reliability by excluding
>> them from aggregates.
>> What it actually did is the opposite: By assigning a faulty sequence
>> number, yet still keeping it as a qos-frame, it caused bogus packet
>> reordering, which broke WPA rekeying.
>> The special case handling is completely unnecessary, so this patch
>> removes it.
> 
> Sending PAE frames as part of an aggregate broke crypto with several APs.
> Assigning the correct seq. number should work, no ?
> 
> Something like the patch below. Can you check if it fixes your issue ?
> Though, removing the seq. number mess in the driver would be great. :D
Works for me. Tested it with a really short rekey interval, and I'm
getting no packet loss or connection interruption.

- Felix
