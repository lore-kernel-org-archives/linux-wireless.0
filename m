Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16510 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751099Ab1JUWG2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 18:06:28 -0400
Subject: Re: Setting negative value in dBm for power output (txpower)
From: wwguy <wey-yi.w.guy@intel.com>
To: Patryk =?UTF-8?Q?=C5=BB=C3=B3=C5=82towski?=
	<patryk.zoltowski@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com>
References: <CAJ5hJZSm4P5Vpzmi6yfF3vy2XAMKH9kE-Kv=FfDLVX9DwQC4Aw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Oct 2011 15:00:38 -0700
Message-ID: <1319234438.14693.6.camel@wwguy-ubuntu> (sfid-20111022_000633_191300_DEEA73E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-21 at 14:35 -0700, Patryk Żółtowski wrote:
> I'm doing a research and I'm wondering if it's possible to hack
> wireless drivers to allow setting  txpower to smaller value than 1mW
> (e.g. 0.1mW = -10dBM, or even 0.01mW). I've checked source code and in
> net/mac80211/cfg.c there is the following check:
> 
>   if (mbm < 0 || (mbm % 100))
>                      return -EOPNOTSUPP;
> 
> and in  e.g. in drivers/net/wireless/iwlwifi/iwl-4965.h  also the min
> power output is limited by this define:
> 
>  IWL_TX_POWER_TARGET_POWER_MIN       (0)
> 
> Is it possible to modify source to allow negative power output in dBm
> that would work? Or is it physical limitation from the hardware? I'm
> doing just a research using Intel Corporation PRO/Wireless 4965 AG
> card  and right now I don't require to support other hardware. Is
> there any way to check minimum power output capability by given
> wireless card? I'm not proficient with driver hacking so any hint
> where to start (which file to look up, references) would be helpful.
> 
First, what kernel you are using, the latest iwlegacy driver does not
has IWL_TX_POWER_TARGET_POWER_MIN defined.

Also, for 4965, even the tx power table is filled and send by the
driver, but firmware still has the final call and I do not believe
negative power output is possible. Plus I don't think the tx power HCMD
can support negative value. 

BTW, 4965 is the last Intel WiFi device still has tx power table filled
by the driver, starting from 5000 series, tx power is control by the
firmware.

Thanks
Wey


