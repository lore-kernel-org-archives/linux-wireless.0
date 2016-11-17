Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41360 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753493AbcKQK6G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 05:58:06 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 2/5] rsi: Added rx filter frame
References: <1479125812-2666-1-git-send-email-prameela.j04cs@gmail.com>
Date: Thu, 17 Nov 2016 12:58:01 +0200
In-Reply-To: <1479125812-2666-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Mon, 14 Nov 2016 17:46:52
        +0530")
Message-ID: <87inrmpe4m.fsf@purkki.adurom.net> (sfid-20161117_115818_055633_45D3F1D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> Filtering the rx frames in firmware after connection in station mode
> avoids the overhead of processing un-necessary frames. Hence rx filter
> frame is added which can be configured to device at suitable times.
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

A minor nitpick about the patch title. As I slept through most of my
english classes I don't know the correct terminology but the common
style is to use form "rsi: add foo", not "rsi: added foo".

> +/**
> + * This function sends a frame to filter the RX packets
> + *
> + * @param common Pointer to the driver private structure.
> + * @param rx_filter_word - Flags of filter packets
> + * @return 0 on success, -1 on failure.
> + */
> +int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word)

Based on Documentation/kernel-documentation.rst this doesn't look to be
valid kernel-doc format. But AFAICS you got the format correct in patch
3.

Also this function uses negative error codes (as preferred), it's not
just -1 on failure. You should fix that in the comment (similar problems
also elsewhere in this patchset).

Personally I would not even bother adding kernel-docs for driver
internal functions. It's a lot of work to maintain them and still they
are quite often outdated, so people can't trust them and need to check
from the source anyway. But if you like them feel free to continue
adding them.

-- 
Kalle Valo
