Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1JXL1x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 07:27:53 -0400
Date: Mon, 24 Oct 2011 13:27:46 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eliad Peller <eliad@wizery.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: fix remain_off_channel regression
Message-ID: <20111024112745.GB2573@redhat.com> (sfid-20111024_132757_374588_EE7312F2)
References: <1319130350-15514-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1319130350-15514-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 07:05:49PM +0200, Eliad Peller wrote:
> The offchannel code is currently broken - we should
> remain_off_channel if the work was started, and
> the work's channel and channel_type are the same
> as local->tmp_channel and local->tmp_channel_type.
> 
> However, if wk->chan_type and local->tmp_channel_type
> coexist (e.g. have the same channel type), we won't
> remain_off_channel.
> 
> This behavior was introduced by commit da2fd1f
> ("mac80211: Allow work items to use existing
> channel type.")
> 
> Tested-by: Ben Greear <greearb@candelatech.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Both patches fixes serious bugs, should be marked
Cc: stable@kernel.org # 2.6.39+

I believe there is no need to repost, once informed
John would take care of process patches properly.

Stanislaw
