Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2KUKZe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 05:25:34 -0500
Message-ID: <1353493560.10444.12.camel@jlt4.sipsolutions.net> (sfid-20121121_112541_759714_E1B0426E)
Subject: Re: [PATCH v2] mac80211: fix channel context suspend/reconfig
 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sujith@msujith.org, eliad@wizery.com
Date: Wed, 21 Nov 2012 11:26:00 +0100
In-Reply-To: <1353404309-17381-1-git-send-email-johannes@sipsolutions.net> (sfid-20121120_103813_110341_2183B17C)
References: <1353360586-32157-1-git-send-email-johannes@sipsolutions.net>
	 <1353404309-17381-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121120_103813_110341_2183B17C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-20 at 10:38 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Sujith reported warnings with suspend/resume due to
> channel contexts. When I looked into it, I realised
> that the code was completely broken as it unassigned
> the channel contexts when suspending, which actually
> means they are destroyed.
> 
> Eliad Peller then pointed out that we also need to
> remove the channel contexts from the driver. When I
> looked into this, I also noticed that the code isn't
> handling the virtual monitor interface correctly (if
> it exists.)
> 
> Fix this by calling just the driver methods (if they
> are implemented) instead of using the channel context
> management code. Also add reconfiguration for the
> virtual monitor interface.

Applied.

johannes

