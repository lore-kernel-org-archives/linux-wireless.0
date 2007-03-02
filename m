Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3189 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992454AbXCBOFe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 09:05:34 -0500
Date: Fri, 2 Mar 2007 08:57:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: Assertion failed in ieee80211softmac_wx_get_rate
Message-ID: <20070302135734.GB6676@tuxdriver.com>
References: <1172816819.26330.12.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1172816819.26330.12.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 02, 2007 at 01:26:59AM -0500, Pavel Roskin wrote:
> Hello!
> 
> If I load bcm43xx and run iwconfig without bringing the interface up,
> I'm getting this in the kernel log:
> 
> SoftMAC: ASSERTION FAILED (0)
> at: /home/proski/src/linux-2.6/net/ieee80211/softmac/ieee80211softmac_wx.c:306:ieee80211softmac_wx_get_rate()
> 
> It's an x86 system with the 2.6.20 kernel (actually, it's the master
> branch from the mb repository, which is wireless-dev before the 2.6.21
> switchover plus broadcom fixes).
> 
> The assert assures that the interface has a valid tx rate.  But since
> the interface has never been up, the rate has not been assigned.
> 
> Either softmac should tolerate rate 0, at least when the interface is
> down, or it should initialize the rate much earlier, perhaps in
> alloc_ieee80211softmac().
> 
> I can test another tree, e.g. wireless-2.6, if there are chances that
> the problem has been fixed.

Does the tree you are using have this commit?

commit 6bbdce5ac755e3b3cdcf9bb9fdbcc2af78ad34d0
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue Jan 2 21:22:05 2007 -0500

    [PATCH] softmac: avoid assert in ieee80211softmac_wx_get_rate

    Unconfigured bcm43xx device can hit an assert() during wx_get_rate
    queries.  This is because bcm43xx calls ieee80211softmac_start late
    (i.e. during open instead of probe).

       bcm43xx_net_open ->
          bcm43xx_init_board ->
             bcm43xx_select_wireless_core ->
                ieee80211softmac_start

    Fix is to check that device is running before completing
    ieee80211softmac_wx_get_rate.

    Signed-off-by: John W. Linville <linville@tuxdriver.com>

It is in linux-2.6, wireless-2.6, and wireless-dev.  If you don't
want to use those trees, you should be able to apply the patch to
the tree you are using.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
