Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:9165 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756091AbdLVPzp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:55:45 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 00/11] ath10k high latency
Date: Fri, 22 Dec 2017 15:55:40 +0000
Message-ID: <87r2rm92pw.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_165549_424573_B169C715)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-1-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:02 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> This is the third version of the high latency patches (stuff common for
> usb and sdio).

Sorry for the late review, this fall I have had difficulties to keep up
with all the patches. This set looks pretty good, I had few smaller
comments but nothing major really.

> One major difference between this version and the previous is that the
> num_pending_tx counter has been disabled for high latency devices (last p=
atch).
>
> This fixes the previous issue with the halted USB RX.
> I have tested these patches with a Linksys WUSB6100M and it looks
> much better than the previous version.

I quickly tested this set few weeks ago on my test laptop and the kernel
was crashing a lot, I don't know was it because I usually try to run all
kernel debug features enabled or what. I don't have the logs at hand
right now. I think we should try to investigate that before adding the
hw_params entry for the usb device, but rest of the patches in this set
can go in even before. Most important is that we don't create any
regressions (including kernel crashes).

--=20
Kalle Valo=
