Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966243AbeEYMFT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 08:05:19 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Maya Erez <merez@codeaurora.org>
Cc: Gidon Studinski <gidons@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 2/7] wil6210: add support for enhanced DMA structures
References: <1526227375-31881-1-git-send-email-merez@codeaurora.org>
        <1526227375-31881-3-git-send-email-merez@codeaurora.org>
Date: Fri, 25 May 2018 15:05:16 +0300
In-Reply-To: <1526227375-31881-3-git-send-email-merez@codeaurora.org> (Maya
        Erez's message of "Sun, 13 May 2018 19:02:50 +0300")
Message-ID: <87r2m0kkjn.fsf@purkki.adurom.net> (sfid-20180525_140527_482143_BA6D3B1F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maya Erez <merez@codeaurora.org> writes:

> From: Gidon Studinski <gidons@codeaurora.org>
>
> In enhanced DMA the vrings are handled internally by the FW
> and are not exposed to the driver.
> Instead, the driver handles descriptor rings, which are mapped
> by the FW to vrings.
> The completions of the TX and RX descriptors are notified to
> the driver using status rings. Each status ring descriptor
> includes information of the completed descriptors and the ring id
> of their descriptor ring.
>
> This patch changes struct vring to generic wil_ring to allow
> its reuse for enhanced DMA descriptor rings and adds the descriptor
> and status rings specific descriptors.
>
> Signed-off-by: Gidon Studinski <gidons@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

[...]

> @@ -1784,7 +1785,7 @@ static void wil6210_debugfs_init_blobs(struct wil6210_priv *wil,
>  	const struct file_operations *fops;
>  } dbg_files[] = {
>  	{"mbox",	0444,		&fops_mbox},
> -	{"vrings",	0444,		&fops_vring},
> +	{"rings",	0444,		&fops_ring},

When making changes to the debugfs interface please document that in the
in commit log and how the changes look from user space point of view.
Doesn't need to be long but just some sort of overview so that the
reader understands the changes without looking at the code.

-- 
Kalle Valo
