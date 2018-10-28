Return-Path: <SRS0=/i66=NI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E268C6786F
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 13:46:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F7AF20843
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 13:46:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F7AF20843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=holtmann.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbeJ1WbI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 28 Oct 2018 18:31:08 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:37707 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbeJ1WbI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 28 Oct 2018 18:31:08 -0400
Received: from marcel-macbook.fritz.box (p4FF9F655.dip0.t-ipconnect.de [79.249.246.85])
        by mail.holtmann.org (Postfix) with ESMTPSA id 57E55CEEAF;
        Sun, 28 Oct 2018 14:53:51 +0100 (CET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [PATCH v3 3/5] nfc: pn533: add UART phy driver
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20181028102725.GL27852@localhost>
Date:   Sun, 28 Oct 2018 14:46:24 +0100
Cc:     Lars Poeschel <poeschel@lemonage.de>,
        devicetree <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NFC SUBSYSTEM" <linux-wireless@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <9494A12C-C53A-4F6E-B6F3-BABB09867677@holtmann.org>
References: <20181025132937.24405-1-poeschel@lemonage.de>
 <20181025132937.24405-3-poeschel@lemonage.de>
 <20181028102725.GL27852@localhost>
To:     Johan Hovold <johan@kernel.org>
X-Mailer: Apple Mail (2.3445.100.39)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johan,

>> This adds the UART phy interface for the pn533 driver.
>> The pn533 driver can be used through UART interface this way.
>> It is implemented as a serdev device.
> 
> Just a few drive-by comments below.
> 
>> +// SPDX-License-Identifier: GPL-2.0
> 
> This should match MODULE_LICENSE below which currently says v2 *or
> later*.
> 
>> +/*
>> + * Driver for NXP PN532 NFC Chip - UART transport layer
>> + *
>> + * Copyright (C) 2018 Lemonage Software GmbH
>> + * Author: Lars Pöschel <poeschel@lemonage.de>
>> + * All rights reserved.
>> + */
> 
>> +#define VERSION "0.1"
> 
> We don't version kernel drivers individually, so please drop this here
> and below.

if we don’t then maybe send patches to remove MODULE_VERSION first. Otherwise this is totally fine to do.

There are currently 670 usages of MODULE_VERSION and I have not heard anybody looking at removing this.

Regards

Marcel

