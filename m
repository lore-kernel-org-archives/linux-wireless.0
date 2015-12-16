Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:44513 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbbLPXUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 18:20:20 -0500
Message-ID: <5671F1B2.2010503@candelatech.com> (sfid-20151217_002026_922423_5234C182)
Date: Wed, 16 Dec 2015 15:20:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Adam R. Welle" <arwelle@cert.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com>			 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>		 <56716386.4070107@candelatech.com>	 <1450272308.8247.11.camel@sipsolutions.net>	 <567168AF.4060804@candelatech.com> <1450273362.8247.15.camel@sipsolutions.net> <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon> <5671E23A.1070502@candelatech.com> <2DE9F46DD36D2A458CD6347950113F2535CA6D@marathon>
In-Reply-To: <2DE9F46DD36D2A458CD6347950113F2535CA6D@marathon>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 02:56 PM, Adam R. Welle wrote:
>>> Could somebody provide background information on why the decision was
>>> made to use a second address for the netlink frames instead of the
>>> same address as was used for the non-netlink frames?
>>
>> I would be fine with always using the first address instead of the
>> second, in case that helps someone.
>>
>> We could also set the address at creation time easily enough.  Then it
>> could still be unique across many machines if you managed it.
>
> I actually apply a patch for that. I have added a module parameter which
> is used as the MAC address for the first radio, and I increment the final
> octet for each additional radio. This is so that my users do not have
> to manually reset the MAC address to get a unique one. I apply the address
> to both addresses mentioned above though I only use the netlink datapath.
>
> If there is interest in this I can submit it as an RFC patch tomorrow.

I'd rather see support for specifying an arbitrary MAC upon creation
with a netlink attribute than a module parameter...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

