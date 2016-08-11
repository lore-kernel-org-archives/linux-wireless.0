Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbcHKP0A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 11:26:00 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Bing Sun <sunbing@redflag-linux.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, sunbing.linux@gmail.com
Subject: Re: [PATCH] Staging: rtl8723au: os_intfs: fixed case statement is variable issue
References: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com>
Date: Thu, 11 Aug 2016 11:25:58 -0400
In-Reply-To: <1470924695-14931-1-git-send-email-sunbing@redflag-linux.com>
	(Bing Sun's message of "Thu, 11 Aug 2016 22:11:35 +0800")
Message-ID: <wrfja8gje395.fsf@redhat.com> (sfid-20160811_172604_342165_B2CCA0CD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing Sun <sunbing@redflag-linux.com> writes:
> Fixed sparse parse error:
> Expected constant expression in case statement.
>
> Signed-off-by: Bing Sun <sunbing@redflag-linux.com>
> ---
>  drivers/staging/rtl8723au/os_dep/os_intfs.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/os_dep/os_intfs.c b/drivers/staging/rtl8723au/os_dep/os_intfs.c
> index b8848c2..f30d5d2 100644
> --- a/drivers/staging/rtl8723au/os_dep/os_intfs.c
> +++ b/drivers/staging/rtl8723au/os_dep/os_intfs.c
> @@ -283,14 +283,13 @@ static u32 rtw_classify8021d(struct sk_buff *skb)
>  	 */
>  	if (skb->priority >= 256 && skb->priority <= 263)
>  		return skb->priority - 256;
> -	switch (skb->protocol) {
> -	case htons(ETH_P_IP):
> +
> +	if (skb->protocol == htons(ETH_P_IP)) {
>  		dscp = ip_hdr(skb)->tos & 0xfc;
> -		break;
> -	default:
> -		return 0;
> +		return dscp >> 5;
>  	}
> -	return dscp >> 5;
> +
> +	return 0;
>  }

Pardon me here, but I find it really hard to see how this change is an
improvement over the old code in any shape or form.

Jes
