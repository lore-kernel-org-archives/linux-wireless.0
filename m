Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab2KTJTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:19:44 -0500
Message-ID: <1353403213.9399.7.camel@jlt4.sipsolutions.net> (sfid-20121120_101948_248732_AD4BC515)
Subject: Re: [PATCH] mac80211: fix channel context suspend handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sujith@msujith.org
Date: Tue, 20 Nov 2012 10:20:13 +0100
In-Reply-To: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net> (sfid-20121119_222924_703970_D27B6648)
References: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121119_222924_703970_D27B6648)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 22:29 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Sujith reported warnings with suspend/resume due to
> channel contexts. When I looked into it, I realised
> that the code was completely broken as it unassigned
> the channel contexts when suspending, which actually
> means they are destroyed.
> 
> Fix this by calling just the driver method (if it is
> implemented) instead of trying to use the mac80211
> channel context management code.

Applied.

johannes

