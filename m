Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:22074 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990Ab0IWVCP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 17:02:15 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 14:02:08 -0700
Date: Thu, 23 Sep 2010 14:02:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Yixiang Li <Yixiang.Li@Atheros.com>
CC: Calvin Fang <Calvin.Fang@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	<ath9k-devel@atheros.com>, <linux-wireless@vger.kernel.org>
Subject: Re: can pktlog be used with ath9k for AR9003
Message-ID: <20100923210212.GA2595@tux>
References: <CECE7CA09914574A8A7528D271EBC63524A9C52B85@SC1EXMB-MBCL.global.atheros.com>
 <BD672EAEE3AD2C47A7120B0973C3FB3A3BBFF2012A@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <BD672EAEE3AD2C47A7120B0973C3FB3A3BBFF2012A@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 10:59:07AM -0700, Yixiang Li wrote:
> Luis,
> 
> Can you please answer this question?
> 
> Thanks
> Yixiang
> 
> From: Calvin Fang
> Sent: Thursday, September 23, 2010 10:55 AM
> To: Yixiang Li
> Subject: can the pktlog be used withe the open source dirver for Osprey
> 
> Yixiang:
> 
> A quick question from the customer, can pktlog be used with
> the ath9k driver on a laptop?
> Thanks.
> 
> 
> Best Regards,
> 
> Calvin (Kewei) Fang
> Senior Field Application Engineer
> Atheros Communications
> Work:  408-830-5840
> Mobile: 408-250-9918
> Email: calvin.fang@atheros.com<mailto:calvin.fang@atheros.com>

Please note I am posting this reply publicly. So remove the public
lists if you want to reply and send a note to me privatey.

Absolutely. We have packet log supported on ath9k but it has not yet
been merged upstream. Packetlog code has been written but not
submitted upstream as there are some ideas going around of how
to do it better, but you can use it today and daily tarballs are
made which add that code.

In compat-wireless we support adding patches that are either:

  * posted publicly but not merged yet: linux-next-pending/
  * merged into linux-next but not on a stable kernel: linux-next-cherry-picks/
  * not even posted at all yet: crap/

The directories are in compat-wireless and I annotate whether or
not a tarball has any of these patches applied by postfixing the
tarball with

	"n" for linux-next-cherry-picks/ and
	"p" for linux-next-pending/
	"c" for crap/ patches having been applied

So:

	compat-wireless-2010-09-23.tar.bz2 is vanilla linux-next.git based
	compat-wireless-2010-09-23-n.tar.bz2 is vanilla + cherry picked patches
	compat-wireless-2010-09-23-p.tar.bz2 is vanilla + pending patches
	compat-wireless-2010-09-23-pc.tar.bz2 is vanilla + pending + crap patches

The "n" stuff only makes sense for stable releases, not linux-next.git
based compat-wireless releases. I call crap/ crap/ as we should avoid
it at all costs.

Packetlog for ath9k is in the "c" tarballs, for example this one would have it:

http://www.orbit-lab.org/kernel/compat-wireless-2.6/compat-wireless-2010-09-23-pc.tar.bz2

To use it:

cp defconfigs/atheros-debug.mk config.mk
./scripts/driver-select ath9k
make
sudo make install

We don't have stable release with "n" yet, or "p" or "c", but
we can make them ourselves for customers if we so wish.

  Luis


