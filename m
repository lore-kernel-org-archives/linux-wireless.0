Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49835 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3LPNPA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 08:15:00 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21166.64423.30022.947286@gargle.gargle.HOWL> (sfid-20131216_141502_926615_C0784D39)
Date: Mon, 16 Dec 2013 18:39:59 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 06/11] ath9k_hw: remove ah->config.pcie_clock_req
In-Reply-To: <52AEE12F.5020008@openwrt.org>
References: <1387040625-38114-1-git-send-email-nbd@openwrt.org>
	<1387040625-38114-6-git-send-email-nbd@openwrt.org>
	<21166.30518.304613.545323@gargle.gargle.HOWL>
	<52AEE12F.5020008@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Fine with me, let's leave this one out and merge the others (if there
> aren't any other issues).

Station mode seems fine with the series, I didn't get a chance to test
IBSS or P2P.

In AP mode, the timestamp in the first beacon is higher than earlier, since
we no longer reset the HW TSF when enabling beaconing and there is a
window between start() and enable_beacon(). I am not sure if this is a
problem, but I think the spec has something to say about BSS creation in
infrastructure mode.

Sujith
