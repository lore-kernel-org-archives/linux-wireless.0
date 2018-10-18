Return-Path: <SRS0=Zpd3=M6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4F44C5ACCC
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 15:00:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C2B52098A
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Oct 2018 15:00:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C2B52098A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728227AbeJRXBz convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Oct 2018 19:01:55 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:36324 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727303AbeJRXBz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Oct 2018 19:01:55 -0400
Received: from marcel-macbook.fritz.box (p4FF9F655.dip0.t-ipconnect.de [79.249.246.85])
        by mail.holtmann.org (Postfix) with ESMTPSA id 224BACEF9C;
        Thu, 18 Oct 2018 17:07:52 +0200 (CEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [PATCH v2 1/4] nfc: pn533: add UART phy driver
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20181018144251.30028-1-poeschel@lemonage.de>
Date:   Thu, 18 Oct 2018 17:00:28 +0200
Cc:     devicetree@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6CB47B97-F58D-4162-98C1-8C8C88CE2914@holtmann.org>
References: <20181018144251.30028-1-poeschel@lemonage.de>
To:     Lars Poeschel <poeschel@lemonage.de>
X-Mailer: Apple Mail (2.3445.100.39)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Lars,

> This adds the UART phy interface for the pn533 driver.
> The pn533 driver can be used through UART interface this way.
> It is implemented as a serdev device.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> ---
> Changes in v2:
> - switched from tty line discipline to serdev, resulting in many
>  simplifications
> - SPDX License Identifier
> 
> drivers/nfc/pn533/Kconfig  |  10 ++
> drivers/nfc/pn533/Makefile |   2 +
> drivers/nfc/pn533/pn533.h  |   8 ++
> drivers/nfc/pn533/uart.c   | 283 +++++++++++++++++++++++++++++++++++++
> 4 files changed, 303 insertions(+)
> create mode 100644 drivers/nfc/pn533/uart.c
> 
> diff --git a/drivers/nfc/pn533/Kconfig b/drivers/nfc/pn533/Kconfig
> index d94122dd30e4..da3ea2dbaa8a 100644
> --- a/drivers/nfc/pn533/Kconfig
> +++ b/drivers/nfc/pn533/Kconfig
> @@ -25,3 +25,13 @@ config NFC_PN533_I2C
> 
> 	  If you choose to build a module, it'll be called pn533_i2c.
> 	  Say N if unsure.
> +
> +config NFC_PN532_UART
> +	tristate "NFC PN532 device support (UART)”

you are missing the "depends on SERIAL_DEV_BUS” here.

> +	select NFC_PN533
> +	---help---
> +	  This module adds support for the NXP pn532 UART interface.
> +	  Select this if your platform is using the UART bus.
> +
> +	  If you choose to build a module, it'll be called pn532_uart.
> +	  Say N if unsure.

Regards

Marcel

