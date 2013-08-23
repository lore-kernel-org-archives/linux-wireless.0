Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3HWKCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 06:02:04 -0400
Message-ID: <1377252117.14021.18.camel@jlt4.sipsolutions.net> (sfid-20130823_120209_259405_00370AB5)
Subject: Re: [PATCH] mac80211: minstrel_ht: don't use control.flags in TX
 status path
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date: Fri, 23 Aug 2013 12:01:57 +0200
In-Reply-To: <1377153566-15478-1-git-send-email-johannes@sipsolutions.net> (sfid-20130822_083934_765528_45353E2F)
References: <1377153566-15478-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130822_083934_765528_45353E2F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-08-22 at 08:39 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Sujith reports that my commit af61a165187bb94b1dc7628ef815c23d0eacf40b
> ("mac80211: add control port protocol TX control flag") broke ath9k
> (aggregation). The reason is that I made minstrel_ht use the flag in
> the TX status path, where it can have been overwritten by the driver.
> Since we have no more space in info->flags, revert that part of the
> change for now, until we can reshuffle the flags or so.

Applied.

johannes

