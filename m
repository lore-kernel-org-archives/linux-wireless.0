Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.dnainternet.fi ([87.94.96.72]:4565 "EHLO
	smtp4.dnainternet.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbZEWG5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 May 2009 02:57:05 -0400
Message-ID: <20090523095659.148960arcvdbb20w@hayate.sektori.org>
Date: Sat, 23 May 2009 09:56:59 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Dan Williams" <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/4] rndis_wlan: explain bits used in key setup code.
References: <20090522144012.8134.27669.stgit@fate.lan>
	<20090522144020.8134.76073.stgit@fate.lan>
	<1243004755.2461.10.camel@localhost.localdomain>
In-Reply-To: <1243004755.2461.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Dan Williams" <dcbw@redhat.com>:

> On Fri, 2009-05-22 at 17:40 +0300, Jussi Kivilinna wrote:
>> Driver uses some unnamed bits to control encryption setup. Move these to
>> enumerations with proper names explaining their meaning.
>>
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>> ---
>>
>>  drivers/net/wireless/rndis_wlan.c |   23 ++++++++++++++++++-----
>>  1 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rndis_wlan.c  
>> b/drivers/net/wireless/rndis_wlan.c
>> index f9b0a35..8609d28 100644
>> --- a/drivers/net/wireless/rndis_wlan.c
>> +++ b/drivers/net/wireless/rndis_wlan.c
>> @@ -196,6 +196,18 @@ enum ndis_80211_priv_filter {
>>  	ndis_80211_priv_8021x_wep
>>  };
>>
>> +enum ndis_80211_addkey_bits {
>> +	ndis_80211_addkey_8021x_auth = cpu_to_le32(1 << 28),
>> +	ndis_80211_addkey_set_init_recv_seq = cpu_to_le32(1 << 29),
>> +	ndis_80211_addkey_pairwise_key = cpu_to_le32(1 << 30),
>> +	ndis_80211_addkey_transmit_key = cpu_to_le32(1 << 31),
>> +};
>
> Enums and defines are usually capitalized in Linux, ie
> NDIS_80211_ADDKEY_8021X_AUTH, so that they can be separated from
> non-constant stuff and from function names.  Makes the code more
> readable.  Any chance you'd mind doing that in this patch since you're
> touching these bits?
>
> Dan

All the ndis_80211_* enums in rndis_wlan.c are lower case now, so I'd  
keep it consistent here and change all the enums upper case in  
separate patch.

-Jussi

