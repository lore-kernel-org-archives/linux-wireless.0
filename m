Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62266 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab3JSIbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Oct 2013 04:31:41 -0400
Message-ID: <5262436A.4020200@gmail.com> (sfid-20131019_103229_385109_A7A742A5)
Date: Sat, 19 Oct 2013 10:31:38 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Felipe Pena <felipensp@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: rt2800lib: Fix typo on checking
References: <1382142042-4463-1-git-send-email-felipensp@gmail.com>
In-Reply-To: <1382142042-4463-1-git-send-email-felipensp@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/13 02:20, Felipe Pena wrote:
> On rt2800_config_channel_rf53xx function the member default_power1 is checked
> for bound limit, but default_power2 is used instead.
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>

Good catch.

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
> index 88ce656..1c2ce93 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -2650,7 +2650,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
> 
>  	if (rt2x00_rt(rt2x00dev, RT5392)) {
>  		rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
> -		if (info->default_power1 > POWER_BOUND)
> +		if (info->default_power2 > POWER_BOUND)
>  			rt2x00_set_field8(&rfcsr, RFCSR50_TX, POWER_BOUND);
>  		else
>  			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
> --
> 1.7.10.4
> 


-- 
---
Gertjan
