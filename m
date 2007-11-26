Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:10462 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757298AbXKZBff (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 20:35:35 -0500
Subject: Re: Error compiling intel mac80211-10.0.2
From: Zhu Yi <yi.zhu@intel.com>
To: Max <maxw_gcc@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <797498.12305.qm@web33009.mail.mud.yahoo.com>
References: <797498.12305.qm@web33009.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Mon, 26 Nov 2007 09:35:07 +0800
Message-Id: <1196040907.3250.575.camel@debian.sh.intel.com> (sfid-20071126_013539_036842_39A7DEE5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-11-24 at 22:34 -0800, Max wrote:
> Hi all,
> 
> I am trying to setup a Intel Corporation PRO/Wireless 3945ABG network adapter using the software provided in http://www.intellinuxwireless.org/. But I am getting the following error:

Since this question doesn't relate to upstream mac80211, I'd suggest you
only post it to ipw3945-devel@lists.sourceforge.net.

> ...
> Checking kernel compatibility in:
>         /lib/modules/2.6.18/source//
>   ! CONFIG_NET_WIRELESS_NETLINK can not be set in .config!
> ...
> 
> Which apparently gets triggered by the following lines in the "../mac80211-10.0.2/scripts/determine_compat" script
> .....
>         grep -q "nlmsg_trim" \
>                 ${KSRC}include/net/netlink.h && {
>                 export has_nlmsg_trim=1
>         } || {
>                 grep -q "^CONFIG_NET_WIRELESS_RTNETLINK=[ym]" \
>                         ${KSRC}.config && {
>                         echo "  ! CONFIG_NET_WIRELESS_NETLINK can not be set in .config!"
>                         exit 1
>                 }
>         }
> ......
> 
> As you can see I am running kernel version 2.6.18.

The code mac80211-10.0.2 integrated doesn't work with
CONFIG_NET_WIRELESS_RTNETLINK enabled. You should deselect it from your
kernel config file.

Thanks,
-yi
