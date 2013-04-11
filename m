Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:52839 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759700Ab3DKSnB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 14:43:01 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 11 Apr 2013 11:42:48 -0700
Subject: RE: [PATCH 1/2] mwifiex: replace ra_list_curr by list rotation.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE96B5F@SC-VEXCH1.marvell.com> (sfid-20130411_204315_401374_AE2ECA5A)
References: <477F20668A386D41ADCC57781B1F70430D9DE96073@SC-VEXCH1.marvell.com>
 <1365681068-27820-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <1365681068-27820-2-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1365681068-27820-2-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andi,

Thanks for the patch.

> After a packet is successfully transmitted, ra list is rotated, so the ra
> next to the one transmitted, will be the first in the list. This way we
> pick the ra' in a round robin fashion. This significantly simplifies
> iteration in  mwifiex_wmm_get_highest_priolist_ptr to a call to
> list_for_each_entry.
> List rotation is done via list_move, where the head itself is temporarily
> removed and then re-inserted after the item just transferred.
> 
> Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/11n_aggr.c |    8 +--
>  drivers/net/wireless/mwifiex/main.h     |    1 -
>  drivers/net/wireless/mwifiex/wmm.c      |   97 ++++++++++++-------------------
>  drivers/net/wireless/mwifiex/wmm.h      |    3 +
>  4 files changed, 40 insertions(+), 69 deletions(-)

