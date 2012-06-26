Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13684 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753634Ab2FZVVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 17:21:36 -0400
From: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "Ortiz, Samuel" <samuel.ortiz@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [RFC] iwmc3200top: remove driver for unavailable hardware
Date: Tue, 26 Jun 2012 21:21:34 +0000
Message-ID: <3A78FAA0EC814D4B8ECC99B3AB32B3320812EBC9@fmsmsx110.amr.corp.intel.com> (sfid-20120626_232146_360171_47FD9C50)
References: <1340740397-18119-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1340740397-18119-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi  John

> From: John W. Linville [mailto:linville@tuxdriver.com]
> Subject: [RFC] iwmc3200top: remove driver for unavailable hardware
> 
> From: "John W. Linville" <linville@tuxdriver.com>
> 
> This hardware never became available to normal humans.  Leaving this
> driver imposes unwelcome maintenance costs for no clear benefit.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> Can't remove this just yet, as it is selected by the i2400m wimax
> driver.  The 3200 bits of that driver seem a bit intertwined with the
> rest of the driver.
> 
> Are there any other SDIO parts for i2400m?  Does anyone have any other
> guidance on how I can safely make i2400m be independent of iwmc3200
> support?

It should be pretty straight forward: remove the dependency. In fact, you
are very right--all the sdio code should be removed, as there are no SDIO
parts in the market, to the best of my knowledge.

Yank anything hitting a grep on sdio in i2400m/ (*sdio*) and the Makefile
entries, as well as the Kconfig. That should take care of it.

