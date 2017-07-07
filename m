Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:36774 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750726AbdGGMrE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 08:47:04 -0400
Received: by mail-ua0-f193.google.com with SMTP id g40so2268178uaa.3
        for <linux-wireless@vger.kernel.org>; Fri, 07 Jul 2017 05:47:04 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1499428893-30750-1-git-send-email-arend.vanspriel@broadcom.com>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Fri, 7 Jul 2017 14:47:03 +0200
Message-ID: <CA+icZUXVEBQzau4d36iO1vvhioX_WM8AH-iw=Tv+vUcVBtUeWw@mail.gmail.com> (sfid-20170707_144707_748470_D4A63E7B)
Subject: Re: [PATCH] brcmfmac: fix possible buffer overflow in brcmf_cfg80211_mgmt_tx()
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 7, 2017 at 2:01 PM, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> The lower level nl80211 code in cfg80211 ensures that "len" is between
> 25 and NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN (24) fr=
om
> "len" so thats's max of 2280.  However, the action_frame->data[] buffer i=
s
> only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy() can
> overflow.
>
>         memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
>                le16_to_cpu(action_frame->len));
>
> Reported-by: "freenerguo(=E9=83=AD=E5=A4=A7=E5=85=B4)" <freenerguo@tencen=
t.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> Hi Kalle,
>
> Here is the patch as Linus send it to us and security@kernel.org. I
> removed the lower bound check as that is already done in cfg80211.
> Now I signed off on the patch although formally I suppose Linus should
> sign it off. Putting it out there so people can respond as deemed
> necessary.
>
> Now fingers crossed whether patchwork will properly deal with the UTF-8
> characters :-p
>

Somehow horrific to see - less in usage (no CC here).

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/=
?qt=3Dgrep&q=3Dsecurity%40kernel.org
