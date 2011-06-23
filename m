Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab1FWIDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 04:03:48 -0400
Subject: Re: [PATCH] mac80211: reestablish mis-configured existing Rx BA
 sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308780927-20987-1-git-send-email-arik@wizery.com> (sfid-20110623_001553_707877_07396B5D)
References: <1308780927-20987-1-git-send-email-arik@wizery.com>
	 (sfid-20110623_001553_707877_07396B5D)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jun 2011 10:03:45 +0200
Message-ID: <1308816225.3865.1.camel@jlt3.sipsolutions.net> (sfid-20110623_100355_648029_84CDD6C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-06-23 at 01:15 +0300, Arik Nemtsov wrote:
> When forming a Rx BA session, sometimes the ADDBA response gets lost.
> This leads to a situation where the session is configured locally, but
> doesn't exist on the remote side. Subsequent ADDBA requests are declined
> by mac80211.
> 
> Fix this by assuming the session state of the initiator is the correct
> one. When receiving an unexpected ADDBA request on a TID with an active
> Rx BA session, delete the existing one and establish a new session.

It all does seem a little strange, but we might as well do this.

Acked-by: Johannes Berg <johannes@sipsolutions.net>


