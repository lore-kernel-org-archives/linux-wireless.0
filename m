Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30018 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbZJOCT3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 22:19:29 -0400
Subject: Re: [PATCH V3] iwlwifi: use paged Rx
From: Zhu Yi <yi.zhu@intel.com>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <2d0a357f0910141204o9adc257w7744e47b47b1cace@mail.gmail.com>
References: <1255079985-17282-1-git-send-email-yi.zhu@intel.com>
	 <2d0a357f0910141204o9adc257w7744e47b47b1cace@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 15 Oct 2009 10:18:51 +0800
Message-Id: <1255573132.3719.417.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-10-15 at 03:04 +0800, Sedat Dilek wrote:
> you are using ieee80211_rx() in
> * drivers/net/wireless/iwlwifi/iwl-3945.c
> * drivers/net/wireless/iwlwifi/iwl-rx.c
> files.
> Kalle posted "mac80211: add ieee80211_rx_ni()" patch [1] and I applied
> on top of master 2009-10-13.
> wl1251 driver uses ieee80211_rx_ni() [2].
> My question:
> Is iwlagn/iwl3945 using workqueues - means shall/can it use
> ieee80211_rx_ni() instead?

The iwlagn context for calling ieee80211_rx{_irqsafe} is tasklet. But
before my patch, the call site is also protected by a
spinlock_irqsave(). This makes the actual context to be an IRQ one. Thus
ieee80211_rx_irqsafe() is used originally. In this patch, I removed the
spin lock protection for it (see the patch comment for why we can do it)
so that ieee80211_rx() can be used now.

> Out of curiosity, I substituted ieee80211_rx() by ieee80211_rx_ni()
> and it seems to work.

This is unnecessary. Tasklet has already had bh disabled.

Thanks,
-yi

