Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:53134 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932314AbeCKXKs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Mar 2018 19:10:48 -0400
Received: by mail-wm0-f44.google.com with SMTP id t3so13046021wmc.2
        for <linux-wireless@vger.kernel.org>; Sun, 11 Mar 2018 16:10:47 -0700 (PDT)
Subject: Re: [PATCH] firmware: add a function to load optional firmware v2
To: Andres Rodriguez <andresx7@gmail.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <20180309221243.15489-2-andresx7@gmail.com>
 <20180309230925.3573-1-andresx7@gmail.com>
 <CAB=NE6VY62KqmhzD=zT8od=PhgPi3rGKKKxKz_zad-ZrYW-97A@mail.gmail.com>
 <CAB=NE6XpY4LuDwnakCa6gZ_HjjhZDnu=gDeHwmpNRaSkqQOB2g@mail.gmail.com>
 <bbdc304f-edd5-38df-ea88-012fefc54b90@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA5B777.5020106@broadcom.com> (sfid-20180312_001103_474519_09E3D8F0)
Date: Mon, 12 Mar 2018 00:10:47 +0100
MIME-Version: 1.0
In-Reply-To: <bbdc304f-edd5-38df-ea88-012fefc54b90@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/11/2018 5:05 PM, Andres Rodriguez wrote:
>> Your patch series then should also have the driver callers who you
>> want to modify to use this new API. Collect from the 802.11 folks the
>> other drivers which I think they wanted changed as well.
>
> Arend, Kalle, would love to hear your feedback.

I am not sure if it was ath10k, but Kalle will surely know. The other 
driver firing a whole batch of firmware requests is iwlwifi. These 
basically try to get latest firmware version and if not there try an 
older one.

The brcmfmac driver I maintain is slightly different. It downloads two 
distinct pieces of firmware of which one is optional for certain 
configurations. Currently, my driver does two asynchronous requests for 
it, but I consider changing it and only make the first request 
asynchronous and the second request synchronous. You can look at the 
current code in drivers/net/wireless/broadcom/brcmfmac/firmware.c. 
However, I did quite some restructuring last week. Anyway, I probably 
will end up using the "optional" api where appropriate.

Regards,
Arend
