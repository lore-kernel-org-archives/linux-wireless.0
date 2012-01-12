Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42452 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2ALBLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 20:11:13 -0500
Received: by iabz25 with SMTP id z25so1885850iab.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jan 2012 17:11:13 -0800 (PST)
Message-ID: <4F0E332D.1060409@lwfinger.net> (sfid-20120112_021117_383327_D5888850)
Date: Wed, 11 Jan 2012 19:11:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rtlwifi: Move RX/TX macros into common file
References: <1326323232-21752-1-git-send-email-Larry.Finger@lwfinger.net>  <1326323232-21752-2-git-send-email-Larry.Finger@lwfinger.net> <1326328047.7886.21.camel@joe2Laptop>
In-Reply-To: <1326328047.7886.21.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/11/2012 06:27 PM, Joe Perches wrote:
> On Wed, 2012-01-11 at 17:07 -0600, Larry Finger wrote:
>> Each of the 4 drivers that use rtlwifi maintains its own set of macros
>> that get and set the various fields in the RX and TX descriptors. To
>> reduce the size of the source, and to help maintainability, these
>> macros are combined into a single file. In addition, any macro that is
>> defined, but not used, is deleted.
> []
>> diff --git a/drivers/net/wireless/rtlwifi/macros.h b/drivers/net/wireless/rtlwifi/macros.h
> []
>> +++ b/drivers/net/wireless/rtlwifi/macros.h
> []
>> +#ifndef __RTLWIFI_MAC_H__
>> +#define __RTLWIFI_MAC_H__
>
> That's an odd name guard for this file.
> There is a rtlwifi/rtl8192cu/mac.h file.
>
> RTIWIFI_MACROS_H might be more appropriate.

That is a good suggestion.

>> +
>> +/* Define a macro that takes a le32 word, converts it to host ordering,
>> + * right shifts by a specified count, creates a mask of the specified
>> + * bit count, and extracts that number of bits.
>> + */
>> +
>> +#define SHIFT_AND_MASK_LE(__pdesc, __shift, __mask)		\
>> +	((le32_to_cpu(*(((__le32 *)(__pdesc))))>>  (__shift))&	\
>> +	BIT_LEN_MASK_32(__mask))
>
> This macro depends on wifi.h so why not just put
> all of these in wifi.h?

I felt that wifi.h was already large enough. For that reason, I selected a new file.

> And instead of a #define, perhaps
>
> static inline u32 le32p_to_cpu_shift_and_mask(__le32 *desc, int shift, u32 mask)
> {
> 	return (le32_to_cpu(*desc)>>  shift)&  BIT_LEN_MASK_32(mask);
> }

I need to think about this one some more.

>> +#define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)		\
>> +do {								\
>> +	if (_size>  TX_DESC_NEXT_DESC_OFFSET)			\
>> +		memset(__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
>> +	else							\
>> +		memset(__pdesc, 0, _size);			\
>> +} while (0)
>
> Perhaps
> 	memset(__pdesc, 0, min(size, TX_DESC_NEXT_DESC_OFFSET))
>

That is a good idea.

>> +
>> +/* macros to read/write various fields in RX or TX descriptors
>> + *
>> + * The organization is as follows:
>> + * 1. Macros that operate on the same dword are placed together.
>> + * 2. The macros for rtl8192ce are first. Most of these are also
>> + *    used for rtl8192de, but the register layout is different
>> + *    for rtl8192cu and rtl8192se.
>> + * 3. Special macros for other drivers will be given an _CU, _SE,
>> + *    and _DE suffix, and listed following those for rtl8192ce.
>> + */
>
> I don't see how centralizing these non-shared
> macro names helps.
>
> Maybe if the code is actually common, have a
> separate #include for each card with common
> named #defines as appropriate.

The idea of centralizing the non-shared names was to have all these macros in 
one place. If any need to be changes, that one file will have all of them.

Larry
