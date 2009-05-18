Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45485 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbZERTAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 15:00:12 -0400
Date: Mon, 18 May 2009 14:47:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH 4/4] cfg80211: fix race between core hint and driver's
	custom apply
Message-ID: <20090518184718.GJ2814@tuxdriver.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com> <1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242248682-22051-5-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 05:04:42PM -0400, Luis R. Rodriguez wrote:
> Its possible for cfg80211 to have scheduled the work and for
> the global workqueue to not have kicked in prior to a cfg80211
> driver's regulatory hint or wiphy_apply_custom_regulatory().
> 
> Although this is very unlikely its possible and should fix
> this race. When this race would happen you are expected to have
> hit a null pointer dereference panic.
> 
> Cc: stable@kernel.org
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

(Same questions as for 3/4...)

What is the effect of this race?  What justifies this for 2.6.30
and/or stable?  It is getting late in the cycle for 2.6.30...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
