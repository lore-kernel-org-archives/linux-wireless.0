Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54175 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397Ab2JUQlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 12:41:03 -0400
Message-ID: <50842563.4010201@ti.com> (sfid-20121021_184107_147271_F09B1870)
Date: Sun, 21 Oct 2012 18:40:03 +0200
From: Victor Goldenshtein <victorg@ti.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <kgiori@qca.qualcomm.com>,
	<mcgrof@frijolero.org>, <zefir.kurtisi@neratec.com>,
	<adrian.chadd@gmail.com>, <j@w1.fi>, <coelho@ti.com>,
	<assaf@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH v4 6/6] mac80211: add ap channel switch command/event
References: <1350226137-13704-1-git-send-email-victorg@ti.com>  <1350226137-13704-7-git-send-email-victorg@ti.com> <1350414472.10177.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1350414472.10177.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/10/2012 21:07, Johannes Berg wrote:
> On Sun, 2012-10-14 at 16:48 +0200, Victor Goldenshtein wrote:
>> Add ieee80211_ap_process_chanswitch(), to handle a channel switch
>> request for AP.
>>
>> Add ieee80211_ap_ch_switch_done() which updates oper_channel
>> and notifies upper layers about channel switch complete event.
>
> Given channel contexts, how does this patch need to change?
>

I guess most of the changes would be in the channel switch complete 
area, we will need to update the correct vif channel 
(ieee80211_assign_vif_chanctx) instead of the local->oper_channel.

-- 
Thanks,
Victor.
