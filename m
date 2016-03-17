Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935881AbcCQOjQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 10:39:16 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Jandy Gou <qingsong.gou@ck-telecom.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8723au: This patch tries to fix some byte order issues that is found by sparse check.
References: <1458201839-7007-1-git-send-email-qingsong.gou@ck-telecom.com>
Date: Thu, 17 Mar 2016 10:39:13 -0400
In-Reply-To: <1458201839-7007-1-git-send-email-qingsong.gou@ck-telecom.com>
	(Jandy Gou's message of "Thu, 17 Mar 2016 16:03:59 +0800")
Message-ID: <wrfjr3f9p3se.fsf@redhat.com> (sfid-20160317_153939_005962_B4B38D61)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jandy Gou <qingsong.gou@ck-telecom.com> writes:
> make C=1 M=drivers/staging/rtl8723au/
>
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:96:38: warning: cast to
> restricted __le16
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:100:27: warning: cast to
> restricted __le32
>
> Signed-off-by: Jandy Gou <qingsong.gou@ck-telecom.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 1662c03c..d82fd8a 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -93,11 +93,11 @@ int FillH2CCmd(struct rtw_adapter *padapter, u8 ElementID, u32 CmdLen,
>  
>  		if (h2c_cmd & BIT(7)) {
>  			msgbox_ex_addr = REG_HMEBOX_EXT_0 + (h2c_box_num * EX_MESSAGE_BOX_SIZE);
> -			h2c_cmd_ex = le16_to_cpu(h2c_cmd_ex);
> +			le16_to_cpus(&h2c_cmd_ex);
>  			rtl8723au_write16(padapter, msgbox_ex_addr, h2c_cmd_ex);
>  		}
>  		msgbox_addr = REG_HMEBOX_0 + (h2c_box_num * MESSAGE_BOX_SIZE);
> -		h2c_cmd = le32_to_cpu(h2c_cmd);
> +		le32_to_cpus(&h2c_cmd);
>  		rtl8723au_write32(padapter, msgbox_addr, h2c_cmd);

Please do *not* use le{16,32}_to_cpus() that is so gross it's hard to
even put words on it. Use a temp variable of the correct type instead.

NAK

Jes
