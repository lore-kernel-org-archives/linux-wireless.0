Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53684 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbbE1I3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 04:29:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: brcmfmac: fix invalid access to struct acpi_device fields
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1432747901-8472-1-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>,
	"Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
Message-Id: <20150528082929.34ED7140394@smtp.codeaurora.org> (sfid-20150528_102949_871635_400A9819)
Date: Thu, 28 May 2015 08:29:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The fields of struct acpi_device are only known when CONFIG_ACPI is
> defined. Fix this by using a helper function. This will resolve the
> issue found in linux-next:
> 
>  ../brcmfmac/bcmsdh.c: In function 'brcmf_ops_sdio_probe':
>  ../brcmfmac/bcmsdh.c:1139:7: error: dereferencing pointer to incomplete type
>    adev->flags.power_manageable = 0;
>        ^
> 
> Fixes: f0992ace680c ("brcmfmac: prohibit ACPI power management ...")
> Cc: Fu, Zhonghui <zhonghui.fu@linux.intel.com>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
