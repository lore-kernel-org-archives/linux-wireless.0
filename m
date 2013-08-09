Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37903 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967237Ab3HIG4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 02:56:40 -0400
Message-ID: <1376031393.8355.0.camel@jlt4.sipsolutions.net> (sfid-20130809_085643_944475_59C6586D)
Subject: Re: [PATCHv2] cfg/nl80211: send CMD_INTERFACE event on
 NETDEV_UNREGISTER
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Fri, 09 Aug 2013 08:56:33 +0200
In-Reply-To: <1376004275-606-1-git-send-email-ordex@autistici.org>
References: <1376004275-606-1-git-send-email-ordex@autistici.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-09 at 01:24 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> Userspace applications may be listening for events (e.g.
> matching mgmt frame) on a given interface. If such interface
> is deleted they would keep hanging because no event will be
> delivered anymore.
> 
> Send a CMD_INTERFACE event on NETDEV_UNREGISTER to notify
> userspace that the interface does not exist anymore.

This is too slippery a slope for me, I'm not going to apply this. You
can listen to normal interface events in rtnetlink.

johannes

