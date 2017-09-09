Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:45866 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757224AbdIIIOq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Sep 2017 04:14:46 -0400
Received: by mail-wm0-f47.google.com with SMTP id f199so14645509wme.0
        for <linux-wireless@vger.kernel.org>; Sat, 09 Sep 2017 01:14:45 -0700 (PDT)
Subject: Re: [PATCH 3/3] brcmfmac: Add check for short event packets
To: Kevin Cernekee <cernekee@chromium.org>, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
References: <20170908191342.28053-1-cernekee@chromium.org>
 <20170908191342.28053-4-cernekee@chromium.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <74c0eedb-f9b9-ad9a-a1ae-315cee7603d4@broadcom.com> (sfid-20170909_101555_550715_61069433)
Date: Sat, 9 Sep 2017 10:14:44 +0200
MIME-Version: 1.0
In-Reply-To: <20170908191342.28053-4-cernekee@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08-09-17 21:13, Kevin Cernekee wrote:
> The length of the data in the received skb is currently passed into
> brcmf_fweh_process_event() as packet_len, but this value is not checked.
> event_packet should be followed by DATALEN bytes of additional event
> data.  Ensure that the received packet actually contains at least
> DATALEN bytes of additional data, to avoid copying uninitialized memory
> into event->data.

Franky made an almost identical change which I had queued up for 
submission. So you beat us to it ;-)

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
