Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40128 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753154AbeCFMlc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Mar 2018 07:41:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Govind Singh <govinds@codeaurora.org>,
        yamada.masahiro@socionext.com
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 01/13] ath10k: platform driver for WCN3990 SNOC WLAN module
References: <1518684458-5338-1-git-send-email-govinds@codeaurora.org>
        <87371kqfda.fsf@kamboji.qca.qualcomm.com>
        <d396df1b09da4dd7aa14d6af2c2b2b18@aphydexm01b.ap.qualcomm.com>
Date: Tue, 06 Mar 2018 14:41:26 +0200
In-Reply-To: <d396df1b09da4dd7aa14d6af2c2b2b18@aphydexm01b.ap.qualcomm.com>
        (Govind Singh's message of "Thu, 1 Mar 2018 10:13:35 +0000")
Message-ID: <87tvttl6kp.fsf@kamboji.qca.qualcomm.com> (sfid-20180306_134136_722655_EBC206CC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Fixed Govind's top posting and adding Masahiro)

>>> WCN3990 is integrated 802.11ac chipset with SNOC bus interface. Add 
>>> snoc layer driver registration and associated ops.
>>>
>>> WCN3990 support is not yet complete as cold-boot handshake is done 
>>> using qmi(Qualcomm-MSM-Interface) and qmi client support will be added 
>>> once qmi framework is available.
>>>
>>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>>
>> Kbuild bot found an odd problem with this patch:
>>
>>  include/linux/dynamic_debug.h:77:14: error: 'KBUILD_MODNAME'
>>  undeclared (first use in this function); did you mean  'KBUILD_BASENAME'?
>>
>> Full report:
>>
>> http://lists.infradead.org/pipermail/ath10k/2018-February/010907.html
>>
>> Any ideas? Is this is some unrelated issue or what? This patch is not
>> even touching hif.h or ce.c.
>
> I didn't encountered this issue as in my defconfig only
> CONFIG_ATH10K_SNOC was defined. This problem is coming when we define
> CONFIG_ATH10K_SNOC and CONFIG_ATH10K_PCI simultaneously in defconfig
> and this is known issue when multiple modules share objects(in this
> case ce.o). I saw similar reported problem and found
> https://patchwork.kernel.org/patch/10060825/.
>
> After picking the below change issue is not seen.

Let's ask the kbuild maintainer. Masahiro, any chances of getting this
patch applied anytime soon:

kbuild: define KBUILD_MODNAME even if multiple modules share objects

https://patchwork.kernel.org/patch/10060825/

In ath10k we would need it as otherwise we are not able to link ce.o
both to ath10k_pci.ko and ath10k_snoc.ko. What do you think?

Full discussion and the ath10k patch here:

https://patchwork.kernel.org/patch/10220657/

-- 
Kalle Valo
