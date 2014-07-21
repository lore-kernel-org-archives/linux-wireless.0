Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46723 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbaGUODy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 10:03:54 -0400
Message-ID: <1405951429.32255.23.camel@jlt4.sipsolutions.net> (sfid-20140721_160358_281832_71CED3F6)
Subject: Re: [PATCH] mac80211: remove useless NULL check
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Eytan Lifshitz <eytan.lifshitz@intel.com>
Date: Mon, 21 Jul 2014 16:03:49 +0200
In-Reply-To: <1405945121-5360-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1405945121-5360-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-21 at 15:18 +0300, Emmanuel Grumbach wrote:
> From: Eytan Lifshitz <eytan.lifshitz@intel.com>
> 
> sdata can't be NULL, don't add a superfluous check.
> This check made a static analyze (klocwork) unhappy because
> we would get pointer to local (sdata->local) and only then
> check if sdata is non-NULL.

Applied, I decided to change it to remove the !key check as well.

johannes

