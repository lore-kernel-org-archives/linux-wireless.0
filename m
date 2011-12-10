Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4644 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1LJUqU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 15:46:20 -0500
Message-ID: <4EE3C515.5050307@broadcom.com> (sfid-20111210_214623_546618_44674578)
Date: Sat, 10 Dec 2011 12:46:13 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac + compat wireless + 2.6.35
References: <4ECC1F41.90003@broadcom.com>
 <1323539463-6072-1-git-send-email-GNUtoo@no-log.org>
In-Reply-To: <1323539463-6072-1-git-send-email-GNUtoo@no-log.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Denis,

On 12/10/2011 09:51 AM, Denis 'GNUtoo' Carikli wrote:
>> I will submit a patch too add the dummy handler.
> Since the patch hasn't shown up yet, I decided to give a try,
> But I failed:

I saw the patch you sent. I have one queued up internally but am happy 
to take yours. Does the patch work or not?

> The patch which will follow blocks the phone(ssh doens't respond
> anymore), I really wonder what's wrong with it since it does
> something very similar to the bcm4329 driver.
> The last printk are theses ones:
> [   63.436157] wifi_set_power = 1
> [   63.641585] wifi_set_carddetect = 1
> [   63.646195] sdhci_s3c_force_presence_change : Enter
> [   63.780660] mmc2: queuing unknown CIS tuple 0x80 (50 bytes)
> [   63.796865] mmc2: queuing unknown CIS tuple 0x80 (7 bytes)
> [   63.843426] mmc2: queuing unknown CIS tuple 0x80 (3 bytes)
> [   63.851883] mmc2: new SDIO card at address 0001

Did you try to enable more debug trace? Looks like sdio probe has never 
been called.

Franky


