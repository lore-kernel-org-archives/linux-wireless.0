Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946115Ab3BHIy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 03:54:29 -0500
Message-ID: <1360313661.29851.0.camel@jlt4.sipsolutions.net> (sfid-20130208_095433_183461_3D4168EB)
Subject: Re: [PATCH v2] mac80211: fix mesh sta teardown
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Fri, 08 Feb 2013 09:54:21 +0100
In-Reply-To: <1360174641-18347-1-git-send-email-thomas@cozybit.com> (sfid-20130206_191843_959203_E3919E1E)
References: <1360174641-18347-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130206_191843_959203_E3919E1E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 10:17 -0800, Thomas Pedersen wrote:
> The patch "mac80211: clean up mesh sta allocation warning"
> moved some mesh initialization into a path which is only
> called when the kernel handles peering. This causes a hang
> when mac80211 tries to clean up a userspace-allocated
> station entry and delete a timer which has never been
> initialized.
> 
> To avoid this, only do any mesh sta peering teardown if
> the kernel is actually handling it.
> 
> The same is true when quiescing before suspend.

Applied.

johannes

