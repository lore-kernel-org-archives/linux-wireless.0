Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58205 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdA0Ta1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jan 2017 14:30:27 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] ath10k: Search SMBIOS for OEM board file extension
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170117150334.8859-1-ext.waldemar.rymarkiewicz@tieto.com>
References: <20170117150334.8859-1-ext.waldemar.rymarkiewicz@tieto.com>
To: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>
CC: <ath10k@lists.infradead.org>, <alanliu@qca.qualcomm.com>,
        <rwchang@qti.qualcomm.com>, <linux-wireless@vger.kernel.org>,
        "Waldemar Rymarkiewicz" <ext.waldemar.rymarkiewicz@tieto.com>,
        <bartosz.markowski@tieto.com>
Message-ID: <c57e3b178364400c914677dc577753ae@eusanexr01a.eu.qualcomm.com> (sfid-20170127_203140_039020_ABDF16C0)
Date: Fri, 27 Jan 2017 11:30:21 -0800
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
> Signed-off-by: Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>

Patch applied to ath-next branch of ath.git, thanks.

f2593cb1b291 ath10k: Search SMBIOS for OEM board file extension

-- 
https://patchwork.kernel.org/patch/9521307/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
