Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:44035 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753250AbdIIHpj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Sep 2017 03:45:39 -0400
Received: by mail-wm0-f48.google.com with SMTP id 137so10490498wmj.1
        for <linux-wireless@vger.kernel.org>; Sat, 09 Sep 2017 00:45:38 -0700 (PDT)
Subject: Re: [PATCH 1/3] brcmfmac: Avoid possible out-of-bounds read
To: Kevin Cernekee <cernekee@chromium.org>, franky.lin@broadcom.com
Cc: brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, mnissler@chromium.org
References: <20170908191342.28053-1-cernekee@chromium.org>
 <20170908191342.28053-2-cernekee@chromium.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <be986d32-dabc-2638-3d38-abe85df4a5b8@broadcom.com> (sfid-20170909_094555_035556_2B11A22A)
Date: Sat, 9 Sep 2017 09:45:35 +0200
MIME-Version: 1.0
In-Reply-To: <20170908191342.28053-2-cernekee@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08-09-17 21:13, Kevin Cernekee wrote:
> In brcmf_p2p_notify_rx_mgmt_p2p_probereq(), chanspec is assigned before
> the length of rxframe is validated.  This could lead to uninitialized
> data being printed in a debug message.  Since we already have a

The debug message is after the length validation so there is not 
unintialized data being printed.

> perfectly good endian-swapped copy of rxframe->chanspec in ch.chspec,
> and ch.chspec is not modified by decchspec(), avoid the extra
> assignment and use ch.chspec in the debug print.

However, there is no real for the chanspec variable for the given reason 
so...

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
