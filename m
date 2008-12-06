Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:43922 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbYLFUqP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 15:46:15 -0500
Received: by yw-out-2324.google.com with SMTP id 9so242812ywe.1
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 12:46:13 -0800 (PST)
Message-ID: <43e72e890812061246n1d63c306x942759674cf0b26a@mail.gmail.com> (sfid-20081206_214619_591813_CF060215)
Date: Sat, 6 Dec 2008 12:46:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Cc: "Henning Rogge" <hrogge@googlemail.com>,
	"Henning Rogge" <rogge@fgan.de>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Marcel Holtmann" <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"nbd@openwrt.org" <nbd@openwrt.org>
In-Reply-To: <1228579172.16752.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200811252131.30161.hrogge@googlemail.com>
	 <1228575081.16752.8.camel@johannes.berg>
	 <200812061603.21930.hrogge@googlemail.com>
	 <200812061646.36044.hrogge@googlemail.com>
	 <1228579172.16752.21.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 6, 2008 at 7:59 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2008-12-06 at 16:46 +0100, Henning Rogge wrote:
>> On Saturday 06 December 2008 16:03:16 Henning Rogge wrote:
>> > > I'd rename _TOTAL to _LEGACY and remove the calculation for MCS rates,
>> > > that way it's obviously clear what you're getting in userland.
>> Okay, after reading your mail a second time I understood you...
>>
>> I think with removing the total bitrate for 802.11n we will just make the
>> userspace interface more complex. You will have to look at four different
>> things (flags, MCS, guard interval, legacy) just to get the bitrate, which
>> will be the typical information the user wants to know. Is there anything
>> nl80211 will gain if we don't put this value inside for all 802.11 ? We cannot
>> drop it because of 802.11abg, so why not fill it with useful data ?
>
> For one, I'm a bit concerned that the calculation is fairly complex, and
> may not always be necessary; especially divisions can be expensive on
> some CPUs.
>
> Also, there are duplicate numbers possible, so just the pure bitrate
> will _not_ actually be "the typical information" because it's not
> specific enough, when debugging, for example, you will probably need to
> know whether it's short-gi or not.

Aren't we providing that *as well*?

  Luis
