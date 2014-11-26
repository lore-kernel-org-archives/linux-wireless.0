Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53047 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaKZVVQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 16:21:16 -0500
Date: Wed, 26 Nov 2014 22:21:15 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jonathan Doron <jond@wizery.com>
Subject: Re: [PATCH v4 2/4] cfg80211: allow wiphy specific regdomain
	management
Message-ID: <20141126212115.GS25677@wotan.suse.de> (sfid-20141126_222119_425383_F9D2BB2A)
References: <1417035388-2511-1-git-send-email-arik@wizery.com> <1417035388-2511-2-git-send-email-arik@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417035388-2511-2-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2014 at 10:56:26PM +0200, Arik Nemtsov wrote:
> From: Jonathan Doron <jond@wizery.com>
> 
> Add a new regulatory flag that allows a driver to manage regdomain
> changes/updates for its own wiphy.
> A self-managed wiphys only employs regulatory information obtained from
> the FW and driver and does not use other cfg80211 sources like
> beacon-hints, country-code IEs and hints from other devices on the same
> system. Conversely, a self-managed wiphy does not share its regulatory
> hints with other devices in the system. If a system contains several
> devices, one or more of which are self-managed, there might be
> contradictory regulatory settings between them. Usage of flag is
> generally discouraged. Only use it if the FW/driver is incompatible
> with non-locally originated hints.
> 
> A new API lets the driver send a complete regdomain, to be applied on
> its wiphy only.
> 
> After a wiphy-specific regdomain change takes place, usermode will get
> a new type of change notification. The regulatory core also takes care
> enforce regulatory restrictions, in case some interfaces are on
> forbidden channels.
> 
> Signed-off-by: Jonathan Doron <jonathanx.doron@intel.com>
> Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>

Reviewed-by: Luis R. Rodriguez <mcgrof@suse.com>

 Luis
