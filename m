Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:38166 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751975AbXCQWFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 18:05:06 -0400
Message-ID: <45FC660E.1090402@warmcat.com>
Date: Sat, 17 Mar 2007 22:05:02 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070317105800.659633351@warmcat.com> <20070317110751.352850972@warmcat.com> <200703171730.33349.flamingice@sourmilk.net>
In-Reply-To: <200703171730.33349.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Saturday 17 March 2007 06:58, andy@warmcat.com wrote:
>> diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
>> index fb33b90..3873262 100644
>> --- a/net/mac80211/ieee80211.c
>> +++ b/net/mac80211/ieee80211.c
>> @@ -35,6 +35,7 @@
>>  #include "ieee80211_led.h"
>>  #include "ieee80211_cfg.h"
>>  #include "ieee80211_sysfs.h"
>> +#include <net/ieee80211_radiotap.h>
>>
> Already included by my patch.

OK.  Not sure why that appears in my patch any longer then since I am 
using guilt thanks to your advice, and your patch is applied first.

>> +	int tap_index = 0;
>> +	u8 *tap_arg = skb->data + sizeof(struct ieee80211_radiotap_header);
>> +	u32 *curr_arg_bitmap = &rthdr->it_present;
>> +	u32 arg_bitmap=le32_to_cpu(*curr_arg_bitmap);
> Space before and after the =. 

Fixed.

>> +
>> +	if(rthdr->it_version) return TXRX_DROP; /* version byte used as magic */
> Space after the if.

Fixed.

>> +
>> +		/* sanity check for skb length and radiotap length field */
> Keep comments indented the same as everything else.

Fixed.

>> +	if (skb->len < (le16_to_cpu(rthdr->it_len) +
>> +		sizeof(struct ieee80211_hdr)))
> Using some spaces to align the start of the second line with the parenthesis 
> often looks better.

Fixed and noted.

>> +		/* process and remove the injection radiotap header */
>> +
>> +	if(control->flags & IEEE80211_TXCTL_INJECTED_PACKET) {
> dev points to the virtual interface that the frame originally came in on. You 
> can get sdata from that and figure out if the interface was a monitor 
> interface.

replied in next mail...

-Andy
