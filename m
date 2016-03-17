Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:35152 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbcCQJTU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <1458201839-7007-1-git-send-email-qingsong.gou@ck-telecom.com>
References: <1458201839-7007-1-git-send-email-qingsong.gou@ck-telecom.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 17 Mar 2016 20:18:59 +1100
Message-ID: <CAGRGNgXEfvSuxLZ3Qrb3hj7DK89qBKX3Bh2+0Ov9FZX+4_PqOw@mail.gmail.com> (sfid-20160317_101953_344648_79725724)
Subject: Re: [PATCH] staging: r8723au: This patch tries to fix some byte order
 issues that is found by sparse check.
To: Jandy Gou <qingsong.gou@ck-telecom.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jandy,

On Thu, Mar 17, 2016 at 7:03 PM, Jandy Gou <qingsong.gou@ck-telecom.com> wrote:
> make C=1 M=drivers/staging/rtl8723au/
>
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:96:38: warning: cast to
> restricted __le16
> drivers/staging/rtl8723au/hal/rtl8723a_cmd.c:100:27: warning: cast to
> restricted __le32
>
> Signed-off-by: Jandy Gou <qingsong.gou@ck-telecom.com>

I'm not sure your change is correct. Perhaps you should add temporary
variables for h2c_cmd_ex and h2c_cmd while they're cpu-endian?

Jes,

I'm pretty sure this isn't the first time this has come up. Do you
have any ideas for a solution? Or should we ignore this as this driver
will eventually be going away?

Thanks,

Julian Calaby

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
>                 if (h2c_cmd & BIT(7)) {
>                         msgbox_ex_addr = REG_HMEBOX_EXT_0 + (h2c_box_num * EX_MESSAGE_BOX_SIZE);
> -                       h2c_cmd_ex = le16_to_cpu(h2c_cmd_ex);
> +                       le16_to_cpus(&h2c_cmd_ex);
>                         rtl8723au_write16(padapter, msgbox_ex_addr, h2c_cmd_ex);
>                 }
>                 msgbox_addr = REG_HMEBOX_0 + (h2c_box_num * MESSAGE_BOX_SIZE);
> -               h2c_cmd = le32_to_cpu(h2c_cmd);
> +               le32_to_cpus(&h2c_cmd);
>                 rtl8723au_write32(padapter, msgbox_addr, h2c_cmd);
>
>                 bcmd_down = true;
> --
> 1.9.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
