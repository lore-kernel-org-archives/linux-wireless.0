Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51915 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbYJ3EM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 00:12:27 -0400
Subject: Re: [PATCH] libertas: fix buffer overrun
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225277012.5439.0.camel@johannes.berg>
References: <1225277012.5439.0.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 00:10:53 -0400
Message-Id: <1225339853.32092.18.camel@localhost.localdomain> (sfid-20081030_051229_767555_CF5D648B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-10-29 at 11:43 +0100, Johannes Berg wrote:
> If somebody sends an invalid beacon/probe response, that can trash the
> whole BSS descriptor. The descriptor is, luckily, large enough so that
> it cannot scribble past the end of it; it's well above 400 bytes long.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: stable@kernel.org [2.6.24-2.6.27, bug present in some form since driver was added (2.6.22)]

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> Not really tested for lack of hw.
> 
> John, this is part of the other patch I sent, but this one's
> for 2.6.28.
> 
> The function there needs to be reviewed more, it seems to access
> potentially invalid memory when an AP sends other, too short,
> information elements.
> 
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -598,8 +598,8 @@ static int lbs_process_bss(struct bss_descriptor *bss,
>  
>  		switch (elem->id) {
>  		case MFIE_TYPE_SSID:
> -			bss->ssid_len = elem->len;
> -			memcpy(bss->ssid, elem->data, elem->len);
> +			bss->ssid_len = min_t(int, 32, elem->len);
> +			memcpy(bss->ssid, elem->data, bss->ssid_len);
>  			lbs_deb_scan("got SSID IE: '%s', len %u\n",
>  			             escape_essid(bss->ssid, bss->ssid_len),
>  			             bss->ssid_len);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

