Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756114Ab0IUT2a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 15:28:30 -0400
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4C98F2D8.8020602@openwrt.org>
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>
	 <4C98A022.7020106@candelatech.com> <4C98A2C4.8060108@openwrt.org>
	 <4C98EAA1.7050908@candelatech.com>  <4C98F2D8.8020602@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 21:28:27 +0200
Message-ID: <1285097307.12764.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-21 at 20:00 +0200, Felix Fietkau wrote:

> > Could we just poke a pointer to the STA into the ath_buf structure?

> No, that doesn't work because of RCU.

Well, it could work, if you walk all the structures upon sta_notify and
remove now stale pointers (or just drop the frames or something).

johannes

