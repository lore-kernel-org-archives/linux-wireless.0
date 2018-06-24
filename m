Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35167 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751876AbeFXOLK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Jun 2018 10:11:10 -0400
Received: by mail-wm0-f68.google.com with SMTP id z137-v6so1501523wmc.0
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jun 2018 07:11:10 -0700 (PDT)
MIME-Version: 1.0
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com> <1529693004-20569-7-git-send-email-arend.vanspriel@broadcom.com>
In-Reply-To: <1529693004-20569-7-git-send-email-arend.vanspriel@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sun, 24 Jun 2018 16:08:59 +0200
Message-ID: <CACna6rxi88e6oek8zt_7KG6PY4ih_ehpsd67hK2DXGHKQZhSSg@mail.gmail.com> (sfid-20180624_161143_390809_0ACCB2A6)
Subject: Re: [PATCH 6/6] brcmfmac: fallback mechanism to determine monitor
 mode features
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jun 2018 at 20:45, Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> Firmwares may not provide all monitor mode features in the "cap" iovar.
> For those this fallback mechanism uses "sta_monitor" iovar. If firmware
> is compiled with stamon, this iovar will fail with BCME_NOTUP; Otherwise
> it fails with BCME_UNSUPPORTED.

It's probably not the first time ever, but it appears your research
(theory) doesn't match my experience (practice) ;) I'm afraid you
missed some important check when analyzing firmware code.

I've just tested all firmwares I got (for 43602a1, 4366b1 and 4366c0)
and all of them return -4 (BCME_NOTUP) for "sta_monitor" when
firmware/interface is down. It appears this test requires bringing
firmware/interface up to make it reliable. Apparently even firmwares
*without* sta_monitor return -4 (BCME_NOTUP) when firmware/interface
is down.

--=20
Rafa=C5=82
