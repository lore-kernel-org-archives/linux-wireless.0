Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:55480 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752676Ab2DIVCE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 17:02:04 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Jesper Juhl <jj@chaosbits.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "trivial@kernel.org" <trivial@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Mon, 9 Apr 2012 13:59:08 -0700
Subject: RE: [PATCH 14/26] wireless, mwifiex: drop redundant NULL test
 before call to release_firmware()
Message-ID: <477F20668A386D41ADCC57781B1F7043083A1D4212@SC-VEXCH1.marvell.com> (sfid-20120409_230227_864946_50DB4A74)
References: <alpine.LNX.2.00.1204092157340.13925@swampdragon.chaosbits.net>
 <alpine.LNX.2.00.1204092224080.13925@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1204092224080.13925@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jesper,

Thanks for the patch.

> Since release_firmware() does its own test for NULL it is redundant to
> do so before calling it.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/main.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
> index 9d1b3ca..2ee6162 100644
> --- a/drivers/net/wireless/mwifiex/main.c
> +++ b/drivers/net/wireless/mwifiex/main.c
> @@ -342,8 +342,7 @@ static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)
>  	ret = 0;
> 
>  done:
> -	if (adapter->firmware)
> -		release_firmware(adapter->firmware);
> +	release_firmware(adapter->firmware);
>  	if (ret)
>  		ret = -1;
>  	return ret;
> --
> 1.7.10
> 
> 
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.

