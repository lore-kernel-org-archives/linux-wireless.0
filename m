Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:49096 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab0C2Tfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 15:35:54 -0400
Received: by fxm23 with SMTP id 23so1157438fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 12:35:52 -0700 (PDT)
Message-ID: <4BB10110.9090202@googlemail.com>
Date: Mon, 29 Mar 2010 21:35:44 +0200
From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
References: <4BB0FD96.5020402@lwfinger.net>
In-Reply-To: <4BB0FD96.5020402@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/10 21:20, Larry Finger wrote:
> Ren�,
>
> When you have a wireless problem, please post it to
> linux-wireless@vger.kernel.org. The Linux Kernel Mailing List may or may not be
> appropriate.
>
> To help in diagnosing your problem, please apply this patch and post the output
> line that it produces. On my system, it shows
>
> ssb: chip_id 0x4312, status 0x10
>
and on my: ssb: chip_id 0x4312, status 0x12
> Please also post the output of 'lspci -nnv | grep 14e4'.
Yep:
01:00.0 Network controller [0280]: Broadcom Corporation BCM4312 
802.11b/g [14e4:4315] (rev 01)
>
> Index: wireless-testing/drivers/ssb/sprom.c
> ===================================================================
> --- wireless-testing.orig/drivers/ssb/sprom.c
> +++ wireless-testing/drivers/ssb/sprom.c
> @@ -182,6 +182,8 @@ bool ssb_is_sprom_available(struct ssb_b
>   	if (bus->chipco.dev->id.revision<  11)
>   		return true;
>
> +	printk(KERN_INFO "ssb: chip_id 0x%x, status 0x%x\n", bus->chip_id,
> +			  bus->chipco.status);
>   	switch (bus->chip_id) {
>   	case 0x4312:
>   		return SSB_CHIPCO_CHST_4312_SPROM_PRESENT(bus->chipco.status);
>
>
> Larry
>
>

