Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63580 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab3FEMtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 08:49:46 -0400
Date: Wed, 5 Jun 2013 14:51:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 1/2] rt2x00: convert rt2x00_ops.extra_tx_headroom to be a
 fuction
Message-ID: <20130605125130.GA3367@redhat.com> (sfid-20130605_144949_122998_3312F54B)
References: <1370429640-31565-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370429640-31565-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 05, 2013 at 12:53:59PM +0200, Gabor Juhos wrote:
> The rt2x00_ops structure has a static field to indicate
> the extra TX headroom size required for a given device.
> The drawback of this is that we have to use a separate
> rt2x00_ops structure for each chipset which requires
> different size.
> 
> Convert the static field into a callback function.
> This allows the drivers to dynamically determine the
> extra TX headroom size based on the actual chipset.
> Also implement the the callback in the drivers which
> needs an extra TX headroom, and remove the field
> initialization from the others.
> 
> Additionally, introduce a new extra_tx_headroom field
> in struct rt2x00_dev, initialize its value in the probe
> routine and use the cached value in the rest of the code.

Could we rather get rid of that extra_tx_headroom variable and use queue
parameters: winfo_size and desc_size ?

Stanislaw

