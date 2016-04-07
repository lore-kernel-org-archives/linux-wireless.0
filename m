Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43118 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755219AbcDGHgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 03:36:37 -0400
Message-ID: <1460014595.27154.2.camel@sipsolutions.net> (sfid-20160407_093640_720939_2A25B0BE)
Subject: Re: [PATCH 2/2] Check protocol number in nl80211 netlink socket
 release notification handler.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Apr 2016 09:36:35 +0200
In-Reply-To: <20160406172318.f6fec91145578157c500737c@ubnt.com> (sfid-20160406_162324_890477_45237117)
References: <20160406172318.f6fec91145578157c500737c@ubnt.com>
	 (sfid-20160406_162324_890477_45237117)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-06 at 17:23 +0300, Dmitry Ivanov wrote:
> This patch corrects the problem where non-privileged user can create
> netlink socket with the same port_id as used by hostapd but different
> protocol number. Upon close() or process termination, a notification
> is
> sent  to nl80211 subsystem which will destroy virtual wireless
> network
> interfaces created by hostapd like it just died but in fact hostapd
> is
> still running. This is possible because port_id is unique within
> particular
> protocol number only.
> 
Applied.

johannes
