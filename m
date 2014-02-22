Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50519 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbaBVWci (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 17:32:38 -0500
Received: from ax5200p.localnet ([217.229.227.66]) by mail.gmx.com (mrgmx103)
 with ESMTPSA (Nemesis) id 0Ltqmn-1XHvXS2UpZ-011DgO for
 <linux-wireless@vger.kernel.org>; Sat, 22 Feb 2014 23:32:36 +0100
From: Marc Dietrich <marvin24@gmx.de>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Rhyland Klein <rklein@nvidia.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: rfkill: gpio: remove unused and obsoleteplatform parameters
Date: Sat, 22 Feb 2014 23:32:04 +0100
Message-ID: <2556368.zbgmUK7WzX@ax5200p> (sfid-20140222_233301_054754_60D444EB)
In-Reply-To: <20140221142349.GB10489@xps8300>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com> <1723302.jKkc8NDNRI@fb07-iapwap2> <20140221142349.GB10489@xps8300>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 February 2014 16:23:49 Heikki Krogerus wrote:
> Hi,
> 
> On Fri, Feb 21, 2014 at 02:55:14PM +0100, Marc Dietrich wrote:
> > Am Donnerstag, 20. Februar 2014, 14:51:34 schrieb Heikki Krogerus:
> > > After upgrading to descriptor based gpios, the gpio numbers
> > > are not used anymore. The power_clk_name and the platform
> > > specific setup and close hooks are not used by anybody, and
> > > we should not encourage use of such things, so removing them.
> > 
> > arch/arm/mach-tegra/board-paz00.c is still using platform data. Is there
> > some prerequisite patch I'm missing (3.14-rc3) or how can this file be
> > converted? We are waiting for DT support to arrive so we can finally
> > remove this file.
> True! It still set's the shutdown_gpio and reset_gpio members. I think
> I'll leave the header untouched and just clean net/rfkill/rfkill-gpio.c
> in this patch. We can remove the whole header after you guys have moved
> to DT.

Why? Just update the board file to remove those entries. I just checked that 
it's working fine without. So if you don't mind, add a patch to remove the 
entries as the first patch in your series.

Thanks

Marc
