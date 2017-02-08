Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48484 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754485AbdBHPZl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:25:41 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: rtlwifi: Move items out of rtl_pci_priv and rtl_usb_priv
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170207151421.32559-1-Larry.Finger@lwfinger.net>
References: <20170207151421.32559-1-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-Id: <20170208152540.A01E960588@smtp.codeaurora.org> (sfid-20170208_162743_496722_52084419)
Date: Wed,  8 Feb 2017 15:25:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In commit 6773386f977c ("rtlwifi: rtl8192c-common: Fix "BUG: KASAN:"),
> a BUG detected when CONFIG_KASAN=y was fixed by reordering the layouts
> of struct rtl_pci_priv, and struct rtl_usb_priv so that the variables
> used by both PCI and USB drivers have the same offsets in both structs.
> The better fix of relocating the critical variables into struct rtl_priv
> was deferred as these changes do not have to be applied to stable
> kernels.
> 
> This change also removes CamelCase variables with pLed0 => pled0.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

Patch applied to wireless-drivers-next.git, thanks.

d5efe1535af0 rtlwifi: Move items out of rtl_pci_priv and rtl_usb_priv

-- 
https://patchwork.kernel.org/patch/9560369/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
