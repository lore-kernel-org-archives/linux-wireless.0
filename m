Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BB2C10F00
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 07:50:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4122206DD
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 07:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729533AbfCFHu6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 02:50:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727367AbfCFHu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 02:50:58 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2959459475;
        Wed,  6 Mar 2019 07:50:58 +0000 (UTC)
Received: from localhost (ovpn-204-204.brq.redhat.com [10.40.204.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5585C60DB4;
        Wed,  6 Mar 2019 07:50:57 +0000 (UTC)
Date:   Wed, 6 Mar 2019 08:50:55 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>
Subject: Re: mediatek: duplicate usb devices
Message-ID: <20190306075053.GA12946@redhat.com>
References: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11161578-bb42-168b-1459-f22a98f5c6bb@gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 06 Mar 2019 07:50:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 05, 2019 at 07:33:51PM +0100, Xose Vazquez Perez wrote:
> There a three duplicate devices at:
> 
> mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
> mt76/mt76x2/usb.c:      { USB_DEVICE(0x0e8d, 0x7612) }, /* Aukey USB-AC1200 */
One duplicated entry should be removed.

> mt76/mt76x0/usb.c:      { USB_DEVICE(0x148f, 0x760a) }, /* TP-Link unknown */
> mt7601u/usb.c:          { USB_DEVICE(0x148f, 0x760a) },
Not sure about this.

> mt76/mt76x0/usb.c:      { USB_DEVICE(0x7392, 0xb711) }, /* Edimax / Elecom  */
> mt76/mt76x2/usb.c:      { USB_DEVICE(0x7392, 0xb711) }, /* Edimax EW 7722 UAC */
According to wikidevi we really have duplicated IDs:

https://wikidevi.com/wiki/Edimax_EW-7722UAC
https://wikidevi.com/wiki/Elecom_WDC-433SU2M

I think we can handle this by checking ASIC version from the EEPROM 
or registers at the beginning of probe and exit if it does not mach.
This should assure we will load proper driver.

Stanislaw
