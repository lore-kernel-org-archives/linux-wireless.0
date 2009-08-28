Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:42813 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbZH1JCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 05:02:39 -0400
Message-ID: <4A979D06.2000205@nokia.com>
Date: Fri, 28 Aug 2009 12:01:58 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Oikarinen Juuso (Nokia-D-MSW/Tampere)" <juuso.oikarinen@nokia.com>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>
Subject: Re: [PATCH 13/13] wl1271: added Juuso Oikarinen as module author
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>	 <1251406807-31495-14-git-send-email-luciano.coelho@nokia.com> <1251408741.22482.14.camel@johannes.local>
In-Reply-To: <1251408741.22482.14.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Johannes Berg wrote:
> On Fri, 2009-08-28 at 00:00 +0300, Luciano Coelho wrote:
>   
>> Add Juuso as one of the module authors, since he's working heavily on this
>> module as well.
>>
>> Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
>> ---
>>  drivers/net/wireless/wl12xx/wl1271_main.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
>> index a97d434..4163eac 100644
>> --- a/drivers/net/wireless/wl12xx/wl1271_main.c
>> +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
>> @@ -1449,4 +1449,5 @@ module_init(wl1271_init);
>>  module_exit(wl1271_exit);
>>  
>>  MODULE_LICENSE("GPL");
>> -MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>");
>> +MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com>, "
>> +	      "Juuso Oikarinen <juuso.oikarinen@nokia.com>");
>>     
>
> Use multiple MODULE_AUTHORs instead.
>   

Is that the right way to do it? At least in include/linux/module.h it 
says this:

/* Author, ideally of form NAME[, NAME]*[ and NAME] */
#define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

As I interpret it, it means that there should be one MODULE_AUTHOR with 
a string that contains all the names.  So actually the right way to do 
it would be this:

MODULE_AUTHOR("Luciano Coelho <luciano.coelho@nokia.com> and "
	      "Juuso Oikarinen <juuso.oikarinen@nokia.com>");


Or am I missing/misinterpreting something?

-- 
Cheers,
Luca.

