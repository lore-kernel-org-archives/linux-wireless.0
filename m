Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42303 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754700Ab1KNOkx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 09:40:53 -0500
Message-ID: <4EC12871.2070402@openwrt.org> (sfid-20111114_154101_861508_DEE31355)
Date: Mon, 14 Nov 2011 15:40:49 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 3/3] mac80211: Get rid of search loop for rate group index
References: <1321280900-24006-1-git-send-email-helmut.schaa@googlemail.com> <1321280900-24006-2-git-send-email-helmut.schaa@googlemail.com> <1321280900-24006-3-git-send-email-helmut.schaa@googlemail.com>
In-Reply-To: <1321280900-24006-3-git-send-email-helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-14 3:28 PM, Helmut Schaa wrote:
> Finding the group index for a specific rate is done by looping through
> all groups and returning if the correct one is found. This code is
> called for each tx'ed frame and thus it makes sense to reduce its
> runtime.
>
> Do this by calculating the group index by this formula based on the SGI
> and HT40 flags as well as the stream number:
>
> idx = (HT40 * 2 * MINSTREL_MAX_STREAMS) +
>        (SGI * MINSTREL_MAX_STREAMS) +
>        (streams - 1)
>
> Hence, the groups are ordered by th HT40 flag first, then by the SGI
> flag and afterwards by the number of used streams.
>
> This should reduce the runtime of minstrel_ht_get_group_idx
> considerable.
>
> Signed-off-by: Helmut Schaa<helmut.schaa@googlemail.com>
For the whole series:
Acked-by: Felix Fietkau <nbd@openwrt.org>
