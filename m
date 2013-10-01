Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab3JALZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:25:35 -0400
Message-ID: <1380626731.14430.29.camel@jlt4.sipsolutions.net> (sfid-20131001_132538_062516_7E4981E0)
Subject: Re: [PATCH 3/5] mac80211: adding the CSA and MCSP elements in mesh
 beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Tue, 01 Oct 2013 13:25:31 +0200
In-Reply-To: <1379115372-28426-4-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130914_013632_254484_1037AED5)
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1379115372-28426-4-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130914_013632_254484_1037AED5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject should probably just say "add", not "adding".

Should this patch be before the other one so userspace can't trigger an
invalid CSA thing inbetween the two patches?


> +	if (ifmsh->csa_settings) {

> +		*pos++ = ieee80211_frequency_to_channel(
> +				ifmsh->csa_settings->chandef.chan->center_freq);

Why is that csa_settings access not racy?

johannes

