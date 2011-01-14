Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56609 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1ANNXA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 08:23:00 -0500
Message-ID: <4D304E32.4040806@candelatech.com>
Date: Fri, 14 Jan 2011 05:22:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No beacons generated when you bring ath9k AP interface down and
 up.
References: <4D2FF7A4.3070106@candelatech.com> <20110114091226.GA32344@jm.kir.nu>
In-Reply-To: <20110114091226.GA32344@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2011 01:12 AM, Jouni Malinen wrote:
> On Thu, Jan 13, 2011 at 11:13:40PM -0800, Ben Greear wrote:
>> If you have an ath9k AP interface running with hostapd, and you
>> run:  ip link set vap0 down; ip link set vap0 up;
>> then it will disable beaconing.
>
> Yes. So what?
>
>> I'm not sure where the problem actually lies:  Should ath9k
>> start beaconing automatically on VAP interface add?  Is
>> it up to hostapd to detect the ifdown/ifup and re-set everything
>> up properly?  Or maybe it's just a very bad idea to bounce
>> a VAP interface with 'ip link set'?
>
> I would say it is up to whoever decided to set the interface down to
> restart hostapd.. There is a proposed patch for hostapd to do this
> automatically, but I'm yet to fully understand why one would set the
> interface down in the first place.

My tool automatically downs and ups interfaces when IPs configuration
changes to clear IP & routing information.  It's not so difficult to
restart hostapd or even not bounce the VAP to begin with.

But, it was quite difficult to figure out
that the VAP was just *mostly* working.  It seems that everything but
beaconing was working, or at least 70 or so virtual station devices
could associate and pass traffic, though they did complain about
not receiving beacons.

I think that we should either change hostapd to fix this up automatically,
or have hostapd exit on error when this happens, or have some other very
obvious clue that the VAP is not fully functional.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
