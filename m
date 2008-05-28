Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.187]:46121 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYE1SJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 14:09:35 -0400
Received: by rn-out-0910.google.com with SMTP id k40so1707685rnd.17
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 11:09:32 -0700 (PDT)
Message-ID: <1ba2fa240805281109m217b3d66t1b023ea43cb82ee6@mail.gmail.com> (sfid-20080528_200938_869061_BA1B9ACC)
Date: Wed, 28 May 2008 21:09:31 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>
Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ron.rindjunsky@intel.com" <ron.rindjunsky@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C483351723448@CHEXMB-01.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080528145048.GB5244@senthil-lnx.users.atheros.com>
	 <20080528151651.GA13461@tuxdriver.com>
	 <44EE5C37ADC36343B0625A05DD408C483351723447@CHEXMB-01.global.atheros.com>
	 <1ba2fa240805281007x40ded8b1rd68f80c4ce5d79f@mail.gmail.com>
	 <44EE5C37ADC36343B0625A05DD408C483351723448@CHEXMB-01.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2008 at 8:33 PM, Senthilkumar Balasubramanian
<Senthilkumar.Balasubramanian@atheros.com> wrote:
>
> ________________________________________
> From: Tomas Winkler [tomasw@gmail.com]
> Sent: Wednesday, May 28, 2008 10:37 PM
> To: Senthilkumar Balasubramanian
> Cc: John W. Linville; johannes@sipsolutions.net; ron.rindjunsky@intel.com; linux-wireless@vger.kernel.org; Luis Rodriguez
> Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
>
> On Wed, May 28, 2008 at 7:50 PM, Senthilkumar Balasubramanian
> <Senthilkumar.Balasubramanian@atheros.com> wrote:
>> ________________________________________
>> From: John W. Linville [linville@tuxdriver.com]
>> Sent: Wednesday, May 28, 2008 8:46 PM
>> To: Senthilkumar Balasubramanian
>> Cc: johannes@sipsolutions.net; ron.rindjunsky@intel.com; linux-wireless@vger.kernel.org; Luis Rodriguez
>> Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
>>
>> On Wed, May 28, 2008 at 08:20:48PM +0530, Senthil Balasubramanian wrote:
>>> This addresses an alignment issue with compare_ether_addr().
>>> The addresses passed to compare_ether_addr should be two bytes aligned.
>>> It may function properly in x86 platform. However may not work properly
>>> on IA-64 or ARM processor.
>>
>>> --- a/net/mac80211/rx.c
>>> +++ b/net/mac80211/rx.c
>>> @@ -1116,7 +1116,9 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
>>>       u16 fc, hdrlen, ethertype;
>>>       u8 *payload;
>>>       u8 dst[ETH_ALEN];
>>> -     u8 src[ETH_ALEN];
>>> +     /* Should be aligned on 2 bytes for compare_ether_addr() */
>>> +     u16 src_aligned[ETH_ALEN >> 1];
>>> +     u8 *src = (u8 *)src_aligned;
>>>       struct sk_buff *skb = rx->skb;
>>>       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>>       DECLARE_MAC_BUF(mac);
>>
>> Any reason you couldn't just do this?
>>
>> I just thought of using the type u16 instead of attribute here. that's all. No specific reason.
>>
>> @@ -1116,7 +1116,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
>>        u16 fc, hdrlen, ethertype;
>>        u8 *payload;
>>        u8 dst[ETH_ALEN];
>> -       u8 src[ETH_ALEN];
>> +       u8 src[ETH_ALEN] __attribute__ ((aligned(2)));
>>        struct sk_buff *skb = rx->skb;
>>        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>        DECLARE_MAC_BUF(mac);
>>
>> It seems to compile w/o errors on i686, and it seems more clear to me.
>> Will that not work?
>>
>> Yes. It should also work. I will re-create the patch and send it to you. I will also include Johannes suggestion of just using __aligned macro.
>>
> Can we split the two issues in seperate patches. It's better for tracking.
>
> They are not two different issues. All of them addresses the same alignment issue only.  Initially I thought of using u16 to get it aligned on 2 byte and then I started using the attribute stuff as in page_group_addr[] and others required initializations for the u8 array.
>

I mean reordering buffer allocation and alignment are not the same issues.

Thanks
Tomas
