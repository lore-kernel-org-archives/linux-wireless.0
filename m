Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58861 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2FTSC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 14:02:28 -0400
Message-ID: <1340215345.19321.1.camel@jlt3.sipsolutions.net> (sfid-20120620_200231_926728_47B837EA)
Subject: Re: [PATCH 0/3 v4] mac80211: add support for userspace to handle
 auth frames on adhoc ifaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Hawkins <hawkinsw@opentechinstitute.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Date: Wed, 20 Jun 2012 20:02:25 +0200
In-Reply-To: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
References: <cover.1340142553.git.hawkinsw@opentechinstitute.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 17:59 -0400, Will Hawkins wrote:
> Hello!
> 
> I am sending along 3 patches to add support for user space applications
> to register for authentication frames on adhoc interfaces. These are
> revisions to a previous patch that I submitted to accomplish the same
> thing.
> 
> Patch 1/3 adds support for tracking whether userspace applications
> are registered for authentication frames received by an adhoc
> interface. This count is used in Patch 2/3 to determine 
> if an "open system" authentication frame is sent when a new 
> station joins an adhoc network.
> 
> Patch 2/3 adds support for checking the registration count
> before sending out "open system" authentication frames when a 
> new station joins an adhoc network. If there are no userspace
> applications registered for the authentication frames then 
> an "open system" authentication frame is broadcast. 
> 
> Patch 3/3 sets the necessary flags to allow userspace
> applications to register for authentication frames on adhoc interfaces.
> frames.

Applied all three. I looked at the code in patch 1 and decided to rework
the code there a little bit to make the flow depend on the frame type,
please check. I also reworded commit messages a bit (mostly to make it
clearer that it's all about IBSS.)

Thanks!

I'd like to see your userspace application btw :-)

johannes

