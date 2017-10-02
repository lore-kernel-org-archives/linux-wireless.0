Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46226 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750929AbdJBMq7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Oct 2017 08:46:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V3,3/3] brcmfmac: Add check for short event packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170917040824.22237-3-cernekee@chromium.org>
References: <20170917040824.22237-3-cernekee@chromium.org>
To: Kevin Cernekee <cernekee@chromium.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Message-Id: <20171002124659.074B7607CE@smtp.codeaurora.org> (sfid-20171002_144506_951136_9A6C6A1F)
Date: Mon,  2 Oct 2017 12:46:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kevin Cernekee <cernekee@chromium.org> wrote:

> The length of the data in the received skb is currently passed into
> brcmf_fweh_process_event() as packet_len, but this value is not checked.
> event_packet should be followed by DATALEN bytes of additional event
> data.  Ensure that the received packet actually contains at least
> DATALEN bytes of additional data, to avoid copying uninitialized memory
> into event->data.
> 
> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>

I'll queue this for v4.14 and add:

Cc: stable@vger.kernel.org # v3.8

-- 
https://patchwork.kernel.org/patch/9954607/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
