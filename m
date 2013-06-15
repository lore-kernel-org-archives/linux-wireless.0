Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog137.obsmtp.com ([74.125.149.18]:48264 "EHLO
	na3sys009aog137.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750706Ab3FOEHj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 00:07:39 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 14 Jun 2013 21:08:29 -0700
Subject: RE: [PATCH] mwifiex: fix memory corruption when unsetting multicast
 list
Message-ID: <477F20668A386D41ADCC57781B1F70430EA2AA1E6E@SC-VEXCH1.marvell.com> (sfid-20130615_060752_477456_271929EC)
References: <20130614192424.9463CFAAC8@dev.laptop.org>
In-Reply-To: <20130614192424.9463CFAAC8@dev.laptop.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

Thanks for the patch.

> When trying to unset a previously-set multicast list (i.e. the new list
> has 0 entries), mwifiex_set_multicast_list() was calling down to
> mwifiex_request_set_multicast_list() while leaving
> mcast_list.num_multicast_addr as an uninitialized value.
> 
> We were arriving at mwifiex_cmd_mac_multicast_adr() which would then
> proceed to do an often huge memcpy of
> mcast_list.num_multicast_addr*ETH_ALEN bytes, causing memory corruption
> and hard to debug crashes.
> 
> Fix this by setting mcast_list.num_multicast_addr to 0 when no multicast
> list is provided. Similarly, fix up the logic in
> mwifiex_request_set_multicast_list() to unset the multicast list that
> was previously sent to the hardware in such cases.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/main.c      |  5 ++---
>  drivers/net/wireless/mwifiex/sta_ioctl.c | 18 ++++++++----------
>  2 files changed, 10 insertions(+), 13 deletions(-)

