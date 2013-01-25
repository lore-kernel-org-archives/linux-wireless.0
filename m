Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3AYT5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 14:57:35 -0500
Message-ID: <1359143876.4655.19.camel@jlt4.sipsolutions.net> (sfid-20130125_205738_783824_A22D9B45)
Subject: Re: [PATCH] cfg80211: don't dereference NULL chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	simon.wunderlich@s2003.tu-chemnitz.de
Date: Fri, 25 Jan 2013 20:57:56 +0100
In-Reply-To: <1359143275-28359-1-git-send-email-thomas@cozybit.com> (sfid-20130125_204900_652355_81D744E6)
References: <1359143275-28359-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130125_204900_652355_81D744E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-25 at 11:47 -0800, Thomas Pedersen wrote:
> The patch "cfg80211: check radar interface combinations"
> would dereference chan even though this may be NULL. Fix a
> page fault when adding a new interface by adding a
> short-circuit check for NULL.
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
> 
> No action required for this to make it into 3.8, right?

It doesn't have to go to 3.8 since the original patch isn't going there,
and I already have the same fix:
683d41ae6755e6ae297ec09603c229795ab9566e

johannes

