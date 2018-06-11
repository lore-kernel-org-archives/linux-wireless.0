Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933483AbeFKONP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 10:13:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Eyal Ilsar <eilsar@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        wcn36xx@lists.infradead.org
Subject: Re: [PATCH] wcn36xx: Remove Unicode Byte Order Mark from testcode
References: <1528375527-22761-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 11 Jun 2018 17:13:09 +0300
In-Reply-To: <1528375527-22761-1-git-send-email-geert@linux-m68k.org> (Geert
        Uytterhoeven's message of "Thu, 7 Jun 2018 14:45:27 +0200")
Message-ID: <877en5v2bu.fsf@kamboji.qca.qualcomm.com> (sfid-20180611_161336_056372_45B8C51D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Older gcc (< 4.4) doesn't like files starting with a Unicode BOM:
>
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray =E2=80=98=
\357=E2=80=99 in program
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray =E2=80=98=
\273=E2=80=99 in program
>     drivers/net/wireless/ath/wcn36xx/testmode.c:1: error: stray =E2=80=98=
\277=E2=80=99 in program
>
> Remove the BOM, the rest of the file is plain ASCII anyway.
>
> Output of "file drivers/net/wireless/ath/wcn36xx/testmode.c" before:
>
>     drivers/net/wireless/ath/wcn36xx/testmode.c: C source, UTF-8 Unicode =
(with BOM) text
>
> and after:
>
>     drivers/net/wireless/ath/wcn36xx/testmode.c: C source, ASCII text
>
> Fixes: 87f825e6e246cee0 ("wcn36xx: Add support for Factory Test Mode (FTM=
)")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

I'll queue this for 4.18.

--=20
Kalle Valo
