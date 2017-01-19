Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54582 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdASMrW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 07:47:22 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rtlwifi: Download firmware as bytes rather than as dwords
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170109230058.22758-2-Larry.Finger@lwfinger.net>
References: <20170109230058.22758-2-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>
Message-Id: <20170119124721.74AD860912@smtp.codeaurora.org> (sfid-20170119_134725_241731_8D3C698B)
Date: Thu, 19 Jan 2017 12:47:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The firmware is read from disk as a little-endian byte string. The code
> that loads the firmware into the device transfers it as 4-byte quantities.
> The routines that write multi-byte quantities on BE hardware assume that
> the data are in CPU order, and automatically do the conversion to the LE
> order required by the device. As a result, the firmware is transmitted
> incorrectly. Rather than do multiple byte swaps on the data, the download
> routine is revised to transmit bytes rather than dwords. Although the
> number of I/O operations is increased, the firmware is not often loaded.
> 
> All drivers have the same bug, and use essentially the same code to
> download firmware. These routines have been moved into rtlwifi.
> 
> Some CamelCase variables have been renamed.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/realtek/rtlwifi/efuse.c).
error: could not build fake ancestor
Applying: rtlwifi: Download firmware as bytes rather than as dwords
Patch failed at 0001 rtlwifi: Download firmware as bytes rather than as dwords
The copy of the patch that failed is found in: .git/rebase-apply/patch

3 patches set to Changes Requested.

9506051 [1/3] rtlwifi: Download firmware as bytes rather than as dwords
9506053 [2/3] rtlwifi: rtl8192cu: Calculate descriptor checksum correctly for BE
9506055 [3/3] rtlwifi: rtl8192cu: Convert driver to use common macros

-- 
https://patchwork.kernel.org/patch/9506051/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
