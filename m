Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34937 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaG2Lzf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 07:55:35 -0400
Message-ID: <1406634925.7611.3.camel@jlt4.sipsolutions.net> (sfid-20140729_135538_379308_4A61F74E)
Subject: Re: [PATCH] mac80211: fix start_seq_num in Rx reorder offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Denton Gentry <denton.gentry@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 29 Jul 2014 13:55:25 +0200
In-Reply-To: <1406615792-1899-1-git-send-email-denton.gentry@gmail.com> (sfid-20140729_083646_259966_121DE7E1)
References: <1406615792-1899-1-git-send-email-denton.gentry@gmail.com>
	 (sfid-20140729_083646_259966_121DE7E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-28 at 23:36 -0700, Denton Gentry wrote:
> sta->last_seq_ctrl is the seq_ctrl field from the last header
> seen, need to shift it 4 bits to extract the sequence number.
> Otherwise the ieee80211_sn_less() check at the top of
> ieee80211_sta_manage_reorder_buf drops frames until the sequence
> number catches up.

Makes sense, applied, thanks.

johannes

