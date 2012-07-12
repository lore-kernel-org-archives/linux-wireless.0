Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47092 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab2GLG3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 02:29:19 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20478.28271.704162.754323@gargle.gargle.HOWL> (sfid-20120712_082923_596415_1369E5D7)
Date: Thu, 12 Jul 2012 11:57:59 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: [PATCH 08/12] ath9k: fix aggregate size limit based on queue TXOP limit
In-Reply-To: <1342029555-31618-8-git-send-email-nbd@openwrt.org>
References: <1342029555-31618-1-git-send-email-nbd@openwrt.org>
	<1342029555-31618-2-git-send-email-nbd@openwrt.org>
	<1342029555-31618-3-git-send-email-nbd@openwrt.org>
	<1342029555-31618-4-git-send-email-nbd@openwrt.org>
	<1342029555-31618-5-git-send-email-nbd@openwrt.org>
	<1342029555-31618-6-git-send-email-nbd@openwrt.org>
	<1342029555-31618-7-git-send-email-nbd@openwrt.org>
	<1342029555-31618-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> If the aggregate size exceeds the TXOP limit, it leads to lots of unnecessary
> hardware and software retries.
> 
> The previous 4ms frame limit table was completely undocumented, the commit
> that updated it only vaguely referenced and equation from the standard,
> but I've been unable to replicate its results.
> 
> Fix this by using a formula based on the code in ath_pkt_duration, which is
> more likely to be correct for this case.

I think this needs to be verified. The 4ms restriction is for Japanese
regulatory compliance, IIRC.

Sujith
