Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50319 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834AbZHDQVC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 12:21:02 -0400
Subject: Re: [PATCH] libertas: Read buffer overflow
From: Dan Williams <dcbw@redhat.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A7543CC.2010206@gmail.com>
References: <4A7543CC.2010206@gmail.com>
Content-Type: text/plain
Date: Tue, 04 Aug 2009 11:16:35 -0400
Message-Id: <1249398995.21155.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-08-02 at 09:44 +0200, Roel Kluin wrote:
> Check whether index is within bounds before testing the element.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> diff --git a/drivers/net/wireless/libertas/11d.c b/drivers/net/wireless/libertas/11d.c
> index 9a5408e..5c69681 100644
> --- a/drivers/net/wireless/libertas/11d.c
> +++ b/drivers/net/wireless/libertas/11d.c
> @@ -47,7 +47,7 @@ static u8 lbs_region_2_code(u8 *region)
>  {
>  	u8 i;
>  
> -	for (i = 0; region[i] && i < COUNTRY_CODE_LEN; i++)
> +	for (i = 0; i < COUNTRY_CODE_LEN && region[i]; i++)
>  		region[i] = toupper(region[i]);
>  
>  	for (i = 0; i < ARRAY_SIZE(region_code_mapping); i++) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

