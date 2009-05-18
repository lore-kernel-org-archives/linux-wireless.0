Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45487 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZERTAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 15:00:12 -0400
Date: Mon, 18 May 2009 14:46:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH 3/4] cfg80211: fix in nl80211_set_reg()
Message-ID: <20090518184641.GI2814@tuxdriver.com>
References: <1242248682-22051-1-git-send-email-lrodriguez@atheros.com> <1242248682-22051-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1242248682-22051-4-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 05:04:41PM -0400, Luis R. Rodriguez wrote:
> There is a race on access to last_request and its alpha2
> through reg_is_valid_request() and us possibly processing
> first another regulatory request on another CPU. We avoid
> this improbably race by locking with the cfg80211_mutex as
> we should have done in the first place. While at it add
> the assert on locking on reg_is_valid_request().
> 
> Cc: stable@kernel.org
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

What is the effect of this race?  What justifies this for 2.6.30
and/or stable?  It is getting late in the cycle for 2.6.30...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
