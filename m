Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab1LNWRV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 17:17:21 -0500
Subject: Re: [PATCH v2] mac80211: Purge A-MPDU TX queues before station
 destructions
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
In-Reply-To: <20111208092608.GA4981@hertz.marvell.com>
References: <20111208092608.GA4981@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Dec 2011 23:17:17 +0100
Message-ID: <1323901037.3599.6.camel@jlt3.sipsolutions.net> (sfid-20111214_231732_126218_E426EBE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-08 at 14:56 +0530, Yogesh Ashok Powar wrote:

> +	/* There could be some memory leaks because of ampdu tx pending queue
> +	 * not being freed before destroying the station info.
> +	 *
> +	 * Make sure that such queues are purged before freeing the station
> +	 * info.
> +	 * TODO: We have to somehow postpone the full destruction
> +	 * until the aggregation stop completes. Refer
> +	 * http://thread.gmane.org/gmane.linux.kernel.wireless.general/81936
> +	 */
> +	for (i = 0; i < STA_TID_NUM; i++) {
> +		if (!sta->ampdu_mlme.tid_tx[i])
> +			continue;
> +		tid_tx = sta->ampdu_mlme.tid_tx[i];

Please address the sparse warning this creates with
CONFIG_SPARSE_RCU_POINTER=y

johannes

