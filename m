Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44507
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbXGIU6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 16:58:31 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: Permissions down /sys
Date: Mon, 9 Jul 2007 22:57:25 +0200
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <469297DF.4000806@warmcat.com>
In-Reply-To: <469297DF.4000806@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707092257.25909.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 09 July 2007 22:17:35 Andy Green wrote:
> Hi folks -
> 
> Is 222 permissions on /sys/class/ieee80211/phy*/add_iface and
> remove_iface really okay, or should it perhaps be 220?
> 
> --w--w--w- 1 root root    0 2007-07-09 21:11 add_iface
> --w--w--w- 1 root root 4096 2007-07-09 21:12 remove_iface

IMO the file-permissions are correct, _but_ the following should
be added to _store_remove_iface() and _store_add_iface():

	if (!capable(CAP_NET_ADMIN))
		return -EPERM;

-- 
Greetings Michael.
