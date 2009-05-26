Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51193 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbZEZGdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 02:33:23 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <1243317777.3623.19.camel@debian>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	 <1243312991.21383.3.camel@localhost.localdomain>
	 <1243317777.3623.19.camel@debian>
Content-Type: text/plain
Date: Tue, 26 May 2009 08:33:03 +0200
Message-Id: <1243319583.30938.2.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Yi,

> > > Firmware names can not be longer than 30 characters, and
> > > iwmc3200wifi-lmac-calib-sdio.bin is too long.
> > > Renaming it to iwmc3200wifi-calib-sdio.bin.
> > 
> > hold on with this one. This limit should _NOT_ exist. Is this an issue
> > in the driver model?
> 
> It should be FW_LOADER framework implementation limitation.
> 
> request_firmware()
>   -> fw_setup_device()
>        -> fw_register_device()
> 
> fw_register_device()
> {
> 	...
> 	strlcpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
> 	...
> }
> 
> FIRMWARE_NAME_MAX is defined 30 at this time.

I think we need to fix this. Especially since all the other name length
limits in the driver model are gone.

Regards

Marcel


