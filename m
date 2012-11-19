Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2KSVie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 16:38:34 -0500
Message-ID: <1353361141.18299.36.camel@jlt4.sipsolutions.net> (sfid-20121119_223837_671413_751F6ED8)
Subject: Re: [PATCH v2 1/2] ath9k: RX timestamp is reported at end of frame
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: ath9k-devel@lists.ath9k.org, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 22:39:01 +0100
In-Reply-To: <1352832488-21516-1-git-send-email-thomas@cozybit.com> (sfid-20121113_194834_470128_522632A3)
References: <1352832488-21516-1-git-send-email-thomas@cozybit.com>
	 (sfid-20121113_194834_470128_522632A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 10:48 -0800, Thomas Pedersen wrote:
> Accurate RX timestamp reporting is important for proper IBSS merging,
> mesh synchronization, and MCCA scheduling. Namely, knowing where the TSF
> is recorded is needed to sync with the beacon timestamp field.

> -       rx_status->flag |= RX_FLAG_MACTIME_MPDU;
> +	rx_status->flag |= RX_FLAG_MACTIME_END;

This and the other similar patches obviously won't apply any more.

Before you repost though I think it would make sense to fix the
calculation issue that Simon pointed out on the radiotap list? I hope he
comes up with some code though as I'm not good enough at bitrate
calculations :-)

johannes

