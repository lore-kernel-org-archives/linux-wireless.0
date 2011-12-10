Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40132 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1LJR5w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 12:57:52 -0500
Subject: Re: [PATCH 07/15] iwlwifi: add device ID information support by
 testmode
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Hsu, Kenny" <kenny.hsu@intel.com>
In-Reply-To: <1323539479.3344.31.camel@jlt3.sipsolutions.net>
References: <1323390382-1678-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1323390382-1678-8-git-send-email-wey-yi.w.guy@intel.com>
	 (sfid-20111209_022535_454507_1587E816)  <1323539479.3344.31.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Dec 2011 09:51:09 -0800
Message-ID: <1323539469.1806.15.camel@wwguy-ubuntu> (sfid-20111210_185755_179010_99A1E1AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-10 at 09:51 -0800, Johannes Berg wrote:
> On Thu, 2011-12-08 at 16:26 -0800, Wey-Yi Guy wrote:
> 
> > +	case IWL_TM_CMD_APP2DEV_GET_DEVICE_ID:
> > +		bus_get_hw_id(bus(priv), buf, sizeof(buf));
> > +		ptr = buf;
> > +		strsep(&ptr, ":");
> > +		sscanf(strsep(&ptr, ":"), "%x", &num);
> > +		sscanf(strsep(&ptr, ":"), "%x", &devid);
> 
> This is kinda ugly too ... sorry, should've seen it earlier.

has to agree, will move to wiphy->hw_version 

Wey
> 


