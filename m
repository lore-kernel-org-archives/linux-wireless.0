Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33355 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbcA0M1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 07:27:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	kbuild-all@01.org, linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 4/5] brcmfmac: access PMU registers using standalone PMU core if available
References: <201601270149.Nwdmoe5L%fengguang.wu@intel.com>
Date: Wed, 27 Jan 2016 14:27:08 +0200
In-Reply-To: <201601270149.Nwdmoe5L%fengguang.wu@intel.com> (kbuild test
	robot's message of "Wed, 27 Jan 2016 01:30:32 +0800")
Message-ID: <87k2mvnr6r.fsf@kamboji.qca.qualcomm.com> (sfid-20160127_132719_981490_29BFFD73)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi Rafał,
>
> [auto build test ERROR on wireless-drivers/master]
> [also build test ERROR on v4.5-rc1 next-20160125]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-support-for-new-14e43-4365-card-with-BCM4366/20160127-010149
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git master
> config: x86_64-allmodconfig (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function 'brcmf_chip_get_pmu':
>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1143:25: error: 'BCMA_CC_CAP_EXT_AOB_PRESENT' undeclared (first use in this function)
>          pub->cc_caps_ext & BCMA_CC_CAP_EXT_AOB_PRESENT) {
>                             ^
>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1143:25: note: each undeclared identifier is reported only once for each function it appears in

I think this error was as expected because this set depends on "bcma:
support PMU present as separated bus core" which is not yet applied.

-- 
Kalle Valo
