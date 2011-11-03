Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:59512 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933891Ab1KCQpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 12:45:13 -0400
Message-ID: <4EB2C516.1020703@neratec.com> (sfid-20111103_174517_526422_823A4088)
Date: Thu, 03 Nov 2011 17:45:10 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC v2 2/2] ath9k: integrate initial DFS module
References: <1320328553-28066-1-git-send-email-zefir.kurtisi@neratec.com>	<1320328553-28066-3-git-send-email-zefir.kurtisi@neratec.com> <CAD2nsn2SBVnQF4oTP4X3HR7O=uBKAViW+w-fV67YjbVN1j=3PQ@mail.gmail.com>
In-Reply-To: <CAD2nsn2SBVnQF4oTP4X3HR7O=uBKAViW+w-fV67YjbVN1j=3PQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 04:27 PM, Mohammed Shafi wrote:
> Hi Zefir,
> 
Hello Mohammed,

> On Thu, Nov 3, 2011 at 7:25 PM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> [...]
>>
>> +       if (ah->caps.hw_caps && ATH9K_HW_CAP_DFS) {
>> +               /**
>> +                * enable radar pulse detection
>> +                *
>> +                * TODO: do this only for DFS channels
>> +                */
>> +               ah->private_ops.set_radar_params(ah, &ah->radar_conf);
> 
> can we do this something like ath9k_hw_set_radar_params?
> why we need a seperate debug file for dfs, had i missed something?
> 
My first proposal included the DFS statistics in debug.c, but Luis asked me to keep it separated (see http://www.mail-archive.com/ath9k-devel@lists.ath9k.org/msg06821.html). I'm fine with both approaches, just let me know.

I'll add a ath9k_hw_set_radar_params() in v3.


Thanks,
Zefir
