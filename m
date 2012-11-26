Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:46943 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204Ab2KZMXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:23:55 -0500
Message-ID: <50B35E31.3080507@neratec.com> (sfid-20121126_132411_569777_525FD109)
Date: Mon, 26 Nov 2012 13:18:57 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/1] ath9k: Add radiotap vendor specific data example
References: <1353667565-4212-1-git-send-email-Wojciech.Dubowik@neratec.com>  (sfid-20121123_115242_843402_5FE9C369) <1353764695.9789.4.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353764695.9789.4.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2012 02:44 PM, Johannes Berg wrote:
> On Fri, 2012-11-23 at 11:46 +0100, Wojciech Dubowik wrote:
>
>> +			rxs->vendor_radiotap_bitmap = 0x00000001;
> I would recommend adding multiple fields so that it's extensible in the
> future or some things can be left out:
>
> field 0 (0x1):
> 	4 x u8, alignment 1 - RSSI data
> field 1 (0x2):
> 	4 x u32 + 1 x u16, alignment ? - evm data
I will try to add fields which could be switched on/off through sysfs
with bitmask.

Wojtek
>
>
> Also:
> Ness, STBC are going to be standardised.
> noise floor is already standardised I think
>
> johannes
>

