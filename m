Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30942 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbGAH4T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 03:56:19 -0400
Date: Wed, 1 Jul 2015 10:56:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Michel von Czettritz <michel.von.czettritz@gmail.com>
Cc: gregkh@linux.com, devel@driverdev.osuosl.org,
	Jes.Sorensen@redhat.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 2/3] staging: rtl8723au: fix "incorrect type in
 assignment"
Message-ID: <20150701075606.GU28762@mwanda> (sfid-20150701_095623_823225_F70E35B9)
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
 <d7c0812eedadab3697323bd53aeadba48ecf6d89.1435700714.git.michel.von.czettritz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d7c0812eedadab3697323bd53aeadba48ecf6d89.1435700714.git.michel.von.czettritz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2015 at 11:54:02PM +0200, Michel von Czettritz wrote:
> Writing the output of cpu_to_le32 to an u32 or *(u32*) is an implicit
> cast and results in an sparse warning.
> 
> Since param and mask won't be changed, the implicit cast can be avoided
> by creating local variables.
> 
> Signed-off-by: Michel von Czettritz <michel.von.czettritz@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 1003365..a5e6726 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -115,9 +115,10 @@ exit:
>  
>  int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
>  {
> -	*((u32 *)param) = cpu_to_le32(*(param));
> +	__le32 param_le;
> +	param_le = cpu_to_le32(*(param));

We shouldn't be passing param as a pointer anyway.  It should just be
u32 cmd.

	__le32 cmd_le = cpu_to_le32(cmd);

	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&cmd_le);

Fold it together with patch 1.

regards,
dan carpenter

