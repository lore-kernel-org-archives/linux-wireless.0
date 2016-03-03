Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758043AbcCCVyo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 16:54:44 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: dsadsa sadsad <natserver2@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
References: <loom.20160128T003525-188@post.gmane.org>
	<wrfjd1sco25f.fsf@redhat.com> <56B38CDF.9010806@lwfinger.net>
	<wrfjd1scmkz6.fsf@redhat.com> <wrfj60xxd2f5.fsf@redhat.com>
	<56BA8E5D.5090402@lwfinger.net> <wrfjlh6tb9zt.fsf@redhat.com>
	<CAOhKHAXH-PCyWQSpuuZ=-6BnE0PeDks-4p9A3G_86OHLfEdU=w@mail.gmail.com>
	<56BB5C16.8070206@lwfinger.net> <wrfjk2lomobj.fsf@redhat.com>
	<56D3EBCF.7000206@lwfinger.net> <wrfj7fhnn1jk.fsf@redhat.com>
	<56D4B956.8030408@lwfinger.net>
Date: Thu, 03 Mar 2016 16:54:43 -0500
In-Reply-To: <56D4B956.8030408@lwfinger.net> (Larry Finger's message of "Mon,
	29 Feb 2016 15:34:14 -0600")
Message-ID: <wrfjbn6v5isc.fsf@redhat.com> (sfid-20160303_225450_018466_9769F235)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 02/29/2016 06:28 AM, Jes Sorensen wrote:
>> That one I have never seen before - could you try and insert some debug
>> prints to see where the RF initialization fails?
>
> The call to usb_control_msg() is returning -EPROTO (-71), but
> sometimes the system works. I added the following patch:
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 38aa3c2..8ab77a0 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -1979,9 +1979,12 @@ static int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
>
>         /* Use XB for path B */
>         ret = rtl8xxxu_write32(priv, rtl8xxxu_rfregs[path].lssiparm, dataaddr);
> -       if (ret != sizeof(dataaddr))
> +       if (ret != sizeof(dataaddr)) {
> +               pr_info("**** rtl8xxxu_write32() error %d: path %d,
> reg: 0x%x, data 0x%x, dataaddr 0x%x, lssiparm 0x%x\n",
> +                       ret, path, reg, data, dataaddr,
> rtl8xxxu_rfregs[path].lssiparm);
> +               dump_stack();
>                 retval = -EIO;
> -       else
> +       } else
>                 retval = 0;
>
>         udelay(1);
>
> When the error happens, my log contains

Odd, I wonder if my code writes the reigsters out to the device too
fast. You could try adding a call to read back the RF register before
exiting the function - preferably after the udelay().

Cheers,
Jes
