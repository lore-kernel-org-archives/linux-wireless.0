Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EB3C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 05:18:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFFCF2085B
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 05:18:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AFFCF2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbeJHM14 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 08:27:56 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:39577 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbeJHM14 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 08:27:56 -0400
X-IronPort-AV: E=Sophos;i="5.54,355,1534834800"; 
   d="scan'208";a="18450158"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 07 Oct 2018 22:18:04 -0700
Received: from ajaysk-VirtualBox (10.10.76.4) by chn-sv-exch06.mchp-main.com
 (10.10.76.107) with Microsoft SMTP Server id 14.3.352.0; Sun, 7 Oct 2018
 22:18:03 -0700
Date:   Mon, 8 Oct 2018 10:47:57 +0530
From:   Ajay Singh <ajay.kathat@microchip.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <aditya.shankar@microchip.com>,
        <venkateswara.kaja@microchip.com>, <claudiu.beznea@microchip.com>,
        <adham.abozaeid@microchip.com>
Subject: Re: [RFC 00/19] wilc: added driver for wilc module
Message-ID: <20181008104757.5e27eacb@ajaysk-VirtualBox>
In-Reply-To: <87zhvrdz0q.fsf@kamboji.qca.qualcomm.com>
References: <1537957525-11467-1-git-send-email-ajay.kathat@microchip.com>
        <87zhvrdz0q.fsf@kamboji.qca.qualcomm.com>
Organization: Microchip Technology
X-Mailer: Claws Mail 3.13.2 (GTK+ 2.24.30; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 6 Oct 2018 15:45:41 +0300
Kalle Valo <kvalo@codeaurora.org> wrote:

> Ajay Singh <ajay.kathat@microchip.com> writes:
> 
> > This patch set contains the driver files from
> > 'driver/staging/wilc1000'. Renamed the driver from 'wilc1000' to
> > 'wilc' to have generic name, as the same driver will be used by
> > other wilc family members.  
> 
> I'm worried that the name 'wilc' is just too generic, I liked the
> original name wilc1000 much more. Quite often when we have a new
> generation of wireless devices there's also a new driver, so in the
> long run I'm worried that a generic name like 'wilc' could be a
> source of confusion. I think it's much smaller problem if
> 'wilc1000' (the driver) also supports wilc3000 (the device), people
> are already used to that. 

I also thought about retaining the same wilc1000 name, which has be
used for quite some time now. But as we are moving this driver
to '/driver/net/wireless/' freshly so thought it’s better to change in
the first commit.

As you know, 'wilc1000' name is used for folder name as well as module
name (i.e wilc1000.ko and wilc1000-spi.ko/wilc1000-sdio.ko). WILC3000 is
going to use the same modules(.ko).

Do you think its good approach to have 'wilc1000' folder but only remove
‘wilc1000’ prefix from .ko modules names in Makefile (i.e wilc.ko and
wilc-spio.ko/wilc-sdio.ko). So these .ko becomes generic and give clear
name to be used with both wilc1000 and wilc3000 modules.

Please let know what do you think about it and based on your input I
will make the change.

Also should I submit the v2 version by retaining old name or wait for
few more comments to include in that.

Regards,
Ajay
