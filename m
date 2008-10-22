Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54837 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806AbYJVSh5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 14:37:57 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 11:37:57 -0700
Date: Wed, 22 Oct 2008 04:37:51 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: fix regdom passing semantics
Message-ID: <20081022113751.GD6190@tesla> (sfid-20081022_203804_683846_64BB8640)
References: <1224579720.5521.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224579720.5521.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2008 at 02:02:00AM -0700, Johannes Berg wrote:
> the current documentation doesn't
> note that you need to free it on errors anyway.

Yes it does.

>  /* Use this call to set the current regulatory domain. Conflicts with
>   * multiple drivers can be ironed out later. Caller must've already
> - * kmalloc'd the rd structure. If this calls fails you should kfree()
                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
See?

> - * the passed rd. Caller must hold cfg80211_drv_mutex */
> + * kmalloc'd the rd structure. Caller must hold cfg80211_drv_mutex */

But this is fine too, so long as we keep the docs in sync.

  Luis
