Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54021C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0676021582
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 10:24:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0676021582
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbeI0QmU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 12:42:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbeI0QmU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 12:42:20 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C8F6232B669;
        Thu, 27 Sep 2018 10:24:45 +0000 (UTC)
Received: from localhost (unknown [10.43.2.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6D1E2106A797;
        Thu, 27 Sep 2018 10:24:42 +0000 (UTC)
Date:   Thu, 27 Sep 2018 12:24:40 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     nbd@nbd.name, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 19/26] mt76x0: pci: add hw initialization at bootstrap
Message-ID: <20180927102440.GE19941@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
 <74b90927973b06ffe237f7d568ffb3fa12791058.1538036134.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74b90927973b06ffe237f7d568ffb3fa12791058.1538036134.git.lorenzo.bianconi@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 27 Sep 2018 10:24:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 27, 2018 at 11:01:48AM +0200, Lorenzo Bianconi wrote:
> Add mt76x0e_register_device routine in pci_init.c
> to initialize the device during hw probe.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> ---
>  .../wireless/mediatek/mt76/mt76x0/Makefile    |  2 +-
>  .../net/wireless/mediatek/mt76/mt76x0/init.c  | 10 +--
>  .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |  2 +
>  .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
>  .../wireless/mediatek/mt76/mt76x0/pci_init.c  | 65 +++++++++++++++++++
>  .../wireless/mediatek/mt76/mt76x02_eeprom.h   |  1 +
>  6 files changed, 73 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_init.c
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
> index 30c84a557076..daa4929bdee6 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
> @@ -6,7 +6,7 @@ mt76x0-common-y := \
>  	init.o main.o trace.o eeprom.o phy.o \
>  	mac.o debugfs.o tx.o
>  mt76x0u-y := usb.o usb_mcu.o usb_init.o
> -mt76x0e-y := pci.o pci_mcu.o
> +mt76x0e-y := pci.o pci_mcu.o pci_init.o

How much {pci,usb}_{init,mcu}.c files are expected to grow?
For now they are about between 100 and 200 lines of code
and I do not see reason to move code into separate files
so far. It could be easy placed in usb.c and pci.c files.
But if the files will grow, I'm ok with code moving.

Thanks
Stanislaw
