Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42961 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbcDGHNJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 03:13:09 -0400
Message-ID: <1460013184.27154.1.camel@sipsolutions.net> (sfid-20160407_091313_369753_12834F88)
Subject: Re: [PATCH 1/2] Do not send netlink socket release notification
 when socket is not bound
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Ivanov <dmitrijs.ivanovs@ubnt.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Apr 2016 09:13:04 +0200
In-Reply-To: <20160406172248.b032ff227e4843a836e00802@ubnt.com> (sfid-20160406_162255_804347_6B014CD5)
References: <20160406172248.b032ff227e4843a836e00802@ubnt.com>
	 (sfid-20160406_162255_804347_6B014CD5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-04-06 at 17:22 +0300, Dmitry Ivanov wrote:
> This patch corrects the problem where non-privileged user may create
> netlink socket with port_id equal to port_id used by hostapd to
> create
> virtual wireless network interfaces. Call to bind() will fail for
> such
> socket, but release notification sent on close() or process
> termination
> to nl80211 subsystem will destroy virtual network interfaces while
> hostapd is still running.
> 
Thanks Dmitry.

There are a number of issues with your patch still, such as describing
the problem in too restricted ways (this problem is not specific to
nl80211 nor fixed there). The subject should also have a proper prefix
and you're not sending this patch to the right people.

If you prefer, I can take ownership of these patches.

johannes
