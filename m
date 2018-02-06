Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:38559 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752566AbeBFNNk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Feb 2018 08:13:40 -0500
Received: by mail-qt0-f170.google.com with SMTP id z10so2173947qti.5
        for <linux-wireless@vger.kernel.org>; Tue, 06 Feb 2018 05:13:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHbf0-Eb3=OgpDLhgacYP4hcffh_9Y-iUj0GQAbzj2O9ag=z0A@mail.gmail.com>
References: <CAHbf0-Eb3=OgpDLhgacYP4hcffh_9Y-iUj0GQAbzj2O9ag=z0A@mail.gmail.com>
From: Mike Lothian <mike@fireburn.co.uk>
Date: Tue, 6 Feb 2018 13:13:19 +0000
Message-ID: <CAHbf0-Hrq=2XGVPukEppm+n2Yg8x1UBXqk53io==27NzZK_s9w@mail.gmail.com> (sfid-20180206_141344_329326_0E21DF75)
Subject: Re: Regression in ath10k
To: linux-wireless@vger.kernel.org, yanhsu@codeaurora.org,
        valo@codeaurora.org, "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5 February 2018 at 22:38, Mike Lothian <mike@fireburn.co.uk> wrote:
> Hi
>
> Since the merge window opened I've been unable to see any wireless
> networks or join my usual access point
>
> I bisected this to:
>
> 9ed4f91628737c820af6a1815b65bc06bd31518f is the first bad commit
> commit 9ed4f91628737c820af6a1815b65bc06bd31518f
> Author: Ryan Hsu <ryanhsu@codeaurora.org>
> Date:   Tue Jan 16 11:43:49 2018 +0200
>
>    ath10k: add sanity check to ie_len before parsing fw/board ie
>
>    Validate ie_len after the alignment padding before access the buffer
>    to avoid potential overflow.
>
>    Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
>    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>
> And I can confirm that reverting the patch makes things work again (attached)
>
> Device:
>
> 3c:00.0 Network controller [0280]: Qualcomm Atheros QCA6174 802.11ac
> Wireless Network Adapter [168c:003e] (rev 32)
>
> Firmware:
>
> https://github.com/kvalo/ath10k-firmware
>
> ath10k-firmware/QCA6174/hw3.0/4.4.1.c1
>
> There was nothing obvious in the dmesg
>
> Regards
>
> Mike

Adding in the ath10k list and another email address for Kalle
