Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30170 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbZGCFRL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2009 01:17:11 -0400
Message-ID: <4A4D9404.9030103@nokia.com>
Date: Fri, 03 Jul 2009 08:15:48 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: ext Felix Fietkau <nbd@openwrt.org>
CC: "linville@tuxdriver.org" <linville@tuxdriver.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"Valo Kalle (Nokia-D/Tampere)" <Kalle.Valo@nokia.com>,
	"Govindan Vidhya (Nokia-D/Tampere)" <vidhya.govindan@nokia.com>
Subject: Re: [PATCH] mac80211: minstrel: avoid accessing negative indices
 in rix_to_ndx()
References: <1246571549-29014-1-git-send-email-luciano.coelho@nokia.com> <4A4D4DC6.30502@openwrt.org>
In-Reply-To: <4A4D4DC6.30502@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Felix Fietkau wrote:
> Luciano Coelho wrote:
>   
>> If rix is not found in mi->r[], i will become -1 after the loop.  This value
>> is eventually used to access arrays, so we were accessing arrays with a
>> negative index, which is obviously not what we want to do.  This patch fixes
>> this potential problem.
>>
>> Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
>> ---
>>  net/mac80211/rc80211_minstrel.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_minstrel.c
>> index b218b98..e2dd248 100644
>> --- a/net/mac80211/rc80211_minstrel.c
>> +++ b/net/mac80211/rc80211_minstrel.c
>> @@ -66,7 +66,7 @@ rix_to_ndx(struct minstrel_sta_info *mi, int rix)
>>  	for (i = rix; i >= 0; i--)
>>  		if (mi->r[i].rix == rix)
>>  			break;
>> -	WARN_ON(mi->r[i].rix != rix);
>> +	WARN_ON(i < 0 || mi->r[i].rix != rix);
>>     
> I believe this line could be changed to WARN_ON(i < 0), because
> (mi->r[i].rix != rix) will never be true unless i < 0.
> Probably not that important though.
>   

That's true.  I'll change the code and send v2.  It's not that 
important, but it is code that will never be reached, so it should be 
removed.

> Acked-by: Felix Fietkau <nbd@openwrt.org>
>   

Thanks!

-- 
Cheers,
Luca.

