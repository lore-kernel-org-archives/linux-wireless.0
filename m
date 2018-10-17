Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882D7ECDE30
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D8CF21526
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 11:54:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="0rKAiiIk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D8CF21526
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbeJQTtW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 15:49:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727013AbeJQTtW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 15:49:22 -0400
Received: from localhost (ip-213-127-77-176.ip.prioritytelecom.net [213.127.77.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFCC22150D;
        Wed, 17 Oct 2018 11:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1539777240;
        bh=srnI9OkrYFEfk6mRqTE3Wjyf68qQZWzXSPjOarQe2Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0rKAiiIkYyPZQY5bNs5LkJ8XNtKbzGpMWsk/gl+RHzkJ0aQ/FfULIPJR8ARY/glhr
         AGRtkEAbw5ivrlnN9sy++WMXbYkPj5rqfgUNiWFhsv2M1ukUhFAUzBea02wx2KYMxX
         66isl5yr9J61xDoiIqgC/OE7jabA47/IX3Fjgs8Y=
Date:   Wed, 17 Oct 2018 13:53:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Lars Poeschel <poeschel@lemonage.de>
Cc:     Samuel Ortiz <sameo@linux.intel.com>, Jiri Slaby <jslaby@suse.com>,
        Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] nfc: pn533: add UART phy driver
Message-ID: <20181017115357.GC32302@kroah.com>
References: <20181017102037.28537-1-poeschel@lemonage.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017102037.28537-1-poeschel@lemonage.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 17, 2018 at 12:20:35PM +0200, Lars Poeschel wrote:
> This adds the UART phy interface for the pn533 driver.
> The pn533 driver can be used through UART interface this way.
> It is implemented as a tty line discipline.

Why not use the serdev interface instead?

> --- /dev/null
> +++ b/drivers/nfc/pn533/uart.c
> @@ -0,0 +1,399 @@
> +/*
> + * Driver for NXP PN532 NFC Chip - UART transport layer
> + *
> + * Copyright (C) 2018 Lemonage Software GmbH
> + * Author: Lars Poeschel <poeschel@lemonage.de>
> + * All rights reserved.

Please use checkpatch.pl on patches so you do not get grumpy maintainers
telling you to use checkpatch.pl on your patches :)

> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.

These three paragraphs can all be dropped because you are going to add
the correct SPDX line at the top of this file, right?  :)


> + */
> +
> +#include <linux/device.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/tty.h>
> +#include <linux/nfc.h>
> +#include <linux/netdevice.h>
> +#include <net/nfc/nfc.h>
> +#include "pn533.h"
> +
> +#define VERSION "0.1"
> +
> +#define PN532_I2C_DRIVER_NAME "pn532_uart"
> +
> +#define PN532_MAGIC		0x162f

The whole old model of "magic" tty numbers can just be removed.  It
never really did anything except to try to protect you from other broken
kernel code.  You can drop it all if you really do end up making a tty
device here.

thanks,

greg k-h
