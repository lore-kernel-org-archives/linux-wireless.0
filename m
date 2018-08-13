Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38974 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728509AbeHMOqA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 10:46:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Grzegorz =?utf-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: Re: Cpu stall caused by hostapd running two interfaces
References: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
        <20180813084123.GA18180@redhat.com>
Date: Mon, 13 Aug 2018 15:03:56 +0300
In-Reply-To: <20180813084123.GA18180@redhat.com> (Stanislaw Gruszka's message
        of "Mon, 13 Aug 2018 10:41:25 +0200")
Message-ID: <87tvnycw2b.fsf@purkki.adurom.net> (sfid-20180813_140412_885501_CAE4091D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> (cc Haim and Johannes)
>
> On Sun, Aug 12, 2018 at 09:54:00PM +0200, Grzegorz Duszy=C5=84ski wrote:
>> Hello,
>>=20
>> I'm running into problems while trying to start AP's on 2 interfaces.
>> Devices are:
>> - Compex WLE900VX (QCA9880)
>> - Killer 1535 (QCA6174)
>>=20
>> The 1535 is a new addition to the system.
>> Compex by itself runs fine, Killer also can run alone.
>>=20
>> But when running them together all hell breaks lose.
>> System is unusable, cannot even reboot.
>>=20
>> I'm running Arch Linux.
>> My system was updated before testing & posting.
>>=20
>> Attachments:
>> dmesg - https://pastebin.com/wf3Fq8gh
>>=20
>> Please let me know if additional info is required.
>
> This is oops in ieee80211_regulatory_limit_wmm_params().
> Looks like new regulatory code do not like ath10k.
> I have another bug report with reg.c WARNING also on ath10k:
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1612537

I think bug #1612537 is with ath9k, not ath10k. But anyway, both use
ath.ko which has some custom regulatory code.

--=20
Kalle Valo
