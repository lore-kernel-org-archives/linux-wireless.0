Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38575 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbYLBVT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 16:19:27 -0500
Subject: Re: [PATCH 10/11] iwlwifi: rely on API version read from firmware
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1228248847-10424-11-git-send-email-reinette.chatre@intel.com>
References: <> <1228248847-10424-1-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-2-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-3-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-4-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-5-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-6-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-7-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-8-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-9-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-10-git-send-email-reinette.chatre@intel.com>
	 <1228248847-10424-11-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 22:19:18 +0100
Message-Id: <1228252758.31158.252.camel@violet.holtmann.net> (sfid-20081202_221930_765339_A69AE8D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> This adds the infrastructure to support older firmware APIs.
> The API version number is stored as part of the filename, we first try to
> load the most recent firmware and progressively try lower versions.
> The API version is also read from the firmware self and stored as part
> of the iwl_priv structure. Only firmware that is supported by driver will
> be loaded. The version number read from firmware is compared
> to supported versions in the driver not the API version used as part of
> filename.

thanks for doing this. This can really help smooth upgrade path in case
the firmware API changes.
 
> -MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE);
> -MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE);
> +MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
> +MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));

So we don't have clear semantics on how MODULE_FIRMWARE should be used.
The current way is that it list all potential firmware versions. So in
cases it support API -1 and -2, then it has to list both. And not only
the latest.

Personally I think we should not create too many macros here and just
list all the firmware files manually.

Regards

Marcel


