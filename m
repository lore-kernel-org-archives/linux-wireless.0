Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37606 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751247AbeAPTQh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Jan 2018 14:16:37 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [for-4.15] ssb: Disable PCI host for PCI_DRIVERS_GENERIC
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180115211714.24009-1-jhogan@kernel.org>
References: <20180115211714.24009-1-jhogan@kernel.org>
To: James Hogan <jhogan@kernel.org>
Cc: Michael Buesch <m@bues.ch>, linux-wireless@vger.kernel.org,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Paul Burton <paul.burton@mips.com>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Guenter Roeck <linux@roeck-us.net>
Message-Id: <20180116191636.9D85D60A08@smtp.codeaurora.org> (sfid-20180116_201640_874149_C7017AA6)
Date: Tue, 16 Jan 2018 19:16:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Hogan <jhogan@kernel.org> wrote:

> Since commit d41e6858ba58 ("MIPS: Kconfig: Set default MIPS system type
> as generic") changed the default MIPS platform to the "generic"
> platform, which uses PCI_DRIVERS_GENERIC instead of PCI_DRIVERS_LEGACY,
> various files in drivers/ssb/ have failed to build.
> 
> This is particularly due to the existence of struct pci_controller being
> dependent on PCI_DRIVERS_LEGACY since commit c5611df96804 ("MIPS: PCI:
> Introduce CONFIG_PCI_DRIVERS_LEGACY"), so add that dependency to Kconfig
> to prevent these files being built for the "generic" platform including
> all{yes,mod}config builds.
> 
> Fixes: c5611df96804 ("MIPS: PCI: Introduce CONFIG_PCI_DRIVERS_LEGACY")
> Signed-off-by: James Hogan <jhogan@kernel.org>
> Cc: Michael Buesch <m@bues.ch>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Paul Burton <paul.burton@mips.com>
> Cc: Matt Redfearn <matt.redfearn@imgtec.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-wireless@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Patch applied to wireless-drivers.git, thanks.

58eae1416b80 ssb: Disable PCI host for PCI_DRIVERS_GENERIC

-- 
https://patchwork.kernel.org/patch/10165371/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
