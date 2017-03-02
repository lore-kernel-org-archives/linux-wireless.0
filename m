Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754210AbdCBJAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Mar 2017 04:00:02 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v4] ath10k: search SMBIOS for OEM board file extension
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170224223003.32156-1-ext.waldemar.rymarkiewicz@tieto.com>
References: <20170224223003.32156-1-ext.waldemar.rymarkiewicz@tieto.com>
To: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
        jouni@qca.qualcomm.com,
        Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
Message-Id: <20170302085318.3FA5760D5B@smtp.codeaurora.org> (sfid-20170302_100023_146078_3BAEF815)
Date: Thu,  2 Mar 2017 08:53:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com> wrote:
> Board Data File (BDF) is loaded upon driver boot-up procedure. The right
> board data file is identified, among others, by device and sybsystem ids.
> 
> The problem, however, can occur when the (default) board data file cannot
> fulfill with the vendor requirements and it is necessary to use a different
> board data file.
> 
> To solve the issue QCA uses SMBIOS type 0xF8 to store Board Data File Name
> Extension to specify the extension/variant name. The driver will take the
> extension suffix into consideration and will load the right (non-default)
> board data file if necessary.
> 
> If it is unnecessary to use extension board data file, please leave the
> SMBIOS field blank and default configuration will be used.
> 
> Example:
> If a default board data file for a specific board is identified by a string
>       "bus=pci,vendor=168c,device=003e,subsystem-vendor=1028,
>        subsystem-device=0310"
> then the OEM specific data file, if used, could be identified by variant
> suffix:
>       "bus=pci,vendor=168c,device=003e,subsystem-vendor=1028,
>        subsystem-device=0310,variant=DE_1AB"
> 
> If board data file name extension is set but board-2.bin does not contain
> board data file for the variant, the driver will fallback to the default
> board data file not to break backward compatibility.
> 
> This was first applied in commit f2593cb1b291 ("ath10k: Search SMBIOS for OEM
> board file extension") but later reverted in commit 005c3490e9db ("Revert
> "ath10k: Search SMBIOS for OEM board file extension"") due to a regression.
> This patch is now otherwise the same as commit f2593cb1b291 except the
> regression fixed.
> 
> Signed-off-by: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>

Patch applied to wireless-drivers.git, thanks.

1657b8f84ed9 ath10k: search SMBIOS for OEM board file extension

-- 
https://patchwork.kernel.org/patch/9591335/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
