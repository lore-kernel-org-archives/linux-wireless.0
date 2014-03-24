Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58988 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCXLti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 07:49:38 -0400
Received: by mail-pb0-f54.google.com with SMTP id ma3so5392417pbc.27
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 04:49:38 -0700 (PDT)
Date: Mon, 24 Mar 2014 19:49:23 +0800
From: Adam Lee <adam.lee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Subject: Re: [PATCH] rtlwifi: add MSI interrupts support
Message-ID: <20140324114923.GA3650@adam-laptop> (sfid-20140324_124947_506421_A6DD7DC6)
References: <1395640841-14477-1-git-send-email-adam.lee@canonical.com>
 <1395660884-15042-1-git-send-email-adam.lee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395660884-15042-1-git-send-email-adam.lee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2014 at 07:34:44PM +0800, Adam Lee wrote:
> Add MSI interrupts support, enable it when msi_support flag is true,
> also could fallback to pin-based interrupts mode if MSI mode fails.
> 
> Signed-off-by: Adam Lee <adam.lee@canonical.com>
> ---
>  drivers/net/wireless/rtlwifi/pci.c | 63 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 61 insertions(+), 2 deletions(-)

This is the base of "[PATCH] rtlwifi: rtl8188ee: enable MSI interrupts
support" in thread. We met this issue[1] while enabling some HP
notebooks, whose wifi hardware modules can't get AP scan results with
pin-based interrupts.

Submitting these two patches ahead of RealTek's schedule so we can fix
it sooner for non-preload distro users.

[1] https://bugs.launchpad.net/bugs/1296591

-- 
Adam Lee
