Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:38927 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbaLGKHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2014 05:07:01 -0500
Received: by mail-lb0-f171.google.com with SMTP id n15so2506969lbi.16
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2014 02:06:59 -0800 (PST)
Date: Sun, 7 Dec 2014 11:57:13 +0200
From: vadim4j@gmail.com
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Supporting of IFLA_INFO_KIND rtnl attribute
Message-ID: <20141207095713.GA24783@angus-think.lan> (sfid-20141207_110707_291452_7F3A8384)
References: <1417910690-2021-1-git-send-email-vadim4j@gmail.com>
 <88214C7B-ED89-4E9C-BB24-8F0187B88D5E@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <88214C7B-ED89-4E9C-BB24-8F0187B88D5E@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 07, 2014 at 10:06:52AM +0100, Marcel Holtmann wrote:
> Hi Vadim,
> 
> > It allows to identify the wireless kind of device for
> > the user application, e.g.:
> > 
> >    # ip -d link
> > 
> >    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default
> >        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00 promiscuity 0
> >    2: enp0s25: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT group default qlen 1000
> >        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
> >    3: wlp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
> >        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0
> >        wireless
> >    4: wlp0s26u1u2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
> >        link/ether XX:XX:XX:XX:XX:XX brd ff:ff:ff:ff:ff:ff promiscuity 0 
> >        wireless 
> > 
> > Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
> > ---
> > net/mac80211/iface.c | 7 +++++++
> > 1 file changed, 7 insertions(+)
> > 
> > diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> > index 653f5eb..b993c7d 100644
> > --- a/net/mac80211/iface.c
> > +++ b/net/mac80211/iface.c
> > @@ -18,6 +18,7 @@
> > #include <linux/rtnetlink.h>
> > #include <net/mac80211.h>
> > #include <net/ieee80211_radiotap.h>
> > +#include <net/rtnetlink.h>
> > #include "ieee80211_i.h"
> > #include "sta_info.h"
> > #include "debugfs_netdev.h"
> > @@ -1624,6 +1625,10 @@ static void ieee80211_assign_perm_addr(struct ieee80211_local *local,
> > 	mutex_unlock(&local->iflist_mtx);
> > }
> > 
> > +static struct rtnl_link_ops wireless_link_ops __read_mostly = {
> > +	.kind = "wireless",
> > +};
> > +
> 
> I would prefer if we use "wlan" here. Same as what we use for DEVTYPE and RFKILL switches. Being consistent across the kernel helps a lot. Since other subsystems including Bluetooth might want to identify their netdev as well and "wireless" would be just too generic.
> 
> Regards
> 
> Marcel
> 

Hi Marcel,

It make sense.

Thanks,
