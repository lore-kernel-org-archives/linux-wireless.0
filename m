Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43826 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966629AbbLPWOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 17:14:20 -0500
Message-ID: <5671E23A.1070502@candelatech.com> (sfid-20151216_231423_799572_E22E252A)
Date: Wed, 16 Dec 2015 14:14:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Adam R. Welle" <arwelle@cert.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
References: <5670DA9A.4010102@candelatech.com>			 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>		 <56716386.4070107@candelatech.com>	 <1450272308.8247.11.camel@sipsolutions.net>	 <567168AF.4060804@candelatech.com> <1450273362.8247.15.camel@sipsolutions.net> <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon>
In-Reply-To: <2DE9F46DD36D2A458CD6347950113F2535C1ED@marathon>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2015 09:30 AM, Adam R. Welle wrote:
>
>> Well, it was always rather awkward since it was the *second* address :)
>
> Could somebody provide background information on why the decision was
> made to use a second address for the netlink frames instead of the same
> address as was used for the non-netlink frames?

I would be fine with always using the first address instead of the second,
in case that helps someone.

We could also set the address at creation time easily enough.  Then it
could still be unique across many machines if you managed it.

Thanks,
Ben

>
> I too have an obscure user-space app which uses this API :)
>
> My app was written to account for both the old and new logic being debated,
> so I can cope either way with the flip of a switch. I would just like to
> say that for my purposes the patch worked better as I already intended for
> my app to track MAC address changes made by a user.
>
> I should note that I am passing these frames between virtual machines so
> the use of unique addresses (instead of hard-coded 0x42 addresses) as a key
> simplifies things when determining which radio transmitted a given frame
> and which radio needs to receive the frame. My app has always relied on the
> MAC address assigned by the user as a unique key across virtual machines.
> Also, I will point out that I am not using multiple vifs on a radio but if
> I were, I imagine that I would send a copy of the frame to each vif.
>
> Adam
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

