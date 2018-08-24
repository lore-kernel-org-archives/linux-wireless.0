Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59482 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbeHXLyO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 07:54:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: Fix comparisons with invalid hardware key index
In-Reply-To: <20180824080817.GA6651@redhat.com> (Stanislaw Gruszka's message
        of "Fri, 24 Aug 2018 10:08:18 +0200")
References: <20180823212738.18431-1-geert@linux-m68k.org>
        <20180824080817.GA6651@redhat.com>
Date: Fri, 24 Aug 2018 11:20:35 +0300
Message-ID: <87pny8jhv0.fsf@kamboji.qca.qualcomm.com> (sfid-20180824_102052_956278_4CD4A5C4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Thu, Aug 23, 2018 at 11:27:38PM +0200, Geert Uytterhoeven wrote:
>> With gcc 4.1.2:
>>=20
>>     drivers/net/wireless/mediatek/mt76/mt76x0/tx.c: In function =E2=80=
=98mt76x0_tx=E2=80=99:
>>     drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:169: warning:
>> comparison is always true due to limited range of data type
>>     drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c: In function =
=E2=80=98mt76x2_tx=E2=80=99:
>>     drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c:35:
>> warning: comparison is always true due to limited range of data type
>>=20
>> While assigning -1 to a u8 works fine, comparing with -1 does not work
>> as expected.
>>=20
>> Fix this by comparing with 0xff, like is already done in some other
>> places.
>>=20
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> Ack for mt76x0. I think Lorenzo already posted patch for mt76x2.

Yeah, Lorenzo's patch is here:

https://patchwork.kernel.org/patch/10570555/

As Geert's patch seems to be more complete I'm planning to take Geert's
version.

--=20
Kalle Valo
