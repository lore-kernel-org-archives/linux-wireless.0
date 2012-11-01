Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58907 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab2KAHzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 03:55:20 -0400
Message-ID: <50922A9D.2060409@ti.com> (sfid-20121101_085532_274085_711DEA8F)
Date: Thu, 1 Nov 2012 09:54:05 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<igalc@ti.com>, <adrian@freebsd.org>, <nbd@nbd.name>,
	<simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>   <1350226137-13704-2-git-send-email-victorg@ti.com>  <1350414099.10177.13.camel@jlt4.sipsolutions.net> <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350910543.10166.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22/10/2012 14:55, Johannes Berg wrote:
>> 2. In __nl80211_set_channel() - to cover the case when the CAC was
>> initiated on a "preset_chan" (during AP init phase) and the IF was
>> removed before the AP was even started (local->oper_channel wasn't set yet).
>
> Hmm, I'm not sure I get it. How is "local->oper_channel" (a mac80211
> variable) related to this cfg80211 code?

It's not, just saying that its not set at this point.

> start_ap() isn't expected to be able to succeed until CAC passed
> successfully, but OTOH the channel isn't configured until then?

right, the initial CAC performed before start_ap(), only by setting the 
channel with __nl80211_set_channel() + radar detection command.

-- 
Thanks,
Victor.
