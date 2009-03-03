Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43386 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbZCCJyx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 04:54:53 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 03 Mar 2009 01:54:52 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18860.64890.657290.185346@gargle.gargle.HOWL> (sfid-20090303_105501_481254_A5951670)
Date: Tue, 3 Mar 2009 15:20:50 +0530
To: Vivek Natarajan <vivek.natraj@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Handle power modes in isr for power save.
In-Reply-To: <8e92b4100903030137r4c412ccdu17020c482d6cb1b3@mail.gmail.com>
References: <20090302145514.GB4660@myhost.users.atheros.com>
	<18860.6782.4168.588808@gargle.gargle.HOWL>
	<8e92b4100903030137r4c412ccdu17020c482d6cb1b3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> SC_OP_WAIT_FOR_BEACON is being changed in rx_tasklet and in isr which
> are mutually exclusive. Even though it might be changed  in these two
> regions, it won't affect the ps_wake/ps_restore cycle.
> 
> IEEE80211_CONF_PS is changed in siwpower() and also in
> dynamic_ps_work. Even if it is changed while we are executing this
> ps_restore, there won't be any race condition on ps_wake/ps_restore
> cycle and it will work fine.
> 
> hw_setpower is just a register write function which may not need a protection(?)
> 
> And for the protection of ps_wake/ps_restore itself, there is
> ps_count(atomic) which takes care of properly restoring power save
> state.
> 
> Overall, from my perspective there is no need for any more lock.

Sorry, I saw sc_flags and just assumed it would be set from process context.
Thanks for the explanation.

Sujith
