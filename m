Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbdILHpa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Sep 2017 03:45:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,3/3] brcmfmac: Add check for short event packets
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170909193020.19061-3-cernekee@chromium.org>
References: <20170909193020.19061-3-cernekee@chromium.org>
To: Kevin Cernekee <cernekee@chromium.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
Message-Id: <20170912074530.10A50607DC@smtp.codeaurora.org> (sfid-20170912_094534_083573_E3028E2C)
Date: Tue, 12 Sep 2017 07:45:30 +0000 (UTC)
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
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

I'll queue this for v4.14 and add:

Cc: stable@vger.kernel.org # v3.8+

-- 
https://patchwork.kernel.org/patch/9945427/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
