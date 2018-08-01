Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34960 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387733AbeHAKXg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Aug 2018 06:23:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
Subject: Re: [PATCH 6/6] qtnfmac: implement basic WoWLAN support
References: <20180531091102.28666-7-sergey.matyukevich.os@quantenna.com>
        <20180730141342.B613A61D77@smtp.codeaurora.org>
        <20180731095929.nskgxmi3siyrjvvv@bars>
Date: Wed, 01 Aug 2018 11:38:54 +0300
In-Reply-To: <20180731095929.nskgxmi3siyrjvvv@bars> (Sergey Matyukevich's
        message of "Tue, 31 Jul 2018 12:59:31 +0300")
Message-ID: <87a7q68orl.fsf@kamboji.qca.qualcomm.com> (sfid-20180801_105646_053084_787596E4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> > This patch implements core WoWLAN support in qtnfmac driver, including
>> > processing of WoWLAN features reported by firmware and implementation
>> > of cfg80211 suspend/resume/wakeup callbacks. Currently the following
>> > WoWLAN triggers are supported: disconnect, magic packet,
>> > custom pattern packet.
>> >
>> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>> 
>> Doesn't apply anymore as I dropped patch 5
>> 
>> fatal: sha1 information is lacking or useless
>> (drivers/net/wireless/quantenna/qtnfmac/cfg80211.c).
>> error: could not build fake ancestor
>> Applying: qtnfmac: implement basic WoWLAN support
>> Patch failed at 0001 qtnfmac: implement basic WoWLAN support
>> The copy of the patch that failed is found in: .git/rebase-apply/patch
>> 
>> Patch set to Changes Requested.
>
> Thanks for review. I will rebase the remaining patches on top of your
> up-to-date tree and resubmit.
>
> As for the patch with vendor specific commands, I will split it into
> a separate discussion and make another attempt to convince you, adding
> proper description.

Thanks, please do that. And always try to submit controversial patches
separately, not within a bigger patchset.

> IIRC there is no generic functionality suitable for this particular
> usecase.

The bigger problem here is that what should we do with the vendor
commands, the current way of things (=some low level hardware related
commands are accepted) does not work as it takes too much of my time.
People always try to take the easy way out so they provide minimal
documentation for vendors commands and don't even considering having a
generic nl80211 interface, which needs from me quite significant effort
to make the decision if the vendor interface is acceptable or not.

Personally I would just reject all vendor commands but on the otherhand
I somewhat understand why in some cases they might be good. Dunno.

-- 
Kalle Valo
