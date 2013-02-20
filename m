Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33261 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab3BTRrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 12:47:23 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so6219404lbb.13
        for <linux-wireless@vger.kernel.org>; Wed, 20 Feb 2013 09:47:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
References: <CAMLZHHS_G3N+UcKqPBWr6JPTWADCNOgdXReL8s3q3GPpYebGvQ@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE59E@SC-VEXCH1.marvell.com>
	<477F20668A386D41ADCC57781B1F70430D9D6CE6CD@SC-VEXCH1.marvell.com>
Date: Wed, 20 Feb 2013 11:47:21 -0600
Message-ID: <CAMLZHHRmd+Yfr_72HdfNd+knPJg8KvuAA2WrC0TC0wQ8pOeMeA@mail.gmail.com> (sfid-20130220_184726_832050_C6210F1F)
Subject: Re: mwifiex crash when removing interface while scanning
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 19, 2013 at 11:06 PM, Bing Zhao <bzhao@marvell.com> wrote:
>> >     mwifiex_sdio mmc0:0001:1: rx_pending=0, tx_pending=0, cmd_pending=-1
>> >     eth0      Failed to read scan data : No such device
>
> After this error message, do you see the sd8787 card is removed from the bus?
>
> "mmc0: card 0001 removed"

No.

> My card works fine with a Ricoh controller on x86_64 machine. Of course the power is not cut when I remove the mwifiex_sdio module.

Under this kernel, I'm not sure if the power is or isn't being cut at
this point. I don't think this is relevant though; regular
insmod/rmmod cycles work fine, the problem only appears when tearing
down the interface while a scan is in progress.

> I can upgrade my XO-4 to kernel 3.8 if feasible. Please let me know if a HOW-TO doc is available.

You will need a serial console connected, as there is no output on the
LCD at this time when running the upstream kernel.

http://wiki.laptop.org/go/User:DanielDrake/Run_upstream_kernel_on_XO-4

Daniel
