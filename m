Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751341AbeCJJLg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Mar 2018 04:11:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: <yamada.masahiro@socionext.com>
Cc: <govinds@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        <ath10k@lists.infradead.org>
Subject: Re: [PATCH 01/13] ath10k: platform driver for WCN3990 SNOC WLAN module
References: <1518684458-5338-1-git-send-email-govinds@codeaurora.org>
        <87371kqfda.fsf@kamboji.qca.qualcomm.com>
        <d396df1b09da4dd7aa14d6af2c2b2b18@aphydexm01b.ap.qualcomm.com>
        <87tvttl6kp.fsf@kamboji.qca.qualcomm.com>
        <fb2c04383f024ab8b2c62dd5a4ad20ac@SOC-EX01V.e01.socionext.com>
Date: Sat, 10 Mar 2018 11:11:31 +0200
In-Reply-To: <fb2c04383f024ab8b2c62dd5a4ad20ac@SOC-EX01V.e01.socionext.com>
        (yamada masahiro's message of "Thu, 8 Mar 2018 00:25:36 +0000")
Message-ID: <87lgf0cn24.fsf@kamboji.qca.qualcomm.com> (sfid-20180310_101350_172270_05B1BFE5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<yamada.masahiro@socionext.com> writes:

>> >> Kbuild bot found an odd problem with this patch:
>> >>
>> >>  include/linux/dynamic_debug.h:77:14: error: 'KBUILD_MODNAME'
>> >>  undeclared (first use in this function); did you mean
>> 'KBUILD_BASENAME'?
>> >>
>> >> Full report:
>> >>
>> >>
>> http://lists.infradead.org/pipermail/ath10k/2018-February/010907.html
>> >>
>> >> Any ideas? Is this is some unrelated issue or what? This patch is not
>> >> even touching hif.h or ce.c.
>> >
>> > I didn't encountered this issue as in my defconfig only
>> > CONFIG_ATH10K_SNOC was defined. This problem is coming when we define
>> > CONFIG_ATH10K_SNOC and CONFIG_ATH10K_PCI simultaneously in defconfig
>> > and this is known issue when multiple modules share objects(in this
>> > case ce.o). I saw similar reported problem and found
>> > https://patchwork.kernel.org/patch/10060825/.
>> >
>> > After picking the below change issue is not seen.
>> 
>> Let's ask the kbuild maintainer. Masahiro, any chances of getting this
>> patch applied anytime soon:
>> 
>> kbuild: define KBUILD_MODNAME even if multiple modules share objects
>> 
>> https://patchwork.kernel.org/patch/10060825/
>> 
>> In ath10k we would need it as otherwise we are not able to link ce.o
>> both to ath10k_pci.ko and ath10k_snoc.ko. What do you think?
>> 
>> Full discussion and the ath10k patch here:
>> 
>> https://patchwork.kernel.org/patch/10220657/
>> 
>
> I plan to submit v2, but even if the undefined KBUILD_MODNAME is fixed,
> I expect another problem from this patch.
>
> If both CONFIG_ATH10K_PCI and CONFIG_ATH10_SNOC are 'y'
> two instances of ce.o would be linked into vmliux,
> then causes multiple definition error.

Oh, I didn't realise this. Thanks for pointing it out. Govind is looking
at other ways to fix this.

-- 
Kalle Valo
