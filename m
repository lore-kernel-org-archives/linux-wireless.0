Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49645 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1ANORP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 09:17:15 -0500
Received: by qyj19 with SMTP id 19so6858180qyj.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 06:17:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D304E32.4040806@candelatech.com>
References: <4D2FF7A4.3070106@candelatech.com>
	<20110114091226.GA32344@jm.kir.nu>
	<4D304E32.4040806@candelatech.com>
Date: Fri, 14 Jan 2011 09:17:14 -0500
Message-ID: <AANLkTinro071OC2oijAeknxGNKYsQmKtTaDtUyJap1hT@mail.gmail.com>
Subject: Re: No beacons generated when you bring ath9k AP interface down and up.
From: Brian Prodoehl <bprodoehl@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 14, 2011 at 8:22 AM, Ben Greear <greearb@candelatech.com> wrote:
> On 01/14/2011 01:12 AM, Jouni Malinen wrote:
>>
>> On Thu, Jan 13, 2011 at 11:13:40PM -0800, Ben Greear wrote:
>>>
>>> If you have an ath9k AP interface running with hostapd, and you
>>> run:  ip link set vap0 down; ip link set vap0 up;
>>> then it will disable beaconing.
>>
>> Yes. So what?
>>
>>> I'm not sure where the problem actually lies:  Should ath9k
>>> start beaconing automatically on VAP interface add?  Is
>>> it up to hostapd to detect the ifdown/ifup and re-set everything
>>> up properly?  Or maybe it's just a very bad idea to bounce
>>> a VAP interface with 'ip link set'?
>>
>> I would say it is up to whoever decided to set the interface down to
>> restart hostapd.. There is a proposed patch for hostapd to do this
>> automatically, but I'm yet to fully understand why one would set the
>> interface down in the first place.
>
> My tool automatically downs and ups interfaces when IPs configuration
> changes to clear IP & routing information.  It's not so difficult to
> restart hostapd or even not bounce the VAP to begin with.
>
> But, it was quite difficult to figure out
> that the VAP was just *mostly* working.  It seems that everything but
> beaconing was working, or at least 70 or so virtual station devices
> could associate and pass traffic, though they did complain about
> not receiving beacons.
>
> I think that we should either change hostapd to fix this up automatically,
> or have hostapd exit on error when this happens, or have some other very
> obvious clue that the VAP is not fully functional.
>
> Thanks,
> Ben

OpenWrt brings the AP interface down after launching hostapd to set
the MAC address every time during network restart, and beaconing
becomes disabled then, too.  I created this ticket 6 weeks ago:
https://dev.openwrt.org/ticket/8362

My conclusion was that bringing the interface down with hostapd up is
a terrible thing to do.  Some sort of fix beyond "don't do that" would
be really nice, though.  It would be great if hostapd would detect
that the interface went down, and reinitialize when the interface
comes back up.
