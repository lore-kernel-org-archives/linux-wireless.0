Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18434 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbbBYHHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 02:07:49 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <egrumbach@gmail.com>
Subject: Re: [RFC] zero-copy AMSDU processing
Date: Wed, 25 Feb 2015 09:07:45 +0200
Message-ID: <3723348.23HgaGqW1o@lx-wigig-72> (sfid-20150225_080752_066652_1503DF4A)
In-Reply-To: <1424680539.2782.1.camel@sipsolutions.net>
References: <1708052.J876aMsZU2@lx-wigig-72> <1424680539.2782.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, February 23, 2015 09:35:39 AM Johannes Berg wrote:
> If the SKB has pages (rather than being linear, as
> ieee80211_amsdu_to_8023s() assumes) then what Emmanuel said would
> probably be the best approach, although it could be possible that would
> mess up truesize accounting and lead to lower performance. Certainly
> you'd want to do it only for suitably large packets (at least bigger
> than 128 bytes or so)

Why is it important whether it has pages? Looks like I can play with
pointers to the linear part as well.

I am thinking about the following scenario: in DMG (60G), max. MSDU size
is 7920, so one have to account for this when establishing BACK. Then,
I foresee it will be popular that MTU will be configured to 1500 (Ethernet
bridging, just laziness etc.), so actual aggregations on the air would be 5x
smaller that it could be. Then, I'd like to aggregate 5 packets 1500 bytes
each into A-MSDU prior to aggregating it to A_MPDU. Then, I'll have
good A-MPDU size. But, having more then 2Gbps throughput, I need
effective way to de-aggregate A-MSDU on Rx side.

Thanks, Vladimir
