Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20357 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab0EJPAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 11:00:22 -0400
Message-ID: <20100510110020.ggi5l062gw0csg0g-cebfxv@webmail.spamcop.net>
Date: Mon, 10 May 2010 11:00:20 -0400
From: Pavel Roskin <proski@gnu.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [patch 3/9] ath9k: cleanup: u32 => bool
References: <20100508162247.GO27064@bicker>
	<1273477106.3573.0.camel@jlt3.sipsolutions.net>
	<20100510144625.GW27064@bicker>
In-Reply-To: <20100510144625.GW27064@bicker>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Dan Carpenter <error27@gmail.com>:

> Smatch complains we negate a non-boolean type here:
>
>                 if (!on != aniState->ofdmWeakSigDetectOff) {
>
> It's a quite common bug to forget that negation has higher precendence
> than compare operations.  In this case, it's clear from code that "on" is
> either 1 or 0 so smatch should not complain.

We could rename ofdmWeakSigDetectOff to ofdmWeakSigDetectOn and change  
the logic appropriately.  Positive logic is easier to understand in  
the long run.

ofdmWeakSigDetectOn could be boolean and "on" could be int, since it's  
an index.  The comparison could use !!on to convert int to boolean.

-- 
Regards,
Pavel Roskin
