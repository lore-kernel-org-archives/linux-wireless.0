Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab0HJRSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 13:18:41 -0400
Subject: Re: [ipw3945-devel] [PATCH 0/1] fix for 2.6.35
From: Johannes Berg <johannes@sipsolutions.net>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1281459872.6027.6.camel@wwguy-ubuntu>
References: <1281376622-6835-1-git-send-email-wey-yi.w.guy@intel.com>
	 <AANLkTinJtJGQCgpWCu5t+EF7bEvXR3cQG7oHuagrjd1a@mail.gmail.com>
	 <1281459872.6027.6.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 19:18:36 +0200
Message-ID: <1281460716.3759.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-10 at 10:04 -0700, Guy, Wey-Yi wrote:

> > This patch has an awesome commit log entry and describes issues with
> > the current RTS mechanism and improvements made on the patch for
> > different scenarios 

:-)

> > but in no way talks about issues with association
> > with 5 GHz APs. Can you clarify in the commit log how it cures issues
> > with 5 GHz, if that is indeed an intended fix for it?

> Johannes might be able to add more, the original attempt of this patch
> is to prevent un-necessary protection for non-data frames which we
> introduced few rc ago. while we fix this, but we also found out this
> patch also address the issue we have for 5GHz unable to associate to AP.

Well it does describe what it's intended to fix, we just found out that
a side effect of trying to protect too many frames can be, but maybe
isn't always, that you can't associate on 5 GHz because the protection
mechanism fails on the direct probe probe request frame ...

johannes

