Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12380 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbaBUOYP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 09:24:15 -0500
Date: Fri, 21 Feb 2014 16:23:49 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Marc Dietrich <marvin24@gmx.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Rhyland Klein <rklein@nvidia.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: rfkill: gpio: remove unused and obsolete
 platform parameters
Message-ID: <20140221142349.GB10489@xps8300> (sfid-20140221_152436_733519_61A4AFD9)
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
 <1392900697-27577-2-git-send-email-heikki.krogerus@linux.intel.com>
 <1723302.jKkc8NDNRI@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1723302.jKkc8NDNRI@fb07-iapwap2>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, Feb 21, 2014 at 02:55:14PM +0100, Marc Dietrich wrote:
> Am Donnerstag, 20. Februar 2014, 14:51:34 schrieb Heikki Krogerus:
> > After upgrading to descriptor based gpios, the gpio numbers
> > are not used anymore. The power_clk_name and the platform
> > specific setup and close hooks are not used by anybody, and
> > we should not encourage use of such things, so removing them.
> 
> arch/arm/mach-tegra/board-paz00.c is still using platform data. Is there some 
> prerequisite patch I'm missing (3.14-rc3) or how can this file be converted? 
> We are waiting for DT support to arrive so we can finally remove this file.

True! It still set's the shutdown_gpio and reset_gpio members. I think
I'll leave the header untouched and just clean net/rfkill/rfkill-gpio.c
in this patch. We can remove the whole header after you guys have moved
to DT.

I'll prepare v2 next week.

Thanks!

-- 
heikki
