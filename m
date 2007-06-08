Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44872 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933212AbXFHAur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 20:50:47 -0400
Message-ID: <4668A7E5.3070500@lwfinger.net>
Date: Thu, 07 Jun 2007 19:50:45 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>	<20070607221939.444e9d74@griffin.suse.cz>	<20070607222113.0f752bf8@griffin.suse.cz> <20070607222210.1a445cd7@griffin.suse.cz>
In-Reply-To: <20070607222210.1a445cd7@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> This allows the lowest rate to be used all time.
> 
> To switch to this algorithm:
> echo -n lowest > {your_debugfs_mount_point}/ieee80211/phy?/rate_ctrl_alg
> 
> Signed-off-by: Jiri Benc <jbenc@suse.cz>

I do not think this particular rate control algorithm is needed. A patch has been submitted that 
will allow the user to use the SIOCSIWRATE ioctl to lock in a rate. In addition, a patch that 
changes rc80211_simple to set the initial rate to the lowest supported value has also been 
submitted. With these two alternatives, everything that this proposed module does is supported in 
other ways.

Larry

