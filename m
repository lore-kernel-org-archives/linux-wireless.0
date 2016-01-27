Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:33666 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934086AbcA0WzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jan 2016 17:55:24 -0500
Received: by mail-io0-f194.google.com with SMTP id f81so2338931iof.0
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jan 2016 14:55:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rzxNOq1JWFc=5EvE+UmtfUMZq4QYjAdGn1UE7zE-VRu8Q@mail.gmail.com>
References: <201601270149.Nwdmoe5L%fengguang.wu@intel.com> <87k2mvnr6r.fsf@kamboji.qca.qualcomm.com>
 <CACna6rzxNOq1JWFc=5EvE+UmtfUMZq4QYjAdGn1UE7zE-VRu8Q@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 28 Jan 2016 09:55:03 +1100
Message-ID: <CAGRGNgXkRXN9sqa9ikOXY58ZaOOr3cGar_zNj-=LtzjWdpeGWA@mail.gmail.com> (sfid-20160127_235530_519089_733F536F)
Subject: Re: [PATCH 4/5] brcmfmac: access PMU registers using standalone PMU
 core if available
To: kbuild test robot <lkp@intel.com>, kbuild-all@01.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kbuild Test Robot Guys,

On Thu, Jan 28, 2016 at 12:08 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
> On 27 January 2016 at 13:27, Kalle Valo <kvalo@codeaurora.org> wrote:
>> kbuild test robot <lkp@intel.com> writes:
>>
>>> Hi Rafał,
>>>
>>> [auto build test ERROR on wireless-drivers/master]
>>> [also build test ERROR on v4.5-rc1 next-20160125]
>>> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>>>
>>> url:    https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-support-for-new-14e43-4365-card-with-BCM4366/20160127-010149
>>> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git master
>>> config: x86_64-allmodconfig (attached as .config)
>>> reproduce:
>>>         # save the attached .config to linux build tree
>>>         make ARCH=x86_64
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c: In function 'brcmf_chip_get_pmu':
>>>>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1143:25: error: 'BCMA_CC_CAP_EXT_AOB_PRESENT' undeclared (first use in this function)
>>>          pub->cc_caps_ext & BCMA_CC_CAP_EXT_AOB_PRESENT) {
>>>                             ^
>>>    drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c:1143:25: note: each undeclared identifier is reported only once for each function it appears in
>>
>> I think this error was as expected because this set depends on "bcma:
>> support PMU present as separated bus core" which is not yet applied.
>
> Yes, builbot simply couldn't know about this, but I should have reply
> to make it clear I guess.

Is there any way to communicate to the test robot that this series
depends on some other series or patch?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
