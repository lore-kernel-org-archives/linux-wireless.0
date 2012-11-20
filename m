Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56952 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2KTPQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 10:16:48 -0500
Message-ID: <50AB9E7C.8070204@ti.com> (sfid-20121120_161651_110382_059F2E3D)
Date: Tue, 20 Nov 2012 17:15:08 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kgiori@qca.qualcomm.com" <kgiori@qca.qualcomm.com>,
	"mcgrof@frijolero.org" <mcgrof@frijolero.org>,
	"zefir.kurtisi@neratec.com" <zefir.kurtisi@neratec.com>,
	"adrian.chadd@gmail.com" <adrian.chadd@gmail.com>,
	"j@w1.fi" <j@w1.fi>, "coelho@ti.com" <coelho@ti.com>,
	"igalc@ti.com" <igalc@ti.com>,
	"adrian@freebsd.org" <adrian@freebsd.org>,
	"nbd@nbd.name" <nbd@nbd.name>,
	"simon.wunderlich@s2003.tu-chemnitz.de"
	<simon.wunderlich@s2003.tu-chemnitz.de>, <victorgld@gmail.com>
Subject: Re: [PATCH v4 1/6] nl80211/cfg80211: add radar detection command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>     <1350226137-13704-2-git-send-email-victorg@ti.com>    <1350414099.10177.13.camel@jlt4.sipsolutions.net>   <50842569.5000602@ti.com> <1350910543.10166.3.camel@jlt4.sipsolutions.net>   <50922A9D.2060409@ti.com> <1352128887.9466.17.camel@jlt4.sipsolutions.net>  <50A38F68.1020506@tieto.com> <1352896734.9510.29.camel@jlt4.sipsolutions.net>
In-Reply-To: <1352896734.9510.29.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14/11/2012 14:38, Johannes Berg wrote:
> On Wed, 2012-11-14 at 13:32 +0100, Michal Kazior wrote:
>
>>> Hmm. Maybe then the channel should be passed to the radar detection
>>> command instead? That way, it can be passed through, you can allocate a
>>> channel context, etc. Much easier?
>>
>> I was thinking if putting the radar detection parameter in start_ap() is
>> an option (and thus removing the explicit radar cmd)? We could defer
>> `netif_carrier_on()` to be done after the initial radar detection is done.
>
> Yeah, I was actually thinking that too for a bit, not sure if it works
> though.
>

It won't, well.. at least not with current design. Userspace has the 
responsibility to set the initial channel and reselect the next one if 
necessary (if radar was detected), also it's responsible for the channel 
availability check and its timing.

Moving radar detection to start AP will require additional DFS state 
synchronization between kernel and userspace this why we initially 
agreed to leave the DFS logic (CAC, channel selection etc..) in 
userspace. Anyway, not sure what would we gain here.


-- 
Thanks,
Victor.
