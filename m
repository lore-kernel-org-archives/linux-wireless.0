Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail0.scram.de ([78.47.204.202]:42878 "EHLO mail.scram.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab0AYWQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 17:16:15 -0500
Message-ID: <4B5E1827.4040902@scram.de>
Date: Mon, 25 Jan 2010 23:16:07 +0100
From: Jochen Friedrich <jochen@scram.de>
MIME-Version: 1.0
To: Fabio Rossi <rossi.f@inwind.it>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] mac80211: fix sw crypto
References: <1264415776.23766.34.camel@johannes.local> <201001252309.48260.rossi.f@inwind.it>
In-Reply-To: <201001252309.48260.rossi.f@inwind.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabio Rossi wrote:
> On Monday 25 January 2010 11:36:16 Johannes Berg wrote:
> 
>> What a stupid mistake. In
>>
>>     commit 813d76694043d00b59475baa1fbfaf54a2eb7fad
>>     Author: Johannes Berg <johannes@sipsolutions.net>
>>     Date:   Sun Jan 17 01:47:58 2010 +0100
>>
>>         mac80211: move control.hw_key assignment
>>
>> I inserted code testing the wrong flags field,
>> which means that the test is almost always true
>> (it's really testing for the peer's WMM support)
>> and thus the later parts of the stack assume hw
>> crypto will be done even if that's not true.
>>
>> Obviously, that broke software crypto. Maxim
>> said so specifically, and Jochen probably uses
>> some cipher that iwl3945 doesn't support in
>> hardware, which might also explain that Maxim
>> reports that even hw crypto is broken.
>>
>> Fix this to test the right flags field.
>>
> 
> Tested-by: Fabio Rossi <rossi.f@inwind.it>

Tested-by: Jochen Friedrich <jochen@scram.de>

Thanks,
Jochen
