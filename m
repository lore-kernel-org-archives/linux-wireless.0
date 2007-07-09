Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:37587 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781AbXGIVD6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 17:03:58 -0400
Message-ID: <4692A2B9.2040004@warmcat.com>
Date: Mon, 09 Jul 2007 22:03:53 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Permissions down /sys
References: <469297DF.4000806@warmcat.com> <200707092257.25909.mb@bu3sch.de>
In-Reply-To: <200707092257.25909.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 09 July 2007 22:17:35 Andy Green wrote:
>> Hi folks -
>>
>> Is 222 permissions on /sys/class/ieee80211/phy*/add_iface and
>> remove_iface really okay, or should it perhaps be 220?
>>
>> --w--w--w- 1 root root    0 2007-07-09 21:11 add_iface
>> --w--w--w- 1 root root 4096 2007-07-09 21:12 remove_iface
> 
> IMO the file-permissions are correct, _but_ the following should
> be added to _store_remove_iface() and _store_add_iface():
> 
> 	if (!capable(CAP_NET_ADMIN))
> 		return -EPERM;
> 

Fair enough... one or the other needs doing though because right now you
can delete wlan0 as a mortal user (just tried it... you can't nuke
wmaster0 though) and I guess exhaust the possible max interfaces too.  I
made a patch changing the perms to  S_IWUSR|S_IWGRP, but your method is
smarter.

-Andy

