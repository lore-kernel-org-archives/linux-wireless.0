Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab3LPMzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:55:22 -0500
Message-ID: <1387198518.4665.29.camel@jlt4.sipsolutions.net> (sfid-20131216_135525_478219_5E1AE12E)
Subject: Re: [PATCH 3/3] mac80211: update adjusting TBTT bit in beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <twpedersen@gmail.com>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 16 Dec 2013 13:55:18 +0100
In-Reply-To: <1387142056-21850-3-git-send-email-twpedersen@gmail.com> (sfid-20131215_221523_822205_B4A0108F)
References: <1387142056-21850-1-git-send-email-twpedersen@gmail.com>
	 <1387142056-21850-3-git-send-email-twpedersen@gmail.com>
	 (sfid-20131215_221523_822205_B4A0108F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-12-15 at 13:14 -0800, Thomas Pedersen wrote:
> From: Thomas Pedersen <thomas@cozybit.com>
> 
> This regression was introduced in "mac80211: cache mesh
> beacon".
> 
> mesh_sync_offset_adjust_tbtt()  was assuming that the
> beacon would be rebuilt in every single pre-tbtt
> interrupt, but now the beacon update happens on the
> workqueue, and it must be ready for immediate delivery to
> the driver.
> 
> Save a pointer to the meshconf IE in the beacon_data (this
> works because both the IE pointer and beacon buffer are
> protected by the same rcu_{dereference,assign_pointer}())
> for quick updates during pre-tbtt. This is faster and a
> little prettier than iterating over the elements to find
> the meshconf IE every time.

Applied, since it doesn't look like this depends on patch 2. I'll let
you discuss patch 2 with Sergey first, though I'm of the opinion that if
there's no per-vif TSF in your hardware then you're SOL anyway and what
you did is fine.

johannes

