Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14671 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbZB0KSL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 05:18:11 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 02:18:10 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18855.48369.413479.945570@gargle.gargle.HOWL> (sfid-20090227_111815_035715_A2869317)
Date: Fri, 27 Feb 2009 15:44:09 +0530
To: Alina Friedrichsen <x-alina@gmx.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: IBSS issues
In-Reply-To: <20090227095312.291210@gmx.net>
References: <18855.26210.618690.891378@gargle.gargle.HOWL>
	<20090227082545.291220@gmx.net>
	<18855.43002.100899.931613@gargle.gargle.HOWL>
	<20090227095312.291210@gmx.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alina Friedrichsen wrote:
> But is it calculated only one time after the join? The TSF value in the template is
> really fast outdated. I think why not let __ieee80211_sta_join_ibss() call the
> set_tsf() callback, so that the TSF is mostly synced from the beginning on
> and fine-tuned later by the hardware?


Yes, the TBTT is calculated only once after joining the BSS network.

Am not sure I understand the proposal. What would the tsf value in set_tsf() be ?
11.1.4 (IEEE802.11-2007) says that the TSF has to be reset to zero on joining
an IBSS network. We do that correctly. To calculate the next TBTT, we can't use the
HW TSF, since it has just been reset. And the Beacon's timestamp + intval + FUDGE
is what we do in ath9k to get the TBTT for this peer, which I think is correct.
A sniffer shows the beacon generation being evenly distributed.

Sujith
