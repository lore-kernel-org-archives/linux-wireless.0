Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45591 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab0LFUWd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 15:22:33 -0500
Message-ID: <4CFD4602.1030304@candelatech.com>
Date: Mon, 06 Dec 2010 12:22:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
References: <4CF44543.9070605@candelatech.com>	<20101130004424.GC1901@tux>	<4CF6D8C8.2000308@candelatech.com>	<4CF8A6DE.4020804@candelatech.com>	<4CFAFBE1.3080505@openwrt.org>	<4CFB20BA.5090300@candelatech.com>	<20101206193600.GC21442@tux>	<4CFD3DE3.4000207@candelatech.com> <AANLkTingy7fPH14hW_mg8_YcotX29pYCu910Gw48grrD@mail.gmail.com>
In-Reply-To: <AANLkTingy7fPH14hW_mg8_YcotX29pYCu910Gw48grrD@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2010 12:11 PM, Björn Smedman wrote:
> On Mon, Dec 6, 2010 at 8:47 PM, Ben Greear<greearb@candelatech.com>  wrote:
>> With 16 properly configured non-encrypted stations, running with
>> wpa-supplicant
>> with netlink driver&  sharing scan results,  the interfaces quickly
>> associate.
>>
>> However, I do continue to see DMA warnings such as these (I had picked up my
>> portable phone, and it knocked all the interfaces offline ..here
>> they are coming back up after I hung up the phone).
>
> Is there some theory as to why using multiple interfaces cause so many
> problems with DMA?

Seems pretty directly related to channel changes and/or resets, and exacerbated
by other interfaces sending data while another is scanning, for instance.

Other issues we've found in the past have been various races that you wouldn't
normally see with a single VIF.

Thanks,
Ben

>
> /Björn


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
