Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:56422 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbaDEPtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Apr 2014 11:49:03 -0400
Received: by mail-ob0-f181.google.com with SMTP id wp4so4709094obc.26
        for <linux-wireless@vger.kernel.org>; Sat, 05 Apr 2014 08:49:02 -0700 (PDT)
Message-ID: <534025EC.6030600@lwfinger.net> (sfid-20140405_174939_346020_3C318D56)
Date: Sat, 05 Apr 2014 10:49:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
CC: b43-dev@lists.infradead.org
Subject: Re: [PATCH][FIX 3.15] b43: N-PHY: access B43_MMIO_PSM_PHY_HDR using
 16b ops
References: <1396708524-12199-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1396708524-12199-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2014 09:35 AM, Rafał Miłecki wrote:
> Register B43_MMIO_PSM_PHY_HDR is 16 bit one, so accessing it with 32b
> functions isn't safe. On my machine it causes delayed (!) CPU exception:
>
> Disabling lock debugging due to kernel taint
> mce: [Hardware Error]: CPU 0: Machine Check Exception: 4 Bank 4: b200000000070f0f
> mce: [Hardware Error]: TSC 164083803dc
> mce: [Hardware Error]: PROCESSOR 2:20fc2 TIME 1396650505 SOCKET 0 APIC 0 microcode 0
> mce: [Hardware Error]: Run the above through 'mcelog --ascii'
> mce: [Hardware Error]: Machine check: Processor context corrupt
> Kernel panic - not syncing: Fatal machine check on current CPU
> Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> John: I think this patch it worth picking for 3.15 release. This bug
> causes instability and can be triggered depending on the default state
> of B43_NPHY_BANDCTL register.
> It doesn't cause exception immediately, so I spent few hours tracing it.
> ---

I agree that this is a BUG fix that should be in 3.15, *and* in all stable 
versions to which it would apply.

To aid John, I suggest that a better subject would be something like "b43: Fix 
machine check error due to improper access of B43_MMIO_PSM_PHY_HDR". That makes 
it more obvious that a bug is being fixed. In addition, you should add a "Cc: 
Stable <stable@vger.kernel.org> [2.6.35+]".

As I rarely run an 802.11n Broadcom device, it is unlikely that I have 
encountered this problem, but your evidence is convincing. Once the subject and 
Cc are changed, then Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Larry

