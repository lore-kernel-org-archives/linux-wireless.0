Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:44551 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbdKNKhT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 05:37:19 -0500
Received: by mail-wr0-f176.google.com with SMTP id u97so17088243wrc.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Nov 2017 02:37:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171112200645.26284-1-Larry.Finger@lwfinger.net>
References: <20171112200645.26284-1-Larry.Finger@lwfinger.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 14 Nov 2017 21:36:58 +1100
Message-ID: <CAGRGNgXFXvHVnuBKPNHBfThQcb6CYTnsgvWHy5Cz8wb=Vx8G7g@mail.gmail.com> (sfid-20171114_113726_485372_B9FC909B)
Subject: Re: [PATCH] rtlwifi: Convert individual interrupt results to struct
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

On Mon, Nov 13, 2017 at 7:06 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> With the RTL8822BE and later devices, the number of interrupt vectors
> has grown from 2 to 4. At this point, saving and passing those vectors
> in a struct makes more sense than using individual scaler variables.
>
> In two of the drivers, code to process the second of the interrupt
> registers was included, but commented out. This patch removes those
> useless sections.

Does Linux actually distinguish between these interrupts - and if not
would it be sane to just use an array of u32s instead?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
