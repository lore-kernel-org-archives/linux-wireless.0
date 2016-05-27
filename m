Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58037 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbcE0Mo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 08:44:58 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/2] ath10k: Add support for QCA9887
Date: Fri, 27 May 2016 12:44:52 +0000
Message-ID: <87wpmf4qm5.fsf@kamboji.qca.qualcomm.com> (sfid-20160527_144542_073885_0D262FE8)
References: <1568876.Six5hABE57@bentobox>
	<87mvnc67yq.fsf@kamboji.qca.qualcomm.com>	<1505571.v1gM3hzMhG@bentobox>
In-Reply-To: <1505571.v1gM3hzMhG@bentobox> (Sven Eckelmann's message of "Fri,
	27 May 2016 10:46:49 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:

> On Thursday 26 May 2016 17:32:30 Valo, Kalle wrote:
>> Sven Eckelmann <sven.eckelmann@open-mesh.com> writes:
>> 
>> > the QCA9887 chip is similar to the QCA988x chips. But it requires a special
>> > firmware and uses a different calibration data source. Unfortunately, no
>> > working firmware currently exists. But it is possible to create a semi working
>> > one by binary patching the current version.
>> 
>> So what works and what doesn't?
>
> We currently stopped everything related to QCA9887 and so I cannot give you an
> exhaustive list. But right now basic AP functionality seems to work. The
> signal level, coverage and performance was rather bad. I cannot give you
> numbers anymore because the two actual tests with QCA9887 were done 1 year ago
> and 1/2 year ago (you know why ;) ).
>
> But maybe I should add that the results with the original AP147 firmware also
> wasn't better.

That doesn't sound good. Maybe a calibration issue?

>> I can upload a new version. So I need to add these flags:
>> 
>> ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX
>> ATH10K_FW_FEATURE_NO_P2P
>> ATH10K_FW_FEATURE_SUPPORTS_SKIP_CLOCK_INIT
>> 
>> Anything else?
>
> At least I didn't find more.

I pushed a new firmware image firmware-5.bin_10.2.3.31.7-2 with those
enabled:

https://github.com/kvalo/ath10k-firmware/tree/master/QCA9887

>> Should we add a warning message to ath10k that the QCA9887 support is
>> experimental? That way users don't need to wonder why there are so many
>> problems.
>
> Yes, this would be a good idea. I personally wouldn't know where you want
> to have this warning added. So maybe you just add it? Thanks

Sure, I can add it.

>> There were some conflicts in patch 1. I fixed those now and pushed the
>> patches to the pending branch for further testing:
>> 
>> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/log/?h=master-pending
>> 
>> Unfortunately I don't have QCA9887 myself so I can't test these myself.
>> I hope I didn't break anything.
>
> Ah, yes. The new patches "clean up growing hw checks during safe and full reset"
> and some QCA9884 stuff seems to have created some conflicts. I have redone my
> patches on top of them and compared with your solution. We came up with the
> exact same conflict resolution. So you can at least say that I would also
> have broken it ;)

Good, so I would not get the blame myself ;)

> I have just created a compat-wireless based on your branch which I've tested
> it with my QCA9887 test card. No new problems were detected.

Great, thanks for testing!

-- 
Kalle Valo