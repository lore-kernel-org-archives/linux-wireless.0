Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48592 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171Ab3KRWz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 17:55:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21130.39398.379492.921373@gargle.gargle.HOWL> (sfid-20131118_235601_704235_9A3A66C7)
Date: Tue, 19 Nov 2013 04:21:18 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/2] ath9k_hw: fix TSF save/restore around chip reset
In-Reply-To: <1384802084-55082-1-git-send-email-nbd@openwrt.org>
References: <1384802084-55082-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> A cold reset can be triggered because of DMA stop issues, and this leads
> to TSF being cleared on all chipsets. To properly deal with this, always
> save the TSF.

I think this needs to be done only when we are in operational state.
There is no need to do this before the station interface is associated
or the AP interface is up.

Sujith
