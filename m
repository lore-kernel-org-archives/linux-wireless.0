Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17276 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab2IRWEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2012 18:04:39 -0400
From: Sujith Manoharan <c_manoha@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20568.61367.396914.490762@gargle.gargle.HOWL> (sfid-20120919_000443_399366_16779FB1)
Date: Wed, 19 Sep 2012 03:33:35 +0530
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: Sujith Manoharan <c_manoha@qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k: spurious queue reset (beacon stuck) when
 joining an IBSS.
In-Reply-To: <5058899F.1090906@lri.fr>
References: <50582CF8.4020608@lri.fr>
	<5058737E.4090601@lri.fr>
	<20568.31520.887555.183389@gargle.gargle.HOWL>
	<5058899F.1090906@lri.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicolas Cavallari wrote:
> With this patch, i see no beacon miss in the logs when joining a large
> ad-hoc network. So yes, it does make a difference! haven't tested what
> happens when creating an IBSS with or without this patch yet.

The beacon-sync shouldn't be done when we are creating an IBSS network.
Currently, mac80211 doesn't give the necessary information to the driver,
I'll propose a patch.

Sujith
