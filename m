Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3KKN7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 08:59:23 -0500
Message-ID: <1384178360.14334.18.camel@jlt4.sipsolutions.net> (sfid-20131111_145926_443167_B831D7FC)
Subject: Re: [RFC v3 1/4] mac80211: don't transmit beacon with CSA count 0
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@intel.com>
Cc: linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Date: Mon, 11 Nov 2013 14:59:20 +0100
In-Reply-To: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
References: <1383921579-22373-1-git-send-email-luciano.coelho@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-08 at 16:39 +0200, Luciano Coelho wrote:
> A beacon should never have a Channel Switch Announcement information
> element with a count of 0, because a count of 1 means switch just
> before the next beacon.  So, if a count of 0 was valid in a beacon, it
> would have been transmitted in the next channel already, which is
> useless.  A CSA count equal to zero is only meaningful in action
> frames or probe_responses.
> 
> Fix the ieee80211_csa_is_complete() and ieee80211_update_csa()
> functions accordingly.

These seem fine to me - maybe we should have some CSA tests in Jouni's
hwsim test scripts, for the various cases? :)

johannes

