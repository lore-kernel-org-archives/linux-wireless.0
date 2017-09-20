Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:56097 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751408AbdITVsZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 17:48:25 -0400
Received: by mail-io0-f179.google.com with SMTP id z187so6760323ioz.12
        for <linux-wireless@vger.kernel.org>; Wed, 20 Sep 2017 14:48:25 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: rtl8821ae keep alive not set, connection lost
To: James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
 <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
 <20170914092738.GG20283@us.netrek.org> <20170919094204.GR26927@us.netrek.org>
 <20170920093633.GO9946@us.netrek.org>
Message-ID: <476b183f-5cc5-9a34-1a85-332dd5244b66@lwfinger.net> (sfid-20170920_234830_074347_2B509D73)
Date: Wed, 20 Sep 2017 16:48:23 -0500
MIME-Version: 1.0
In-Reply-To: <20170920093633.GO9946@us.netrek.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/20/2017 04:36 AM, James Cameron wrote:
> When the problem occurs, register 0x350 bit 25 is set, for which a
> comment in _rtl8821ae_check_pcie_dma_hang says means there is an RX
> hang.
> 
> So perhaps driver should call _rtl8821ae_check_pcie_dma_hang
> and _rtl8821ae_reset_pcie_interface_dma.
> 
> Any ideas where to do this?

Thanks for the extended debugging.

I was able to repeat your findings. With the 8-bit read of REG_DBI_RDATA, I got 
poor connection stability. Reverting that part made it stable again. For that 
reason, I pushed the partial reversion of commit 40b368af4b75 ("rtlwifi: Fix 
alignment issues").

Where did you detect that bit 25 of register 0x350 was set?

Larry
