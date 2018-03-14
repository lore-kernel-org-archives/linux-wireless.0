Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:42933 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932680AbeCNBjG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 21:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKDA=L5E6Cu_oRe-M=ouuhrccCZHyM+z6_UMAUqe9xnRQ@mail.gmail.com>
References: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com>
 <5AA464DE.90100@broadcom.com> <CAGXu5jKDA=L5E6Cu_oRe-M=ouuhrccCZHyM+z6_UMAUqe9xnRQ@mail.gmail.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Wed, 14 Mar 2018 02:38:45 +0100
Message-ID: <CANiq72=W0=DwZq_SGAHTnbvofPPKUgSOXhJtHDj0CReu5d17hw@mail.gmail.com> (sfid-20180314_023914_314560_7136D8E7)
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9: dfs: remove VLA usage
To: Kees Cook <keescook@chromium.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Andreas Christoforou <andreaschristofo@gmail.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 11, 2018 at 12:12 AM, Kees Cook <keescook@chromium.org> wrote:
>
> The problem is that it's not a "constant expression", so the compiler
> frontend still yells about it under -Wvla. I would characterize this
> mainly as a fix for "accidental VLA" or "misdetected VLA" or something
> like that. AIUI, there really isn't a functional change here.

C++11's constexpr variables would be nice to have.

Cheers,
Miguel
