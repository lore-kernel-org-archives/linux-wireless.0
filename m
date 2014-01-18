Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58529 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbaAREiq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 23:38:46 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <afenkart@gmail.com>
CC: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 17 Jan 2014 20:38:42 -0800
Subject: RE: [PATCH] mwifiex: fix wakeup on magic packet
Message-ID: <477F20668A386D41ADCC57781B1F70430F53691DB1@SC-VEXCH1.marvell.com> (sfid-20140118_053910_847707_9C8BCC78)
References: <CALtMJEDwkCV_wXiPGecoBG-bnG-2OzNMQB-hLHbV9gVr3hZE-A@mail.gmail.com>
 <1389968780-27268-1-git-send-email-afenkart@gmail.com>
In-Reply-To: <1389968780-27268-1-git-send-email-afenkart@gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

>  8 bytes preamble
> 14 bytes src/dst/eth_type
>  6 bytes 0xff:0xff..
> 
> http://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet
> http://en.wikipedia.org/wiki/EtherType
> 
> This will fail if we VLAN or the magic packet is encapsulated
> as a UDP packet...
> 
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

Thanks for your patch.

Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index aeaea0e..7e91587 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> @@ -2438,7 +2438,7 @@ static int mwifiex_cfg80211_suspend(struct wiphy *wiphy,
>  		       ETH_ALEN);
>  		mef_entry->filter[filt_num].byte_seq[MWIFIEX_MEF_MAX_BYTESEQ] =
>  								ETH_ALEN;
> -		mef_entry->filter[filt_num].offset = 14;
> +		mef_entry->filter[filt_num].offset = 28;
>  		mef_entry->filter[filt_num].filt_type = TYPE_EQ;
>  		if (filt_num)
>  			mef_entry->filter[filt_num].filt_action = TYPE_OR;
> --
> 1.7.10.4

