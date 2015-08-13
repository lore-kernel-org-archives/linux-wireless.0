Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47825 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbbHMLxR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 07:53:17 -0400
Message-ID: <1439466790.2114.21.camel@sipsolutions.net> (sfid-20150813_135336_979683_FB9596FD)
Subject: Re: [PATCH] mac80211: fix invalid read in
 minstrel_sort_best_tp_rates()
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrien Schildknecht <adrien+dev@schischi.me>, davem@davemloft.net,
	thomas@net.t-labs.tu-berlin.de
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Date: Thu, 13 Aug 2015 13:53:10 +0200
In-Reply-To: <1438072216-19228-1-git-send-email-adrien+dev@schischi.me> (sfid-20150728_103052_520611_9034FF48)
References: <1438072216-19228-1-git-send-email-adrien+dev@schischi.me>
	 (sfid-20150728_103052_520611_9034FF48)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-07-28 at 10:30 +0200, Adrien Schildknecht wrote:
> At the last iteration of the loop, j may equal zero and thus
> tp_list[j - 1] causes an invalid read.
> Changed the logic of the loop so that j - 1 is always >= 0.
> 
> Signed-off-by: Adrien Schildknecht <adrien+dev@schischi.me>
> 
Applied, I added Cc stable.

johannes
