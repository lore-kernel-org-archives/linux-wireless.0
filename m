Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33888 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaI3Roz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Sep 2014 13:44:55 -0400
Message-ID: <542AEC16.5050003@candelatech.com> (sfid-20140930_194458_901923_662B237C)
Date: Tue, 30 Sep 2014 10:44:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Anyone working on making iw able to specify MAC address at station
 creation time?
References: <5408A6BD.6090304@candelatech.com>  (sfid-20140904_195201_728073_99DA3C67) <1409898836.1940.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1409898836.1940.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/04/2014 11:33 PM, Johannes Berg wrote:
> On Thu, 2014-09-04 at 10:51 -0700, Ben Greear wrote:
>> I'm having issues with udev renaming newly created stations when I have
>> udev rules for wlanX, when wlanX is not already existing.
>>
>> I think specifying MAC on station creation time would solve my problems,
>> but haven't looked closely yet.
>>
>> My version of 'iw' doesn't support setting the MAC on creation, from
>> what I can tel.
>>
>> Curious if anyone else is working on this?
> 
> I think Marcel mentioned wanting this before. There's even an attribute
> in nl80211 already, but it can only be used for P2P_DEVICE I believe, so
> a feature flag or so would be needed to be able to know whether or not
> this would be expected to take any effect (kernels before those future
> changes would ignore the attribute for non-P2P-DEVICE I believe)

>From what I can tell, cfg80211 does parse the macaddr for p2p-device,
but I don't see it used in mac80211/iface.c ieee80211_if_add.

Am I missing something?

Thanks,
Ben

> 
> Haven't looked at the code right now, this is all I know.
> 
> johannes
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

