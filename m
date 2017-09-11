Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:38230 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdIKJTv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Sep 2017 05:19:51 -0400
Received: by mail-it0-f54.google.com with SMTP id c195so16645243itb.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Sep 2017 02:19:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170908191342.28053-4-cernekee@chromium.org>
References: <20170908191342.28053-1-cernekee@chromium.org> <20170908191342.28053-4-cernekee@chromium.org>
From: Mattias Nissler <mnissler@chromium.org>
Date: Mon, 11 Sep 2017 11:19:29 +0200
Message-ID: <CAKUbbx+=VpRC0nek=431yxjooun56hb6svSwRjH_faBhdEPf=g@mail.gmail.com> (sfid-20170911_111954_972444_472DE73B)
Subject: Re: [PATCH 3/3] brcmfmac: Add check for short event packets
To: Kevin Cernekee <cernekee@chromium.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        brcm80211-dev-list.pdl@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 8, 2017 at 9:13 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
>
> The length of the data in the received skb is currently passed into
> brcmf_fweh_process_event() as packet_len, but this value is not checked.
> event_packet should be followed by DATALEN bytes of additional event
> data.  Ensure that the received packet actually contains at least
> DATALEN bytes of additional data, to avoid copying uninitialized memory
> into event->data.
>
> Suggested-by: Mattias Nissler <mnissler@chromium.org>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> index 5aabdc9ed7e0..4cad1f0d2a82 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> @@ -429,7 +429,8 @@ void brcmf_fweh_process_event(struct brcmf_pub *drvr,
>         if (code != BRCMF_E_IF && !fweh->evt_handler[code])
>                 return;
>
> -       if (datalen > BRCMF_DCMD_MAXLEN)
> +       if (datalen > BRCMF_DCMD_MAXLEN ||
> +           datalen + sizeof(*event_packet) < packet_len)

Shouldn't this check be larger-than, i.e. we need the packet to be at
least sizeof(*event_packet) + its payload size?

>                 return;
>
>         if (in_interrupt())
> --
> 2.14.1.581.gf28d330327-goog
>
