Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7144 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2GIDcl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 23:32:41 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20474.20627.928963.262924@gargle.gargle.HOWL> (sfid-20120709_053245_808177_74BF2C81)
Date: Mon, 9 Jul 2012 09:01:31 +0530
To: Guido Iribarren <guidoiribarren@buenosaireslibre.org>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc 1mbps in IBSS mode
In-Reply-To: <CAHD-aqJrKfL8OL97wcnaaTYFZrx2cBXvdY5vKeK67u_-VjGOKg@mail.gmail.com>
References: <4FD56DCA.1080200@codigosur.org>
	<CAJ-VmomzoXV8YBdiS_2nkzVagBupX3Be-Dmboxotwy9s3h3r7w@mail.gmail.com>
	<CAHD-aqKWdUBGyadCnVoSbkf4BysoSuvBBHrupXx-JbowqqNZPQ@mail.gmail.com>
	<CAHD-aqJrKfL8OL97wcnaaTYFZrx2cBXvdY5vKeK67u_-VjGOKg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guido Iribarren wrote:
> I know nothing about the internal workings of the driver, but i get
> the feeling that nodes are somehow not acknowledging supported speeds
> of newly joined nodes, but instead only check other hosts speeds when
> they join the IBSS cloud for the first time, and so it's limited to
> nodes already present at the moment of the join.

It looks like commit 6d810f10 changed the behavior.

The station addition notification is now passed to the driver before the
supported rates are updated for the peer (which happens via ieee80211_rx_bss_info()).
Drivers which offload rate control to the firmware but depend on mac80211 for
station management would be affected, I think.

Sujith
