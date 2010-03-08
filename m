Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0CHIB4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 03:01:56 -0500
Subject: Re: [PATCH] libipw: split ieee->networks into small pieces
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1268025483-9267-1-git-send-email-yi.zhu@intel.com>
References: <1268025483-9267-1-git-send-email-yi.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 09:01:49 +0100
Message-ID: <1268035309.3819.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-08 at 13:18 +0800, Zhu Yi wrote:
> The ieee->networks consists of 128 struct libipw_network entries. If
> we allocate this chunk of memory altogether, it ends up with an
> order 4 page allocation. High order page allocation is likely to fail
> on system high load. This patch splits the big chunk memory allocation
> into small pieces, each is 344 bytes, allocates them with 128 times.
> 
> The patch fixed bug http://bugzilla.kernel.org/show_bug.cgi?id=14989

Could it use cfg80211's scan list stuff and the wext handlers for
scanning there?

johannes

