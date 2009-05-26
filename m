Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44254 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbZEZGKq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 02:10:46 -0400
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: Zhu Yi <yi.zhu@intel.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>,
	Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <1243312991.21383.3.camel@localhost.localdomain>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	 <1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	 <1243312991.21383.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 26 May 2009 14:02:57 +0800
Message-Id: <1243317777.3623.19.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 12:43 +0800, Marcel Holtmann wrote:
> Hi guys,
> 
> > Firmware names can not be longer than 30 characters, and
> > iwmc3200wifi-lmac-calib-sdio.bin is too long.
> > Renaming it to iwmc3200wifi-calib-sdio.bin.
> 
> hold on with this one. This limit should _NOT_ exist. Is this an issue
> in the driver model?

It should be FW_LOADER framework implementation limitation.

request_firmware()
  -> fw_setup_device()
       -> fw_register_device()

fw_register_device()
{
	...
	strlcpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
	...
}

FIRMWARE_NAME_MAX is defined 30 at this time.

Thanks,
-yi

