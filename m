Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404Ab2HFSjX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 14:39:23 -0400
Message-ID: <1344270901.11053.12.camel@dcbw.foobar.com> (sfid-20120806_203928_297212_DC5594A6)
Subject: Re: DHCP request timed out, iwlwifi
From: Dan Williams <dcbw@redhat.com>
To: Marco <netuse@lavabit.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Aug 2012 11:35:01 -0500
In-Reply-To: <20120806161443.35c71558@homerow>
References: <20120806161443.35c71558@homerow>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-06 at 16:14 +0200, Marco wrote:
> Hi,
> 
> I use a HP EliteBook equipped with an Intel Centrino Advanced-N 6205
> network adapter, it uses the iwlwifi module, on Ubuntu 12.04.
> 
> I often cannot connect to my wireless network. Other computers
> connect without problems. It is not reproducible, but it occurs, say
> once per week. If it doesn't connect, nothing helps, not even a
> reboot. I find the following messages in my syslog:
> 
> Aug  6 15:34:49 dejon NetworkManager[1042]: <warn> (wlan0): DHCPv4 request
> timed out.
> 
> The more detailed syslog is attached. DHCP works for all other
> computers. If I connect this computer via cable it also works
> without problems. So it seems to be related to this particular
> computer and its wireless configuration. But I have no clue how to
> investigate further.
> 
> Any ideas what might be the cause?

What kernel version?  Is the network an 802.11n-enabled network?  If you
have kernel version 3.2, try to disable 802.11n and see if that makes
things happier.  I've had a number of iwlwifi bug reports with the 3.2
kernel from 12.04 that seem to be 802.11n related.  Association happens
correctly, but data frames do not work.

Do something like the following:

rmmod iwlwifi
modprobe iwlwifi 11n_disable=1
(let it reconnect)

If that works, it can be made more permanent by using modprobe config
files to set the module options whenever it's loaded.  Or, better yet,
upgrade your kernel version to 3.4 or later, but that's probably not
something that Canonical will do in the near future with 12.04.

Dan

