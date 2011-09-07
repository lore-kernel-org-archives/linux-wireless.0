Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42462 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab1IGQtw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 12:49:52 -0400
Message-ID: <4E671A51.2050109@qca.qualcomm.com> (sfid-20110907_185006_666953_E9FB991C)
Date: Wed, 7 Sep 2011 10:16:33 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath6kl: Allow enabling of P2P support
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com> <1315233527-6234-5-git-send-email-jouni@qca.qualcomm.com> <4E65C49B.2000201@qca.qualcomm.com> <20110906072138.GA3125@jouni.qca.qualcomm.com> <4E65D11B.3080904@qca.qualcomm.com> <20110906093509.GA14112@jouni.qca.qualcomm.com>
In-Reply-To: <20110906093509.GA14112@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/06/2011 12:35 PM, Jouni Malinen wrote:
> On Tue, Sep 06, 2011 at 10:51:55AM +0300, Kalle Valo wrote:
>> I was more thinking that ath6kl_p2p would not be exposed outside init.c,
>> instead you would set the appropriate conf_flag in ath6kl_core_init() or
>> similar function. But leave the module_param as it is for now, I will
>> cleanup the module parameters anyway soon.
> 
> This and the change to using ar->conf_flags instead of ar->p2p turned
> out to be more complex changes. The main problem behind this is in the
> order that the driver is allocating and initializing the data
> structures. In theory, this sounds great and should be the longer term
> direction, but with the current initialization code path, changing the
> struct ath6kl data within ath6kl_core_alloc() (including cfg80211 alloc
> and registration) and ath6kl_core_init() can conflict pretty easily. For
> example, conf_flags are initialized in ath6kl_init() which is called
> from ath6kl_core_init(), but this is done only after ath6kl_core_alloc()
> has already returned and the P2P flags are needed there before cfg80211
> registration..
> 
> I think that the initialization steps need to be reordered in a way
> that cfg80211 registration happens somewhere near the end of init()
> rather than in alloc(). Once this is done, the conf_flags can be set
> based on firmware and target information and those can then be used to
> set up the cfg80211 information before calling wiphy_register(). Until
> that gets done, it seems safest to apply this P2P enabling patch as-is
> and do the proposed clean up separately after the wiphy_register() call
> is moved.

I agree. I didn't look at code closely enough when I suggested the
changes, but it's obvious that the way you implemented is the best for
now. I have applied your original patch 4 now. Sorry for causing you
extra work.

I need to work on firmware boot changes anyway and I will also try to
cleanup cfg80211 registration as well. After that I can change p2p
implementation as we planned.

Kalle
