Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:46380 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751135AbeCJXoh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 18:44:37 -0500
MIME-Version: 1.0
In-Reply-To: <5AA464DE.90100@broadcom.com>
References: <1520598613-3641-1-git-send-email-andreaschristofo@gmail.com> <5AA464DE.90100@broadcom.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Sat, 10 Mar 2018 18:44:35 -0500
Message-ID: <CA+DvKQ+hbMoWJdOuQB5n+eVF4ePf=kVuRiMbdtTUZ8ars4Pz4A@mail.gmail.com> (sfid-20180311_004502_229360_1A74CFAD)
Subject: Re: [PATCH] drivers: net: wireless: ath: ath9: dfs: remove VLA usage
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Andreas Christoforou <andreaschristofo@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Just wondering. Is this actually a VLA. FFT_NUM_SAMPLES was static const so
> not really going to show a lot of variation. This array will always have the
> same size on the stack.

The issue is that unlike in C++, a `static const` can't be used in a
constant expression in C. It's unclear why C is defined that way but
it's how it is and there isn't currently a GCC extension making more
things into constant expressions like C++.
