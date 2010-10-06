Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:50950 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0JFStb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:49:31 -0400
Message-ID: <4CACC4B8.7040500@candelatech.com>
Date: Wed, 06 Oct 2010 11:49:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Any /n NICs that support APs and multiple STAs other than ath9k?
References: <4CACA3D7.90108@candelatech.com> <AANLkTimB7=odPK3qTAhFBdzaMFFGVar0kyMrb-p9SgYy@mail.gmail.com>
In-Reply-To: <AANLkTimB7=odPK3qTAhFBdzaMFFGVar0kyMrb-p9SgYy@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2010 11:45 AM, Luis R. Rodriguez wrote:
> On Wed, Oct 6, 2010 at 9:29 AM, Ben Greear<greearb@candelatech.com>  wrote:
>> I would like to have a different hardware/driver combination to try
>> to tie-break whether bugs are in mac80211 or in the ath9k driver/hardware.
>>
>> I don't mind doing a bit of driver hacking so long as the basic support
>> is there (I think it's mostly the ability to set a BSSID mask and rxfilter
>> accordingly).
>
> Your best bet is to test against mac80211_hwsim, that would rule out
> any hardware. I think Jouni and Johannes have also a way to get the
> devices to talk to each other. Perhaps some documentation of that on
> the kernel Documentation/networking/mac80211_hwsim/

Ok.  I'm trying to hack slub to give me a better stack trace of where
the skb was deleted.  If that doesn't turn up anything obvious, then
I'll go read up on hwsim.

Are you aware of any DMA issues that might cause ath9k to write into
places it should not?  Previously, I've seen a lot of errors in
the logs about ath9k not being able to stop DMA in time, but I haven't
seen those while reproducing the memory corruption.


Thanks,
Ben

>
>    Luis


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

