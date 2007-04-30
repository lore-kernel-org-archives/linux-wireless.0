Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:36560 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423726AbXD3Vsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 17:48:51 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1Hidh3-0001Kl-JO
	for linux-wireless@vger.kernel.org; Mon, 30 Apr 2007 17:46:01 -0400
Subject: Re: [PATCH] mac80211: mark as experimental
From: Pavel Roskin <proski@gnu.org>
To: Jiri Benc <jbenc@suse.cz>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070430201742.1f53aa40@griffin.suse.cz>
References: <20070430201742.1f53aa40@griffin.suse.cz>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 17:48:43 -0400
Message-Id: <1177969723.26986.30.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-04-30 at 20:17 +0200, Jiri Benc wrote:
> Make the stack depend on EXPERIMENTAL. Also, change the name from "dscape"
> to "mac80211".

Why is it needed to make mac80211 EXPERIMENTAL?  With mac80211 already
in Ubuntu 7.04 and in the forthcoming Fedora 7, it must have received
more testing than some drivers not marked as EXPERIMENTAL.

I don't think enabling mac80211 per se would destabilize the kernel.
Individual drivers could be marked experimental.  In particular,
bcm43xx_mac80211 needs such designation, since the softmac version is
much better currently.

If we encourage enabling mac80211, it would make it easier for the users
to compile and test mac80211 based drivers, such as iwlwifi.  Even
bcm43xx_mac80211 could be packaged separately to allow compilation
against an existing kernel for the users who want to test it without
upgrading the kernel.

In my opinion, marking mac80211 as EXPERIMENTAL would hinder testing of
mac80211 drivers without having any positive effect on the users who
want stability.

-- 
Regards,
Pavel Roskin

