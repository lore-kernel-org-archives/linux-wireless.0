Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2FLQ4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2012 12:56:47 -0400
Date: Tue, 12 Jun 2012 11:56:42 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/9] brcm80211: smac: rework regulatory support
Message-ID: <20120612165642.GG11723@thinkpad-t410> (sfid-20120612_185651_490237_7DA179C9)
References: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1338906849-26135-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 05, 2012 at 09:34:00AM -0500, Seth Forshee wrote:
> brcmsmac has its own internal regulatory implementation which attempts
> to enforce a Broadcom defined domain named X2. This code has no
> integration with mac80211 regulatory other than supplying regulatory
> hints, and thus each implementation operates independently of the other,
> enforcing conflicting sets of rules.
> 
> This series of patches converts brcmsmac to relying on the mac80211
> regulatory implementation. The X2 domain is registered with mac80211,
> and brcmsmac is converted to using the constraints from mac80211 for
> hardware configuration. Much code is removed in the process :)
> 
> There is one holdover from the old regulatory implementation. The MIMO
> tx power limits for brcmsmac are still being configured based on
> internal data for the X2 domain. Arend is trying to find out how these
> need to be handled, but this can be changed at a later time.
> 
> Changes since version 1:
> 
>  - Dropped patch to remove support for DFS channels
>  - Added back application of flags for radar channels on regulatory
>    updates from RFC patches, with minor simplifications
>  - Removed unneeded NULL pointer check from regulatory notifier callback
> 
> Thanks,
> Seth

Any more issues with this round that need to be addressed? If so I'd
like to get to work on them soon, so that we can hopefully get this
stuff in for 3.6.

Thanks,
Seth

