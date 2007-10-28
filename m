Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:22618 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbXJ1LMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Oct 2007 07:12:44 -0400
Received: by mu-out-0910.google.com with SMTP id i10so2253108mue
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2007 04:12:42 -0700 (PDT)
Message-ID: <47246EA5.2040702@gmail.com> (sfid-20071028_111249_665167_B09BCBD0)
Date: Sun, 28 Oct 2007 12:12:37 +0100
From: dragoran <drago01@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: Change error message for failed rc module
References: <4a55afb80710271456k6c3bbfeah879b67a91a3b8d41@mail.gmail.com>	 <200710280034.41942.mb@bu3sch.de>	 (sfid-20071027_233701_549220_BD0E4B1B) <1193568021.3966.15.camel@johannes.berg>	 <47246844.6020109@gmail.com> (sfid-20071028_104530_132972_8BA4B064) <1193568627.3966.27.camel@johannes.berg>
In-Reply-To: <1193568627.3966.27.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>   
>> won't this conflict with drivers that want to use their own rate scaling 
>> modules? (like iwl3945/4965)
>>     
>
> The rate control algorithm should be per-hw struct. We still don't have
> the "driver preference" patch applied because of some things, but in any
> case it is possible to have an algorithm for each hw.
>
>   
ok
> Besides, currently, afaict, if you first load rc80211_simple and then
> iwlwifi, the latter doesn't really work well if at all due to simple
> being used. That needs to be fixed anyway, the right solution is that
> patch we were discussing a long time ago with driver preference for rate
> control algorithm (though ISTR there were still some issues with it and
> I don't remember whether the initial version was applied)
>
>   
seems not I was unable to find it in git but I found the thread about it it:
http://marc.info/?t=118801173400003&r=1&w=2
seems you had some concerns that have not been adressed yet.
