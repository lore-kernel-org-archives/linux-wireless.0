Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50886 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2JUJVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2012 05:21:53 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so1434168wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2012 02:21:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349099476.4315.12.camel@dcbw.foobar.com>
References: <CAHbMyCb7S1faT_GH8KBag0SVX+7uhC-4qLJOR-DhStpzSMNDqQ@mail.gmail.com>
	<1349099476.4315.12.camel@dcbw.foobar.com>
Date: Sun, 21 Oct 2012 11:21:52 +0200
Message-ID: <CAHbMyCZQzj43W1zsFQ=P5PtVn9bAeVW=t7Srk5TuxHSqHua=jA@mail.gmail.com> (sfid-20121021_112202_582529_F2A5F494)
Subject: Re: [Kernel Bug] 3.6, wpasupplicant 1.0, broadcom-sta 6.20.55.19
From: Jasmine Hassan <jasmine.aura@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend@broadcom.com>,
	Dan Williams <dcbw@redhat.com>,
	Frank Vanderham <twelve.eighty@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(resent to list as plain text)

Hi,

@Dan, yes. Though it's mixed/propietary, it would be great if at least
Broadcom would publish specifications for the PHY (LCN40 rev 3) to
allow others who are interested (as Rafał Miłecki) to develop
open-source drivers.

Luckily this time, the issue was in the part of the driver where
source is available.

--

Frank Vanderham, maintainer of the same driver (wireless-bcm43142) in
the AUR, turned my attention to changes suggested by another user
(andreyv) on broadcom-wl, also in the AUR.
https://aur.archlinux.org/packages.php?ID=19514&comments=all

He noticed warnings while compiling the module against kernel 3.6.2:
aur-broadcom-wl/src/src/wl/
sys/wl_cfg80211.c:1647:2: warning: initialization from incompatible
pointer type [enabled by default]
aur-broadcom-wl/src/src/wl/sys/wl_cfg80211.c:1647:2: warning: (near
initialization for 'wl_cfg80211_ops.scan') [enabled by default]

And noted:
---
In Linux's <net/cfg80211.h> we see

int (*scan)(struct wiphy *wiphy,
struct cfg80211_scan_request *request);

but in the module we have

static s32 wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
struct cfg80211_scan_request *request);
---

Surely, doing a diff between 3.5.0 and 3.6.0
headers/include/net/cfg80211.h, one notices that net_device was moved
to wireless_dev, and subsequently the (second) parameter to
cfg80211_scan was dropped.

Looking at commits affecting drivers/net/wireless/brcm80211/brcmfmac/
from March onwards, one finds:
---
commit fd0142844efa85d89017c89227a0f03de1eee327
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Mon Jun 18 19:17:03 2012 +0200

    nl80211: move scan API to wdev

    The new P2P Device will have to be able to scan for
    P2P search, so move scanning to use struct wireless_dev
    instead of struct net_device.
---

Adapt a patch (attached) using LINUX_VERSION_CODE conditionals, as to
not break support for pre-3.6 kernels, and problem solved.

However, scan results seem quite limited. That is, discovered BSSID's
are noticeably fewer compared to results on 3.2.x-3.5.x, either via
`/sbin/iwlist wlan1 scanning`, or networkmanager. Only 3-5 are show by
iwlist, sometimes none, and network manager lists 6 at most.
Same driver on 3.5 (or prior) quickly picks up at least 15 BSSIDs.

Is there something obviously wrong with the patch?

Best,
Jasmine


On Mon, Oct 1, 2012 at 3:51 PM, Dan Williams <dcbw@redhat.com> wrote:
>
> On Mon, 2012-10-01 at 11:25 +0200, Jasmine Hassan wrote:
> > Hi,
> >
> > I posted this a few days ago against 3.6-rc7, but got no response.
> > http://marc.info/?l=linux-wireless&m=134875589522742&w=2
> >
> > Tested again today against 3.6 stable, and still triggering kernel bug.
> > Attached updated kernel trace from syslog.
>
> Since that's the closed proprietary driver, there's pretty much nothing
> anyone here can do about it, since we don't have the source code.  The
> ball is in Broadcom's court.
>
> Dan
>
