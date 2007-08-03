Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:64236 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXHCF3h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 01:29:37 -0400
Date: Fri, 3 Aug 2007 07:29:36 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Daniel Drake <dsd@gentoo.org>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: mac80211 driver interface semantics
Message-ID: <20070803052935.GA12683@deine-taler.de>
References: <46B27729.5030406@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46B27729.5030406@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:

> There has been some recent confusion as to how monitor interfaces should 
> operate, how multiple interfaces should be handled by drivers, and how 
> MAC addresses should be handled.
> 
> Based on some recent discussions, and what bcm43xx does, I started 
> writing some documentation:
> 
> http://www.linuxwireless.org/en/developers/mac80211/semantics

This is a certainly a very good idea. If the description is
accepted by the wireless developers, I would also suggest to
update the documentation comments in the kernel accordingly.

As far as I know the phy0/add_iface entry can be used to add a new
interface. Notify though the "file" has write access for other,
you will need network admin capabilities, which is satisfied by
being root. For example:

# cat mon0 >/sys/class/net/wmaster0/phy80211/add_iface
# iwconfig mon0 mode monitor
# iwcondig mon0 up

Notify that /sys/class/net/wmaster0/phy80211 is a symbolic link.

> Discuss :)
> I probably made some mistakes. Corrections are very welcome.

I think you should mention IEEE80211_HW_MONITOR_DURING_OPER in the
description of the monitor modes. There are some comments to be
found in the mac80211.h header in the kernel.

-- 
Uli Kunitz
