Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:62141 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0C2XV1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 19:21:27 -0400
Received: by fxm23 with SMTP id 23so1302501fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 16:21:25 -0700 (PDT)
Message-ID: <4BB135EC.1070502@googlemail.com>
Date: Tue, 30 Mar 2010 01:21:16 +0200
From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com> <20100329194745.GH4984@tuxdriver.com> <4BB10A0F.1030608@lwfinger.net> <20100329204822.GL4984@tuxdriver.com> <20100329205558.GM4984@tuxdriver.com> <4BB11B8E.1020506@lwfinger.net> <4BB12148.7080309@googlemail.com> <4BB13147.9020002@lwfinger.net>
In-Reply-To: <4BB13147.9020002@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/10 01:01, Larry Finger wrote:
> René and John,
>
> What output does this patch yield?
>
>
> Index: wireless-testing/drivers/ssb/sprom.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/sprom.c
> +++ wireless-testing/drivers/ssb/sprom.c
> @@ -182,6 +182,11 @@ bool ssb_is_sprom_available(struct ssb_b
>   	if (bus->chipco.dev->id.revision<  11)
>   		return true;
>
> +	printk(KERN_INFO "ssb: chip_id 0x%x, status 0x%x\n", bus->chip_id,
> +			  bus->chipco.status);
> +	printk(KERN_INFO "ssb: cc rev 0x%x, cc capab 0x%x\n",
> +			  bus->chipco.dev->id.revision,
> +			  bus->chipco.capabilities);
>   	switch (bus->chip_id) {
>   	case 0x4312:
>   		return SSB_CHIPCO_CHST_4312_SPROM_PRESENT(bus->chipco.status);
>
>

ssb: chip_id 0x4312, status 0x12
ssb: cc rev 0x16, cc capab 0x18600000

And my system completely hangs after this... :(
