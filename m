Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f182.google.com ([209.85.160.182]:36076 "EHLO
	mail-gh0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023Ab3BUDeY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 22:34:24 -0500
Received: by mail-gh0-f182.google.com with SMTP id z15so1164044ghb.41
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 19:34:23 -0800 (PST)
Message-ID: <512595BC.5030607@lwfinger.net> (sfid-20130221_044703_910359_CA6AEDCE)
Date: Wed, 20 Feb 2013 21:34:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>  <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com>  <1361381489.3065.1.camel@joe-AO722> <51250E6B.3030308@lwfinger.net>  <1361384969.2219.4.camel@joe-AO722> <51252132.3050603@hauke-m.de> <1361391065.2223.5.camel@joe-AO722>
In-Reply-To: <1361391065.2223.5.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/20/2013 02:11 PM, Joe Perches wrote:
> On Wed, 2013-02-20 at 20:17 +0100, Hauke Mehrtens wrote:
>> On 02/20/2013 07:29 PM, Joe Perches wrote:
>>> On Wed, 2013-02-20 at 11:56 -0600, Larry Finger wrote:
>>>> On 02/20/2013 11:31 AM, Joe Perches wrote:
>>>>> On Mon, 2013-02-18 at 17:09 +0100, Rafał Miłecki wrote:
>>>>>> 2013/2/16 Hauke Mehrtens <hauke@hauke-m.de>:
>>>>>>> The mac address should be aligned to u16 to prevent an unaligned access
>>>>>>> in drivers/ssb/pci.c where it is casted to __be16.
>>>>> []
>>>>>>> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
>>>>> []
>>>>>>> @@ -26,6 +26,7 @@ struct ssb_sprom_core_pwr_info {
>>>>>>>
>>>>>>>    struct ssb_sprom {
>>>>>>>           u8 revision;
>>>>>>> +       u8 country_code;        /* Country Code */
>>>>>>>           u8 il0mac[6];           /* MAC address for 802.11b/g */
>>>>>>
>>>>>> It looks a little hacky to me too, it's easy to forget about that
>>>>>> requirement and break that again in the future.
>>>>>>
>>>>>> What about not casting il0mac to u16 at all? Maybe we should just fill
>>>>>> it as u8 (which it is)?
>>>>>>
>>>>>
>>>>> Perhaps this?
>>>>>
>>>>> From: Joe Perches <joe@perches.com>
>>>>> Subject: [PATCH] ssb: pci: Standardize a function to get mac address
>>>>>
>>>>> Don't require alignment of mac addresses to u16.
>>
>> ...
>>
>>>> I like the looks of sprom_get_mac() over that ugly *(((__be16 *)out->il0mac)
>>>> construct, but this patch breaks ssb. The resulting MAC address is all ones. I
>>>> have not yet figured out the problem.
>>>
>>> Dunno, I must have done something stupid.
>>>
>>> I don't have one of these but the transform
>>> looked correct when I did  it.
>>>
>>> I'm not sure it's the best solution anyway
>>> because some of the other ether address
>>> functions like compare_ether_addr also
>>> require 2 byte alignment and cast to u16.
>>
>> Your patch looks good (haven't tested it), but as you said we should
>> still align the mac addresses to u16 so functions like
>> compare_ether_addr work with them.
>>
>> There is also a v2 of my patch:
>> http://www.spinics.net/lists/linux-wireless/msg103628.html
>
> Seems OK to me, though I suggest using ETH_ALEN
> instead of 6.
>
> Maybe using both patches would be better still.
>
> And as long as I'm futzing with ssb, there's another
> logging cleanup to go with it.
>
> Here's a V2 with the missing SPOFF fixed.
>
> Subject: [PATCH 1/2] ssb: pci: Standardize a function to get mac address
> From: Joe Perches <joe@perches.com>
>
> Don't require alignment of mac addresses to u16.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>
> V2: Add missing SPOFF

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

>
>   drivers/ssb/pci.c | 44 ++++++++++++++++++--------------------------
>   1 file changed, 18 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
> index e9d9496..4ec0bdb 100644
> --- a/drivers/ssb/pci.c
> +++ b/drivers/ssb/pci.c
> @@ -231,6 +231,15 @@ static inline u8 ssb_crc8(u8 crc, u8 data)
>   	return t[crc ^ data];
>   }
>
> +static void sprom_get_mac(char *mac, const u16 *in)
> +{
> +	int i;
> +	for (i = 0; i < 3; i++) {
> +		*mac++ = in[i];
> +		*mac++ = in[i] >> 8;
> +	}
> +}
> +
>   static u8 ssb_sprom_crc(const u16 *sprom, u16 size)
>   {
>   	int word;
> @@ -341,8 +350,6 @@ static s8 r123_extract_antgain(u8 sprom_revision, const u16 *in,
>
>   static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
>   {
> -	int i;
> -	u16 v;
>   	u16 loc[3];
>
>   	if (out->revision == 3)			/* rev 3 moved MAC */
> @@ -352,19 +359,10 @@ static void sprom_extract_r123(struct ssb_sprom *out, const u16 *in)
>   		loc[1] = SSB_SPROM1_ET0MAC;
>   		loc[2] = SSB_SPROM1_ET1MAC;
>   	}
> -	for (i = 0; i < 3; i++) {
> -		v = in[SPOFF(loc[0]) + i];
> -		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
> -	}
> +	sprom_get_mac(out->il0mac, &in[SPOFF(loc[0])]);
>   	if (out->revision < 3) { 	/* only rev 1-2 have et0, et1 */
> -		for (i = 0; i < 3; i++) {
> -			v = in[SPOFF(loc[1]) + i];
> -			*(((__be16 *)out->et0mac) + i) = cpu_to_be16(v);
> -		}
> -		for (i = 0; i < 3; i++) {
> -			v = in[SPOFF(loc[2]) + i];
> -			*(((__be16 *)out->et1mac) + i) = cpu_to_be16(v);
> -		}
> +		sprom_get_mac(out->et0mac, &in[SPOFF(loc[1])]);
> +		sprom_get_mac(out->et1mac, &in[SPOFF(loc[2])]);
>   	}
>   	SPEX(et0phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET0A, 0);
>   	SPEX(et1phyaddr, SSB_SPROM1_ETHPHY, SSB_SPROM1_ETHPHY_ET1A,
> @@ -454,19 +452,15 @@ static void sprom_extract_r458(struct ssb_sprom *out, const u16 *in)
>
>   static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
>   {
> -	int i;
> -	u16 v;
>   	u16 il0mac_offset;
>
>   	if (out->revision == 4)
>   		il0mac_offset = SSB_SPROM4_IL0MAC;
>   	else
>   		il0mac_offset = SSB_SPROM5_IL0MAC;
> -	/* extract the MAC address */
> -	for (i = 0; i < 3; i++) {
> -		v = in[SPOFF(il0mac_offset) + i];
> -		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
> -	}
> +
> +	sprom_get_mac(out->il0mac, &in[SPOFF(il0mac_offset)]);
> +
>   	SPEX(et0phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET0A, 0);
>   	SPEX(et1phyaddr, SSB_SPROM4_ETHPHY, SSB_SPROM4_ETHPHY_ET1A,
>   	     SSB_SPROM4_ETHPHY_ET1A_SHIFT);
> @@ -530,7 +524,7 @@ static void sprom_extract_r45(struct ssb_sprom *out, const u16 *in)
>   static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
>   {
>   	int i;
> -	u16 v, o;
> +	u16 o;
>   	u16 pwr_info_offset[] = {
>   		SSB_SROM8_PWR_INFO_CORE0, SSB_SROM8_PWR_INFO_CORE1,
>   		SSB_SROM8_PWR_INFO_CORE2, SSB_SROM8_PWR_INFO_CORE3
> @@ -539,10 +533,8 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
>   			ARRAY_SIZE(out->core_pwr_info));
>
>   	/* extract the MAC address */
> -	for (i = 0; i < 3; i++) {
> -		v = in[SPOFF(SSB_SPROM8_IL0MAC) + i];
> -		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
> -	}
> +	sprom_get_mac(out->il0mac, &in[SPOFF(SSB_SPROM8_IL0MAC)]);
> +
>   	SPEX(board_rev, SSB_SPROM8_BOARDREV, 0xFFFF, 0);
>   	SPEX(alpha2[0], SSB_SPROM8_CCODE, 0xff00, 8);
>   	SPEX(alpha2[1], SSB_SPROM8_CCODE, 0x00ff, 0);
>

