Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.osdl.org ([207.189.120.12]:58904 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757767AbXEQPTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2007 11:19:35 -0400
Date: Thu, 17 May 2007 08:03:15 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
Message-ID: <20070517080315.710d656e@freepuppy>
In-Reply-To: <20070516203505.556df4f9.randy.dunlap@oracle.com>
References: <464B7B7C.5080800@linux.intel.com>
	<20070516203505.556df4f9.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 16 May 2007 20:35:05 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 16 May 2007 14:45:32 -0700 James Ketrenos wrote:
> 
> > This patch adds the iwlwifi project directory and sources needed to 
> > build the mac80211 based wireless drivers for the Intel PRO/Wireless 
> > 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
> > 
> > Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
> > 
> > NOTE:  The patch is 597k and can be found at:
> > 
> > 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
> > 
> > Patch is against wireless-dev commit-id be8662897~
> 
> 
> 1.  Can't this:
> 
> +	if (sizeof(priv->eeprom) != 1024) {
> +		IWL_ERROR("EEPROM structure size incorrect!\n");
> +		return -EINVAL;
> +	}
> 
> use this instead of 1024 ?
> +#define IWL4965_EEPROM_IMAGE_SIZE  (0x200 * sizeof(u16))

Why not BUILD_BUG_ON()?


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
