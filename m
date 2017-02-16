Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35112 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752983AbdBPNSy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 08:18:54 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        kbuild-all@01.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c:58:6: error: redefinition of 'brcmf_debugfs_init'
References: <201702071839.Ej9MjmlI%fengguang.wu@intel.com>
        <ce7467a9-12d5-f64e-8b59-f9581db9f7c8@infradead.org>
        <87inoamqh6.fsf@kamboji.qca.qualcomm.com>
        <e8c43505-1e7a-635c-dc27-45422acb25a6@milecki.pl>
        <59013c13-af43-cf9f-8e3e-14d97e48f0dd@broadcom.com>
        <87efyymp2q.fsf@kamboji.qca.qualcomm.com>
        <8ff44e41-97c7-4ae5-6850-65ad407fd788@broadcom.com>
Date: Thu, 16 Feb 2017 15:18:48 +0200
In-Reply-To: <8ff44e41-97c7-4ae5-6850-65ad407fd788@broadcom.com> (Arend Van
        Spriel's message of "Thu, 16 Feb 2017 11:30:56 +0100")
Message-ID: <8737fe46kn.fsf@codeaurora.org> (sfid-20170216_141923_018893_DC1D3245)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 16-2-2017 11:01, Kalle Valo wrote:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>>=20
>>> On 16-2-2017 10:39, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>> On 02/16/2017 10:31 AM, Kalle Valo wrote:
>>>>> (Adding linux-wireless)
>>>>>
>>>>> Arend or Rafa=C5=82, would you be able to look at this build problem?=
 Kbuild
>>>>> found the build errors below, apparently a very old issue. It just
>>>>> blames me now because I moved the driver to a new directory :)
>>>
>>> It is a very old issue. The thing is that the issue can not really occur
>>> because we have this:
>>>
>>> # common flags
>>> subdir-ccflags-$(CONFIG_BRCMDBG)        +=3D -DDEBUG
>>>
>>> in drivers/net/wireless/broadcom/brcm80211/Makefile. So no clue what
>>> happens in the "kbuild test robot" scenario.
>>=20
>> I actually tried to reproduce this with kbuild bot's instructions and
>> was surprised to see that the build worked ok for me. So the issue is
>> not that simple.
>
> Hi Kalle,
>
> Here is the old email exchange we had about this [1]. In my opinion this
> is a Kbuild issue that needs to be looked into.
>
> Regards,
> Arend
>
> [1] http://www.spinics.net/lists/linux-wireless/msg142122.html

Heh, I had completely forgotten that we had discussed this before :)

Fengguang and the kbuild bot team, do you have any ideas why only the
bot is seeing this?

--=20
Kalle Valo
