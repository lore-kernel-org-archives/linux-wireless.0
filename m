Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:40480 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab1BNPfl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 10:35:41 -0500
Subject: Re: [PATCH 1/5] iwlwifi: Simplify tx queue management
From: wwguy <wey-yi.w.guy@intel.com>
To: "Nathaniel J. Smith" <njs@pobox.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <1297619803-2832-2-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <1297619803-2832-2-git-send-email-njs@pobox.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Feb 2011 07:33:50 -0800
Message-ID: <1297697630.4723.8.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nathaniel,

On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
> Previously, the iwlwifi driver filled its transmit queue until it
> reached a high-water mark, and then stopped until it had fallen to a
> low-water mark. This basic logic makes sense for interrupt mitigation
> -- you might not want to wake up the CPU after every packet, but
> instead wait until a batch of packets has been sent -- except the
> iwlwifi driver doesn't actually do any interrupt mitigation; the CPU
> wakes up after every packet transmitted anyway. So we simplify the
> code to maintain only a single limit on total queue length, and
> whenever we drop below that limit we allow more packets in.
> 
> This patch should have no user-visible effect.
> 
> Signed-off-by: Nathaniel J. Smith <njs@pobox.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    4 ++--
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c   |    6 +++---
>  drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 --
>  drivers/net/wireless/iwlwifi/iwl-tx.c       |   18 +++++++-----------
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 ++--
>  7 files changed, 18 insertions(+), 24 deletions(-)
> 
what device you test this with? I will like to see this changes with
newer device, especially with aggregation.

Thanks
Wey

