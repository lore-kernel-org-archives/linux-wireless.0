Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965211AbXDYMJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 08:09:54 -0400
Message-ID: <20227.131.234.232.81.1177502988.squirrel@secure.sipsolutions.net>
In-Reply-To: <200704241425.01152.flamingice@sourmilk.net>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
    <200704231722.07280.flamingice@sourmilk.net>
    <462E47D0.8030800@warmcat.com>
    <200704241425.01152.flamingice@sourmilk.net>
Date: Wed, 25 Apr 2007 14:09:48 +0200 (CEST)
Subject: Re: [PATCH 03/13] mac80211: fix virtual interface related locking
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Michael Wu" <flamingice@sourmilk.net>
Cc: "Andy Green" <andy@warmcat.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> This is fine, though it would be nice if we can shut the warning off.
> Virtual
> interfaces can try to take the xmit lock of the master device, but the
> master
> device will never try to take the xmit lock of the virtual interfaces and
> especially not while holding its own xmit lock.

You can shut the warning off by explicitly labeling the master lock as
belonging to a different class or something. Bridging code has similar
things IIRC, maybe check there.

johannes
