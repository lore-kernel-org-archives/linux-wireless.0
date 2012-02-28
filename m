Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51518 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964997Ab2B1PBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 10:01:49 -0500
Subject: Re: WARNING: at
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
 iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <CAD2nsn1_DzbRHuSbS_1rFNzuux_9pW1-pABEasQ01_y7-ndO5w@mail.gmail.com> (sfid-20120228_155108_492998_CE6B8D9D)
References: <CAD2nsn1_DzbRHuSbS_1rFNzuux_9pW1-pABEasQ01_y7-ndO5w@mail.gmail.com>
	 (sfid-20120228_155108_492998_CE6B8D9D)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Feb 2012 16:01:45 +0100
Message-ID: <1330441305.3368.12.camel@jlt3.sipsolutions.net> (sfid-20120228_160153_993288_C0E64B8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

> got this following warning  for the following card, it was my inbuilt
> card it was just associated with an AP, wireless-testing 3.3.0-rc4-wl
> 
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN
> [Shiloh] Network Connection
>         Subsystem: Intel Corporation Device 1211

> [11056.342672] WARNING: at
> drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:465
> iwl_irq_tasklet+0x7c8/0x1620 [iwlwifi]()
> [11056.342681] Hardware name: 64756D6
> [11056.342687] reclaim is false, SEQ_RX_FRAME unset: STATISTICS_NOTIFICATION

Thanks for the report. The warning is harmless, but we were hoping this
code was only to handle 4965 (this code comes from pre-driver-split
days). As we weren't sure, we put in the warning. Since you ran into it,
evidently this does in fact happen on later devices; it will complicate
our life a bit but we'll handle it.

For you, there's nothing to worry about, the driver handles this
situation just fine. :-)

Thanks!

johannes

