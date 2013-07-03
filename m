Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:49835 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964870Ab3GCSlt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:49 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	Amitkumar Karwar <akarwar@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Wed, 3 Jul 2013 11:41:24 -0700
Subject: RE: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2E06694@SC-VEXCH1.marvell.com> (sfid-20130703_204240_774919_B5AA59F9)
References: <20130703015653.82651FAAD5@dev.laptop.org>
In-Reply-To: <20130703015653.82651FAAD5@dev.laptop.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

> When the card is being removed, mwifiex_remove_card() immediately sets
> surprise_removed to 1. This flag then causes the SDIO interrupt handler
> to ignore all interrupts without even acking them.

Since the card is removed, even if there is a pending interrupt received after card removal, it's not possible to ack it or disable interrupts. We cannot access hardware registers after card removal.

Perhaps you are talking about unloading driver (rmmod mwifiex_sdio) instead?

Thanks,
Bing


