Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:45504 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbXK1Tpz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 14:45:55 -0500
Received: by py-out-1112.google.com with SMTP id u77so3167452pyb
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 11:45:53 -0800 (PST)
Message-ID: <f6ca9fed0711281145y26fa2dc1w5d57e9dc0e45c16b@mail.gmail.com> (sfid-20071128_194607_182437_3A0D0B40)
Date: Wed, 28 Nov 2007 20:45:41 +0100
From: dragoran <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
Cc: "Jouni Malinen" <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1196268612.6058.157.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu> <474D75D9.7070908@gmail.com>
	 <1196268612.6058.157.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 28, 2007 5:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > this does not happen with the ipw3945 driver but with the iwl3945 so its
> > either something with this driver or mac80211.
>
> I just posted a patch for iwl4965 to make monitoring possible. Maybe you
> can port that to iwl3945 and send me a packet dump with that patch
> applied where the problem occurs. Or just do it without the patch,
> should be good enough too.
>
> Just grap iw (from git.sipsolutions.net) and create a new monitor
> interface: ./iw dev wmaster0 interface add moni0 type monitor
> and then run tcpdump/wireshark on that.

iw does not build here :
cc -I/lib/modules/`uname -r`/build//include -Wall
-I/lib/modules/`uname -r`/build/include -g   -c -o iw.o iw.c
iw.c:11:31: error: netlink/genl/genl.h: No such file or directory
iw.c:12:33: error: netlink/genl/family.h: No such file or directory
iw.c:13:33: error: netlink/genl/ctrl.h: No such file or directory
iw.c: In function 'nl80211_init':
iw.c:31: warning: implicit declaration of function 'genl_connect'
iw.c:37: warning: implicit declaration of function 'genl_ctrl_alloc_cache'
iw.c:37: warning: assignment makes pointer from integer without a cast
iw.c:44: warning: implicit declaration of function 'genl_ctrl_search_by_name'
iw.c:44: warning: assignment makes pointer from integer without a cast
iw.c:54: warning: implicit declaration of function 'nl_cache_free'
iw.c: In function 'nl80211_cleanup':
iw.c:62: warning: implicit declaration of function 'genl_family_put'
---
this headers do indeed not exist in /usr/include/netlink
commenting them out results into:
interface.c: In function 'handle_interface_add':
interface.c:82: warning: implicit declaration of function 'nlmsg_alloc'
interface.c:82: warning: assignment makes pointer from integer without a cast
interface.c:88: warning: implicit declaration of function 'genlmsg_put'
interface.c:88: warning: implicit declaration of function 'genl_family_get_id'
interface.c:91: error: invalid lvalue in unary '&'
interface.c:98: warning: passing argument 2 of 'nl_send_auto_complete'
from incompatible pointer type
interface.c: In function 'handle_interface_del':
interface.c:122: warning: assignment makes pointer from integer without a cast
interface.c:133: error: invalid lvalue in unary '&'
interface.c:135: warning: passing argument 2 of
'nl_send_auto_complete' from incompatible pointer type
make: *** [interface.o] Error 1

build tested on fedora 8
with libnl-devel-1.0-0.10.pre5.4
