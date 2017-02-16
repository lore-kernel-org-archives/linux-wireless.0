Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55502 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753974AbdBPKCG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 05:02:06 -0500
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
Date: Thu, 16 Feb 2017 12:01:49 +0200
In-Reply-To: <59013c13-af43-cf9f-8e3e-14d97e48f0dd@broadcom.com> (Arend Van
        Spriel's message of "Thu, 16 Feb 2017 10:53:02 +0100")
Message-ID: <87efyymp2q.fsf@kamboji.qca.qualcomm.com> (sfid-20170216_110315_817862_583580B6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 16-2-2017 10:39, Rafa=C5=82 Mi=C5=82ecki wrote:
>> On 02/16/2017 10:31 AM, Kalle Valo wrote:
>>> (Adding linux-wireless)
>>>
>>> Randy Dunlap <rdunlap@infradead.org> writes:
>>>
>>>> On 02/07/17 02:02, kbuild test robot wrote:
>>>>> Hi Kalle,
>>>>>
>>>>> FYI, the error/warning still remains.
>>>>>
>>>>> tree:=20=20
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>>>>> master
>>>>> head:   8b1b41ee74f9712c355d66dc105bbea663ae0afd
>>>>> commit: 05491d2ccf20b20a1375303441fbbfbd12b24a4f brcm80211: move
>>>>> under broadcom vendor directory
>>>>> date:   1 year, 3 months ago
>>>>> config: mips-allyesconfig (attached as .config)
>>>>> compiler: mips-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
>>>>> reproduce:
>>>>>         wget
>>>>> https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/=
sbin/make.cross
>>>>>
>>>>> -O ~/bin/make.cross
>>>>>         chmod +x ~/bin/make.cross
>>>>>         git checkout 05491d2ccf20b20a1375303441fbbfbd12b24a4f
>>>>>         # save the attached .config to linux build tree
>>>>>         make.cross ARCH=3Dmips
>>>>>
>>>>> All errors (new ones prefixed by >>):
n>>>>
>>>> when both:
>>>>
>>>> CONFIG_BRCM_TRACING=3Dy
>>>> CONFIG_BRCMDBG=3Dy
>>>>
>>>> but DEBUG is not defined.
>>>>
>>>> I think it would help if CONFIG_BRCMDBG set DEBUG
>>>> or if some of the tests for DEBUG used CONFIG_BRCMDBG instead.
>>>
>>> Arend or Rafa=C5=82, would you be able to look at this build problem? K=
build
>>> found the build errors below, apparently a very old issue. It just
>>> blames me now because I moved the driver to a new directory :)
>
> It is a very old issue. The thing is that the issue can not really occur
> because we have this:
>
> # common flags
> subdir-ccflags-$(CONFIG_BRCMDBG)        +=3D -DDEBUG
>
> in drivers/net/wireless/broadcom/brcm80211/Makefile. So no clue what
> happens in the "kbuild test robot" scenario.

I actually tried to reproduce this with kbuild bot's instructions and
was surprised to see that the build worked ok for me. So the issue is
not that simple.

--=20
Kalle Valo
