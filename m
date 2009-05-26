Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52036
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736AbZEZGED (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 02:04:03 -0400
Date: Mon, 25 May 2009 23:04:02 -0700 (PDT)
Message-Id: <20090525.230402.250194609.davem@davemloft.net>
To: holtmann@linux.intel.com
Cc: yi.zhu@intel.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, samuel.ortiz@intel.com,
	kay.sievers@vrfy.org
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243312991.21383.3.camel@localhost.localdomain>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com>
	<1243307448-17441-2-git-send-email-yi.zhu@intel.com>
	<1243312991.21383.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Marcel Holtmann <holtmann@linux.intel.com>
Date: Tue, 26 May 2009 06:43:11 +0200

> Hi guys,
> 
>> Firmware names can not be longer than 30 characters, and
>> iwmc3200wifi-lmac-calib-sdio.bin is too long.
>> Renaming it to iwmc3200wifi-calib-sdio.bin.
> 
> hold on with this one. This limit should _NOT_ exist. Is this an issue
> in the driver model?

linux/firmware.h:FIRMWARE_NAME_MAX == 30
drivers/base/firmware_class.c:struct firmware_priv{ char fw_id[FIRMWARE_NAME_MAX]; ... };
