Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab0LPHDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 02:03:44 -0500
Subject: Re: Netlink Memory Leak Issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Saurabh8 Jain <saurabh8.jain@aricent.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <B659B0EE7F1D5A499E4A4BEB0BECBA2518292B3D21@GUREXMB01.ASIAN.AD.ARICENT.COM>
References: <B659B0EE7F1D5A499E4A4BEB0BECBA2518292B3D21@GUREXMB01.ASIAN.AD.ARICENT.COM>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 08:03:41 +0100
Message-ID: <1292483021.3542.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-16 at 11:01 +0530, Saurabh8 Jain wrote:
> Hi,
> 
> I would like to know the memory usage that happens between user space
> and kernel space communication. Communication happens via generic
> netlink library and we need to register doit and dump functions.

Yes.

> I was going through function "nl80211_set_mesh_params" in
> "net/wireless/nl80211.c" which receives values of mesh parameters. In
> this function skb is passed but it is never used and the skb is not
> freed. I saw other functions also which receives messages from user
> space but no memory is released for skb.

> Where is this memory getting free? Do I need to free this memory?

Look at net/netlink/ -- we don't need to handle that.

> When I executed iw commands to set few values in loop.  I saw there is
> drop in free memory of "top" command. I am working on
> compatwireless-2010-06-27.

You're seriously taking "top" for a measurement? That's like the worst
possible way to measure memory usage.

johannes

