Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55146 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3AXPEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:04:12 -0500
Message-ID: <1359039873.21908.2.camel@jlt4.sipsolutions.net> (sfid-20130124_160416_408144_ADCA49CA)
Subject: Re: [PATCH 1/2] mac80211: clean up mesh sta allocation warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Thu, 24 Jan 2013 16:04:33 +0100
In-Reply-To: <1358972293-2884-1-git-send-email-thomas@cozybit.com> (sfid-20130123_211856_818608_4892DABF)
References: <1358972293-2884-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130123_211856_818608_4892DABF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-23 at 12:18 -0800, Thomas Pedersen wrote:
> This refactoring fixes a "scheduling while atomic" warning
> when allocating a mesh station entry while holding the RCU
> read lock. Fix this by creating a new function
> mesh_sta_info_get(), which correctly handles the locking
> and returns under RCU.
> 
> Also move some unnecessarily #ifdefed mesh station init
> code from sta_info_alloc() to __mesh_sta_info_alloc().

Applied, I changed it to a bit to make sparse able to prove correctness.

johannes

