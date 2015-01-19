Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:40724 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbASMhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 07:37:25 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Rico Derrer <rico.derrer@neratec.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.19] ath9k: fix race condition in irq processing during hardware reset
References: <1421241456-29085-1-git-send-email-nbd@openwrt.org>
	<377854068.83121.1421395226029.JavaMail.zimbra@neratec.com>
	<54B8EAD9.5050200@openwrt.org>
	<1748015898.90209.1421656017853.JavaMail.zimbra@neratec.com>
Date: Mon, 19 Jan 2015 14:37:18 +0200
In-Reply-To: <1748015898.90209.1421656017853.JavaMail.zimbra@neratec.com>
	(Rico Derrer's message of "Mon, 19 Jan 2015 09:26:57 +0100 (CET)")
Message-ID: <87oapvj69t.fsf@kamboji.qca.qualcomm.com> (sfid-20150119_133728_016630_E41D80E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rico Derrer <rico.derrer@neratec.com> writes:

>>> This part completely blocks the system on a AR9350. Loading the
>>> module works but configuring it hangs the system until watchdog
>>> restarts it.
>>
>> What kernel/software are you running on there? When I committed this
>> patch to OpenWrt, it uncovered IRQ handling bugs in MIPS kernel code
>> (both generic and in the ath79 platform code).
>> 
>> You can find the fixes that I've made here:
>> http://git.openwrt.org/?p=openwrt.git;a=blob_plain;f=target/linux/generic/patches-3.14/130-mips_cpu_irq_disable.patch
>> http://git.openwrt.org/?p=openwrt.git;a=blob_plain;f=target/linux/ar71xx/patches-3.14/736-MIPS-ath79-fix-chained-irq-disable.patch
>> 
>> I've already submitted the first one to linux-mips.
>
> Thank you, these patches fixed the problem.

Thanks for confirming that, makes it a lot safer for me to apply the
patch.

-- 
Kalle Valo
