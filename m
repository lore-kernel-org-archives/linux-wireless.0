Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f50.google.com ([209.85.128.50]:62944 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3DZTCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Apr 2013 15:02:35 -0400
Received: by mail-qe0-f50.google.com with SMTP id k5so1475335qej.37
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2013 12:02:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9E14FFB9@SC-VEXCH1.marvell.com>
References: <CAMLZHHRpPghm0tWTksFiD-zxUUM1dSbgPbj6doMck1jqv-yokw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DAD431B@SC-VEXCH1.marvell.com>
	<CAMLZHHRcTgQ66fucR09SEyjCCRiZixigM=cDwnfKB5yWYk4PQw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9DDAB9CC@SC-VEXCH1.marvell.com>
	<CAMLZHHTe+9D_XwYHFMbu8bRAD7OHNgf8_0+44ZhM+AwSnwLZBw@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E057145@SC-VEXCH1.marvell.com>
	<CAMLZHHS_fBABvx1rGSs2zwv3RredXHh5ChrN7Nwz8ofuL8Vmyg@mail.gmail.com>
	<477F20668A386D41ADCC57781B1F70430D9E14FFB9@SC-VEXCH1.marvell.com>
Date: Fri, 26 Apr 2013 13:02:35 -0600
Message-ID: <CAMLZHHQcN9XwbMFkg+vp0pPfUk_=6-Sha7tAKFqJb4cymWfStQ@mail.gmail.com> (sfid-20130426_210241_069135_02A11092)
Subject: Re: mwifiex frequent "not allowed while suspended" crash on resume
From: Daniel Drake <dsd@laptop.org>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Rhodes <jrhodes@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 25, 2013 at 6:40 PM, Bing Zhao <bzhao@marvell.com> wrote:
> No, it's not OK to transmit before the host sleep is cancelled.
> I was under the assumption that no TX packet is from kernel during the time we cancel host sleep. This assumption can be wrong without netif_device_detach, etc.

OK, this is a fair statement to make. But the presence of (not
entirely working) mechanisms in the code such as the is_suspended flag
that seem to work towards the same goal don't really seem to agree.

Maybe we can drop is_suspended and just stop the TX queue as
appropriate (via netif_device_detach or similar). That would leave us
with both a clear design and a working implementation.

Unless I am missing something, is_suspended only really seems to have
what I would regard as a clear and valid use in the USB subdriver.

> Could you try resetting is_suspend flag when an early RX is received?
>
> +++ b/drivers/net/wireless/mwifiex/cmdevt.c
> @@ -1191,6 +1191,7 @@ mwifiex_process_hs_config(struct mwifiex_adapter *adapter)
>         adapter->if_ops.wakeup(adapter);
>         adapter->hs_activated = false;
>         adapter->is_hs_configured = false;
> +       adapter->is_suspended = false;
>         mwifiex_hs_activated_event(mwifiex_get_priv(adapter,
>                                                     MWIFIEX_BSS_ROLE_ANY),
>                                    false);

This seems to avoid the issue: no error messages during resume, and
the interface remains functional.

Thanks
Daniel
