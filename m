Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34869 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbcESW4Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2016 18:56:16 -0400
Received: by mail-io0-f193.google.com with SMTP id 190so1439898iow.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2016 15:56:15 -0700 (PDT)
Date: Thu, 19 May 2016 18:56:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: James Feeney <james@nurealm.net>
Cc: hostap@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: "kernel: BUG: scheduling while atomic:" errors with linux kernel
 4.6
Message-ID: <20160519225612.GB12028@localhost> (sfid-20160520_005620_651522_3AE694C3)
References: <e2d89c7d-7567-c3ac-505e-7a9aa887c158@nurealm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e2d89c7d-7567-c3ac-505e-7a9aa887c158@nurealm.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+linux-wireless

On Thu, May 19, 2016 at 03:11:16PM -0600, James Feeney wrote:
> Arch linux 4.6-1
> wpa_supplicant 1:2.5-3
> Toshiba Satellite, circa 2011, with a Pentium Dual-Core Mobile
> Error is not seen on other machines.
> 
> kernel: BUG: scheduling while atomic: wpa_supplicant/375/0x00000002

This is a kernel bug, not a wpa_supplicant bug.  The linux-wireless mailing
list would be a more appropriate venue for this bug report.


> May 19 10:26:07 lapis kernel: BUG: scheduling while atomic: wpa_supplicant/627/0x00000002
[...]
> May 19 10:26:07 lapis kernel:  [<ffffffff815c2b39>] __schedule+0x899/0xad0
> May 19 10:26:07 lapis kernel:  [<ffffffff815c2dac>] schedule+0x3c/0x90
> May 19 10:26:07 lapis kernel:  [<ffffffff815c5bb2>] schedule_hrtimeout_range_clock+0xa2/0x120
> May 19 10:26:07 lapis kernel:  [<ffffffff810e8b80>] ? hrtimer_init+0x120/0x120
> May 19 10:26:07 lapis kernel:  [<ffffffff815c5ba6>] ? schedule_hrtimeout_range_clock+0x96/0x120
> May 19 10:26:07 lapis kernel:  [<ffffffff815c5c43>] schedule_hrtimeout_range+0x13/0x20
> May 19 10:26:07 lapis kernel:  [<ffffffff815c568f>] usleep_range+0x4f/0x70
> May 19 10:26:07 lapis kernel:  [<ffffffffa0667218>] rtl_rfreg_delay+0x38/0x50 [rtlwifi]
> May 19 10:26:07 lapis kernel:  [<ffffffffa06dd0e7>] rtl92c_phy_config_rf_with_headerfile+0xc7/0xe0 [rtl8192ce]

[Probably due to this kernel change:

commit 49f86ec21c01b654f6ec47f2f4567f4f9ebaa26b
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Mon Feb 15 16:12:07 2016 -0600

    rtlwifi: Change long delays to sleeps


...apparently this function isn't in sleepable context after all.]

-- 
Bob Copeland %% http://bobcopeland.com/
