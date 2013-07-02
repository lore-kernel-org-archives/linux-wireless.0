Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61194 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125Ab3GBPwj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 11:52:39 -0400
Received: by mail-ob0-f178.google.com with SMTP id fb19so5838679obc.9
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jul 2013 08:52:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130701121929.GB1747@redhat.com>
References: <20130701121929.GB1747@redhat.com>
Date: Tue, 2 Jul 2013 08:52:38 -0700
Message-ID: <CANn89i+rA8MH90Gdn5RMvrwNV36uc0CX3O7MxEuD6rL+32Ck9A@mail.gmail.com> (sfid-20130702_175242_788721_C10D131A)
Subject: Re: [PATCH] iwl4965: better skb management in rx path
From: Eric Dumazet <edumazet@google.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 1, 2013 at 5:19 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 4965 version of Eric patch "iwl3945: better skb management in rx path".
> It fixes several problems :
>
> 1) skb->truesize is underestimated.
>    We really consume PAGE_SIZE bytes for a fragment,
>    not the frame length.
> 2) 128 bytes of initial headroom is a bit low and forces reallocations.
> 3) We can avoid consuming a full page for small enough frames.
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlegacy/4965-mac.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>

Acked-by: Eric Dumazet <edumazet@google.com>
