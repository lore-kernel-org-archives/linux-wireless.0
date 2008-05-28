Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35469 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbYE1Rdw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 13:33:52 -0400
Received: from mail.atheros.com ([192.168.11.2])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 May 2008 10:33:52 -0700
From: Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@Atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"ron.rindjunsky@intel.com" <ron.rindjunsky@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Date: Wed, 28 May 2008 23:03:45 +0530
Subject: RE: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
Message-ID: <44EE5C37ADC36343B0625A05DD408C483351723448@CHEXMB-01.global.atheros.com> (sfid-20080528_193357_014693_80027291)
References: <20080528145048.GB5244@senthil-lnx.users.atheros.com>
	 <20080528151651.GA13461@tuxdriver.com>
	 <44EE5C37ADC36343B0625A05DD408C483351723447@CHEXMB-01.global.atheros.com>,<1ba2fa240805281007x40ded8b1rd68f80c4ce5d79f@mail.gmail.com>
In-Reply-To: <1ba2fa240805281007x40ded8b1rd68f80c4ce5d79f@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


________________________________________
From: Tomas Winkler [tomasw@gmail.com]
Sent: Wednesday, May 28, 2008 10:37 PM
To: Senthilkumar Balasubramanian
Cc: John W. Linville; johannes@sipsolutions.net; ron.rindjunsky@intel.com; linux-wireless@vger.kernel.org; Luis Rodriguez
Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()

On Wed, May 28, 2008 at 7:50 PM, Senthilkumar Balasubramanian
<Senthilkumar.Balasubramanian@atheros.com> wrote:
> ________________________________________
> From: John W. Linville [linville@tuxdriver.com]
> Sent: Wednesday, May 28, 2008 8:46 PM
> To: Senthilkumar Balasubramanian
> Cc: johannes@sipsolutions.net; ron.rindjunsky@intel.com; linux-wireless@vger.kernel.org; Luis Rodriguez
> Subject: Re: [PATCH] mac80211: fix alignment issue with compare_ether_addr()
>
> On Wed, May 28, 2008 at 08:20:48PM +0530, Senthil Balasubramanian wrote:
>> This addresses an alignment issue with compare_ether_addr().
>> The addresses passed to compare_ether_addr should be two bytes aligned.
>> It may function properly in x86 platform. However may not work properly
>> on IA-64 or ARM processor.
>
>> --- a/net/mac80211/rx.c
>> +++ b/net/mac80211/rx.c
>> @@ -1116,7 +1116,9 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
>>       u16 fc, hdrlen, ethertype;
>>       u8 *payload;
>>       u8 dst[ETH_ALEN];
>> -     u8 src[ETH_ALEN];
>> +     /* Should be aligned on 2 bytes for compare_ether_addr() */
>> +     u16 src_aligned[ETH_ALEN >> 1];
>> +     u8 *src = (u8 *)src_aligned;
>>       struct sk_buff *skb = rx->skb;
>>       struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>>       DECLARE_MAC_BUF(mac);
>
> Any reason you couldn't just do this?
>
> I just thought of using the type u16 instead of attribute here. that's all. No specific reason.
>
> @@ -1116,7 +1116,7 @@ ieee80211_data_to_8023(struct ieee80211_rx_data *rx)
>        u16 fc, hdrlen, ethertype;
>        u8 *payload;
>        u8 dst[ETH_ALEN];
> -       u8 src[ETH_ALEN];
> +       u8 src[ETH_ALEN] __attribute__ ((aligned(2)));
>        struct sk_buff *skb = rx->skb;
>        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
>        DECLARE_MAC_BUF(mac);
>
> It seems to compile w/o errors on i686, and it seems more clear to me.
> Will that not work?
>
> Yes. It should also work. I will re-create the patch and send it to you. I will also include Johannes suggestion of just using __aligned macro.
>
Can we split the two issues in seperate patches. It's better for tracking.

They are not two different issues. All of them addresses the same alignment issue only.  Initially I thought of using u16 to get it aligned on 2 byte and then I started using the attribute stuff as in page_group_addr[] and others required initializations for the u8 array.

Thanks
Tomas
