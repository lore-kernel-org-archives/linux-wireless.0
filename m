Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f41.google.com ([209.85.216.41]:64312 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965154Ab3DPU7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 16:59:44 -0400
Received: by mail-qa0-f41.google.com with SMTP id hg5so1687213qab.7
        for <linux-wireless@vger.kernel.org>; Tue, 16 Apr 2013 13:59:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9DDAB9CC@SC-VEXCH1.marvell.com>
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
	<CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DDAB9CC@SC-VEXCH1.marvell.com>
Date: Tue, 16 Apr 2013 14:59:43 -0600
Message-ID: <CAMLZHHTe+9D_XwYHFMbu8bRAD7OHNgf8_0+44ZhM+AwSnwLZBw@mail.gmail.com> (sfid-20130416_225949_114751_31080E56)
Subject: Re: mwifiex frequent "not allowed while suspended" crash on resume
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 5, 2013 at 5:48 PM, Bing Zhao <bzhao@marvell.com> wrote:
> Normally TX is blocked until resume handler is called and host sleep handshake between driver and firmware is done.

Where is the code that makes such synchronization happen?

> Does the TX happen before "hs_deactivated" event?

hard_start_xmit is called approximately 1ms after hs_deactivated arrives.

> I'm thinking of releasing IRQ in driver suspend handler and re-claim the IRQ in resume. Of course it needs some changes in sdio_release_irq to skip SDIO_CCCR_IENx disabling, otherwise host may not be woken up by SDIO DAT1.
>
> Attached is the sample code, not tested.

That patch breaks wake-on-LAN, the suspended system simply doesn't
respond to incoming packets.

Daniel
