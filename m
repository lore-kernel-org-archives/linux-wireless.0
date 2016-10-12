Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18250 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753900AbcJLNvV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 09:51:21 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: David Hutchison <dhutchison@bluemesh.net>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: QCA9887 Firmware Memory Usage
Date: Wed, 12 Oct 2016 13:51:08 +0000
Message-ID: <8760oxfzg4.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_155126_890529_8B64D1FD)
References: <CA+i30h8YsG7mce5FMwGw2fRNAn3USYV6K==QMjMQVeSGB0dj=w@mail.gmail.com>
In-Reply-To: <CA+i30h8YsG7mce5FMwGw2fRNAn3USYV6K==QMjMQVeSGB0dj=w@mail.gmail.com>       (David
 Hutchison's message of "Thu, 6 Oct 2016 15:59:40 -0600")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Hutchison <dhutchison@bluemesh.net> writes:

> I am using a Mikrotik hAP AC Lite which has a QCA9887 radio. It
> appears to be working; however ath10k ( or the qca9887 firmware ) is
> utilizing 15 - 20mb of memory. I applied the kfree(caldata) patch, to
> insure there is no memory leak.
>
> It doesn't appear to be leaking, and it will run Ok with the high
> memory footprint. However the Mikrotik hAP AC Lite is only a 64mb
> platform; so when I initialize the 2nd radio with ath9k I get OOMs.
>
> It just doesn't seem right that when ath10k + qca9887 is in AP mode
> that it's utilizing as much memory as it is. I don't think the issue
> is with ath10k, I think it's the qca9887 firmware (
> firmware-5.bin_10.2.4-1.0-00013 ).
>
> Is there a newer build available that may potentially fix these memory
> issues? The latest one available on
> https://github.com/kvalo/ath10k-firmware/blob/master/QCA9887/hw1.0/firmwa=
re-5.bin_10.2.4-1.0-00013
> is 2 months old. Perhaps there is a newer build to test that may have
> the fix?
>
> Any thoughts as to what it could be? I can provide more information if ne=
eded.

64MB of RAM nowadays is not much and ath10k is not really tested in such
setups AFAIK. I guess you could try if reducing TARGET_10X_NUM_MSDU_DESC
helps with the memory consumption, but no idea if that would even work
without further modifications to ath10k.

Also if you have fq-codel&co enabled that might increase memory
consumption. Adding linux-wireless as people there might have better
ideas.

--=20
Kalle Valo=
