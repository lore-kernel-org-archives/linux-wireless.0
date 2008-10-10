Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:37599 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753352AbYJJAjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 20:39:16 -0400
Message-ID: <48EEA432.7000605@lwfinger.net> (sfid-20081010_023918_860720_113EF957)
Date: Thu, 09 Oct 2008 17:39:14 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
References: <48EE20FB.4060700@lwfinger.net> <200810091858.17451.chunkeey@web.de>
In-Reply-To: <200810091858.17451.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 09 October 2008 17:19:23 Larry Finger wrote:
>> Index: wireless-testing/drivers/net/wireless/p54/p54common.h
>> ===================================================================
>> --- wireless-testing.orig/drivers/net/wireless/p54/p54common.h
>> +++ wireless-testing/drivers/net/wireless/p54/p54common.h
>> @@ -18,7 +18,10 @@
>>  struct bootrec {
>>  	__le32 code;
>>  	__le32 len;
>> -	u32 data[10];
>> +	union {
>> +		u32 data[10];
>> +		u8 data_char[40];
>> +	} __attribute__((packed));
>>  	__le16 rx_mtu;
>>  } __attribute__((packed));
>>
> ? how did rx_mtu end up there? it should be a part of bootrec_desc
> (which is a few lines down in p54common.h)
> struct bootrec_desc {
>         __le16 modes;
>         __le16 flags;
>         __le32 rx_start;
>         __le32 rx_end;
>         u8 headroom;
>         u8 tailroom;
>         u8 unimportant[6];
>         u8 rates[16];
> +	__le16 rx_mtu;
> } __attribute__((packed));
> 
> This structure is equivalent to struct s_lm_descr from "lmac_longbow.h", which
> can be found on wireless.kernel.org's resource page.

As the original code got the data from bootrec, I kept it the same. On
reflection, the statement above could be

priv->rx_mtu = le16_to_cpu(desc->rx_mtu);

I think which structure it is in is purely a matter of taste, but I will make
that change, test it, and submit a new patch. The big-endian fix above will also
need to be changed. I considered converting to a single struct using unions, but
that would get pretty messy.

Larry



