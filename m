Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:55360 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbeICTvY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Sep 2018 15:51:24 -0400
Received: by mail-it0-f66.google.com with SMTP id d10-v6so1548827itj.5
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2018 08:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <1535970381-5526-1-git-send-email-sgruszka@redhat.com> <87y3cisq5g.fsf@purkki.adurom.net>
In-Reply-To: <87y3cisq5g.fsf@purkki.adurom.net>
From: Sid Hayn <sidhayn@gmail.com>
Date: Mon, 3 Sep 2018 15:30:33 +0000
Message-ID: <CAM0KTbDXMkDJruOoD=rfGanUv9wKZLUvESm=7ZtRNxhpJ8wEGA@mail.gmail.com> (sfid-20180903_173048_225675_6EE59981)
Subject: Re: [PATCH 4.19] mt76x0: fix remove_interface
To: Kalle Valo <kvalo@codeaurora.org>
Cc: sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Best I can say is that it seemed to happen after a failed connection.
It would connect and disconnect a few times and work fine, but if it
failed to connect for any reason (mostly mismatched settings between
AP and wpa_supplicant.conf) then the bug would occur. So,
wpa_supplicant would up the interface, try to connect, fail, down the
interface and exit, then the next loop of my script (with a different
conf file) would start and wpa_supplicant would be unable to up the
interface.

Hope that made any sense, because it didn't to me :-)

-Zero
On Mon, Sep 3, 2018 at 12:48 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
>
> > We wrongly use wcid_mask instead of vif_mask
> >
> > Fixes: 95e444098a7b ("mt76x0: main file")
> > Reported-and-tested-by: Sid Hayn <sidhayn@gmail.com>
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>
> For bug fixes please always try to describe the bug and symptoms. I can
> add it this time. From the other thread I saw that 'ifconfig up' failed
> like this:
>
> SIOCSIFFLAGS: No space left on device
>
> But in what cases did that happen? (I assume not always)
>
> --
> Kalle Valo
