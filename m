Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:56677 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752179Ab3DKSpb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 14:45:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andreas Fenkart <andreas.fenkart@streamunlimited.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"daniel@zonque.org" <daniel@zonque.org>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Thu, 11 Apr 2013 11:43:36 -0700
Subject: RE: [PATCH 2/2] mwifiex: rework round robin scheduling of bss nodes.
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE96B62@SC-VEXCH1.marvell.com> (sfid-20130411_204538_725162_5CEF4B27)
References: <477F20668A386D41ADCC57781B1F70430D9DE96073@SC-VEXCH1.marvell.com>
 <1365681068-27820-1-git-send-email-andreas.fenkart@streamunlimited.com>
 <1365681068-27820-3-git-send-email-andreas.fenkart@streamunlimited.com>
In-Reply-To: <1365681068-27820-3-git-send-email-andreas.fenkart@streamunlimited.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Rotate bss prio list, so the bss next to the one served, will come first
> in the list of bss' with equal priority. This way we pick bss nodes in a
> round robin fashion. Using list rotation instead of a cur ptr simplifies
> iteration to calling list_for_each_entry. List rotation is done via
> list_move, where the head itself is temporarily removed and then
> re-inserted after the bss just served.
> 
> Signed-off-by: Andreas Fenkart <andreas.fenkart@streamunlimited.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/11n_aggr.c |    6 ---
>  drivers/net/wireless/mwifiex/init.c     |   21 +++-----
>  drivers/net/wireless/mwifiex/wmm.c      |   79 +++++++++----------------------
>  3 files changed, 29 insertions(+), 77 deletions(-)

