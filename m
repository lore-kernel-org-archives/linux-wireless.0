Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752954AbeCMNfY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 09:35:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Andres Rodriguez <andresx7@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>, luciano.coelho@intel.com
Subject: Re: [PATCH] firmware: add a function to load optional firmware v2
References: <20180309221243.15489-2-andresx7@gmail.com>
        <20180309230925.3573-1-andresx7@gmail.com>
        <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com>
        <CAB=NE6XpY4LuDwnakCa6gZ_HjjhZDnu=gDeHwmpNRaSkqQOB2g@mail.gmail.com>
        <bbdc304f-edd5-38df-ea88-012fefc54b90@gmail.com>
        <5AA5B777.5020106@broadcom.com>
Date: Tue, 13 Mar 2018 15:35:18 +0200
In-Reply-To: <5AA5B777.5020106@broadcom.com> (Arend van Spriel's message of
        "Mon, 12 Mar 2018 00:10:47 +0100")
Message-ID: <87vae09jzd.fsf@kamboji.qca.qualcomm.com> (sfid-20180313_143603_822930_3A9958AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3/11/2018 5:05 PM, Andres Rodriguez wrote:
>>> Your patch series then should also have the driver callers who you
>>> want to modify to use this new API. Collect from the 802.11 folks the
>>> other drivers which I think they wanted changed as well.
>>
>> Arend, Kalle, would love to hear your feedback.
>
> I am not sure if it was ath10k, but Kalle will surely know. The other
> driver firing a whole batch of firmware requests is iwlwifi. These
> basically try to get latest firmware version and if not there try an
> older one.

Oh yeah, ath10k definitely needs this! It tries different firmware API
versions from latest to older (firmware-6.bin, firmware-5.bin,
firmware-4.bin and so on) to find a compatible firmware and the error
messages from request_firmware() are constantly confusing the users, I
think the latest query about these errors from last week on IRC. So
having request_firmware_nowarn() (or similar) would help users a lot.

We tried to workaround this by using request_firmware_direct() (which
oddly doesn't print anything) but that caused issues with OpenWRT/LEDE:

https://git.kernel.org/linus/c0cc00f250e1

And iwlwifi has a similar problem, adding Luca to the loop.

-- 
Kalle Valo
