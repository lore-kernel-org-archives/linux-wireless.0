Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244AbcD2Cay (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 22:30:54 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jandy Gou <qingsong.gou@ck-telecom.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	shraddha.6596@gmail.com, hgujulan@visteon.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: r8723au: This patch tries to fix some byte order  issues that is found by sparse check.
References: <1461895751-15168-1-git-send-email-qingsong.gou@ck-telecom.com>
Date: Thu, 28 Apr 2016 22:30:44 -0400
In-Reply-To: <1461895751-15168-1-git-send-email-qingsong.gou@ck-telecom.com>
	(Jandy Gou's message of "Fri, 29 Apr 2016 10:09:11 +0800")
Message-ID: <wrfj7ffhw3hn.fsf@redhat.com> (sfid-20160429_043112_076815_E0250A9B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jandy Gou <qingsong.gou@ck-telecom.com> writes:
>  make C=1 M=drivers/staging/rtl8723au/
>
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:96:38: warning: cast to
>  restricted __le16
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:100:27: warning: cast to
>  restricted __le32
>
> Signed-off-by: Jandy Gou <qingsong.gou@ck-telecom.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 1662c03c..fff652c 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -56,8 +56,8 @@ int FillH2CCmd(struct rtw_adapter *padapter, u8 ElementID, u32 CmdLen,
>  	u32 msgbox_addr;
>  	u32 msgbox_ex_addr;
>  	struct hal_data_8723a *pHalData;
> -	u32 h2c_cmd = 0;
> -	u16 h2c_cmd_ex = 0;
> +	__le32 h2c_cmd = 0;
> +	__le16 h2c_cmd_ex = 0;
>  	int ret = _FAIL;
>  
>  	padapter = GET_PRIMARY_ADAPTER(padapter);
> @@ -91,14 +91,12 @@ int FillH2CCmd(struct rtw_adapter *padapter, u8 ElementID, u32 CmdLen,
>  
>  		*(u8 *)(&h2c_cmd) |= ElementID;
>  
> -		if (h2c_cmd & BIT(7)) {
> +		if (le32_to_cpu(h2c_cmd) & BIT(7)) {
>  			msgbox_ex_addr = REG_HMEBOX_EXT_0 + (h2c_box_num * EX_MESSAGE_BOX_SIZE);
> -			h2c_cmd_ex = le16_to_cpu(h2c_cmd_ex);
> -			rtl8723au_write16(padapter, msgbox_ex_addr, h2c_cmd_ex);
> +			rtl8723au_write16(padapter, msgbox_ex_addr, le16_to_cpu(h2c_cmd_ex));
>  		}

This actually changes the behavior on big-endian systems. Did you test
this?

Second, the last line makes the line more than 80 charaters whish is
wrong.

Jes
