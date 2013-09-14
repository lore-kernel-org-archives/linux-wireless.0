Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:47759 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334Ab3INU0G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Sep 2013 16:26:06 -0400
Message-ID: <5234C659.9080307@lwfinger.net> (sfid-20130914_222612_553490_C1653B70)
Date: Sat, 14 Sep 2013 15:26:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 6/7] rtlwifi: Fix smatch warnings in usb.c
References: <1379094304-22041-1-git-send-email-Larry.Finger@lwfinger.net> <1379094304-22041-7-git-send-email-Larry.Finger@lwfinger.net> <5234BCB6.6050508@cogentembedded.com>
In-Reply-To: <5234BCB6.6050508@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2013 02:44 PM, Sergei Shtylyov wrote:
> Hello.
>
> On 09/13/2013 09:45 PM, Larry Finger wrote:
>
>> Smatch displays the following:
>>    CHECK   drivers/net/wireless/rtlwifi/usb.c
>> drivers/net/wireless/rtlwifi/usb.c:458 _rtl_usb_rx_process_agg() warn:
>> assigning (-98) to unsigned variable 'stats.noise'
>> drivers/net/wireless/rtlwifi/usb.c:503 _rtl_usb_rx_process_noagg() warn:
>> assigning (-98) to unsigned variable 'stats.noise'
>> drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring
>> unreachable code.
>> drivers/net/wireless/rtlwifi/usb.c:596 _rtl_rx_get_padding() info: ignoring
>> unreachable code.
>
>> The negative number to an unsigned quantity is fixed by adding 256 to -98
>> to get the equivalent negative number.
>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>   drivers/net/wireless/rtlwifi/usb.c | 10 +++++++---
>>   1 file changed, 7 insertions(+), 3 deletions(-)
>
>> diff --git a/drivers/net/wireless/rtlwifi/usb.c
>> b/drivers/net/wireless/rtlwifi/usb.c
>> index e56778c..9f3dcb8 100644
>> --- a/drivers/net/wireless/rtlwifi/usb.c
>> +++ b/drivers/net/wireless/rtlwifi/usb.c
> [...]
>> @@ -582,12 +582,15 @@ static void _rtl_rx_work(unsigned long param)
>>   static unsigned int _rtl_rx_get_padding(struct ieee80211_hdr *hdr,
>>                       unsigned int len)
>>   {
>> +#if NET_IP_ALIGN != 0
>>       unsigned int padding = 0;
>> +#endif
>>
>>       /* make function no-op when possible */
>> -    if (NET_IP_ALIGN == 0 || len < sizeof(*hdr))
>> +    if (NET_IP_ALIGN == 0 || len < sizeof(struct ieee80211_hdr))
>
>     Why this collateral and undocumented change? What does it achieve?
>
>>           return 0;

It does not change a thing. Further up the code is "struct ieee80211_hdr *hdr". 
This change was one I tried during the fixes, and I forgot to remove it.

Larry

