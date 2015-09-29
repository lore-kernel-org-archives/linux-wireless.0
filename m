Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38702 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932836AbbI2Idd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 04:33:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: RUC_Soft_Sec <zy900702@163.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [net] orinoco_usb:Fix error handling in ezusb_probe()
References: <52c0b90f.10cf0.14ff4df0cc4.Coremail.zy900702@163.com>
Date: Tue, 29 Sep 2015 11:33:26 +0300
In-Reply-To: <52c0b90f.10cf0.14ff4df0cc4.Coremail.zy900702@163.com> (RUC Soft
	Sec's message of "Tue, 22 Sep 2015 19:45:02 +0800 (CST)")
Message-ID: <87mvw57hgp.fsf@kamboji.qca.qualcomm.com> (sfid-20150929_103351_390096_24185112)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RUC_Soft_Sec <zy900702@163.com> writes:

> Current code assigns 0 to variable 'retval', which makes ezusb_probe() to
> return success even if alloc_orinocodev() fails.
>
> The related code snippets in mantis_dma_init() is as following.
>
> 1573 static int ezusb_probe(struct usb_interface *interface,
> 1574                        const struct usb_device_id *id)
> 1575 {
>
>                  ....
>
> 1583         int retval = 0;
> 1584         int i;
> 1585
> 1586         priv = alloc_orinocodev(sizeof(*upriv), &udev->dev,
> 1587                                 ezusb_hard_reset, NULL);
> 1588         if (!priv) {
> 1589                 err("Couldn't allocate orinocodev");
> 1590                 goto exit;
> 1591         }
>                  ...
>
> 1729  exit:
> 1730         if (fw_entry) {
> 1731                 firmware.code = NULL;
> 1732                 firmware.size = 0;
> 1733                 release_firmware(fw_entry);
> 1734         }
> 1735         usb_set_intfdata(interface, upriv);
> 1736         return retval;
> 1737 }
>
>  Fix it by checking the return value from alloc_orinocodev() and assigns
> '-ENOMEM' to variable 'retval' in the case of error.
>
> Signed-off-by: Zhang Yan <zy900702@163.com>---
>  orinoco_usb.c |    1 +
>  1 file changed, 1 insertion(+)
> diff --git a/orinoco_usb.c b/orinoco_usb.c

The patch looks corrupted. And the from header doesn't contain a proper
name.

-- 
Kalle Valo
