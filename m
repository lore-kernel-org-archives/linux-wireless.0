Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:52242 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbdIRPOp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 11:14:45 -0400
Received: by mail-io0-f173.google.com with SMTP id i197so2878184ioe.9
        for <linux-wireless@vger.kernel.org>; Mon, 18 Sep 2017 08:14:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1505746857-31938-4-git-send-email-kvalo@qca.qualcomm.com>
References: <1505746857-31938-1-git-send-email-kvalo@qca.qualcomm.com> <1505746857-31938-4-git-send-email-kvalo@qca.qualcomm.com>
From: Matteo Croce <mcroce@redhat.com>
Date: Mon, 18 Sep 2017 17:14:04 +0200
Message-ID: <CAGnkfhw1bGxD7Z4B=i_xtRJAD5ph_YxEcW0y2F5RTXfPrDkd0A@mail.gmail.com> (sfid-20170918_171449_535892_E3416545)
Subject: Re: [PATCH 3/3] Revert "ath10k: QCA988X hw2.0: update firmware to 10.2.4.70.63-2"
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 18, 2017 at 5:00 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> This reverts commit c7370e2728c72e5e87f63a48911a925330485a8e.
>
> 10.2.4.70.63-2 was buggy and lots of people have been reporting crashes, Hauke
> Mehrtens among others:
>
> http://lists.infradead.org/pipermail/ath10k/2017-September/010138.html
>
> This reverts the firmware back to 10.2.4.70.54.
> ---
>  WHENCE                              |   2 +-
>  ath10k/QCA988X/hw2.0/firmware-5.bin | Bin 249384 -> 248188 bytes
>  2 files changed, 1 insertion(+), 1 deletion(-)
>

I can confirm that it crashes on insmod:

https://bugzilla.kernel.org/show_bug.cgi?id=196919

-- 
Matteo Croce
per aspera ad upstream
