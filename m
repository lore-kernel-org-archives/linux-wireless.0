Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50534 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbbIVIom (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 04:44:42 -0400
Message-ID: <1442911476.2018.2.camel@sipsolutions.net> (sfid-20150922_104447_027012_36D311B0)
Subject: Re: [PATCH] iwlwifi: fix requested firmware name for iwlwifi-3160
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>, emmanuel.grumbach@intel.com
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Date: Tue, 22 Sep 2015 10:44:36 +0200
In-Reply-To: <1442659190-6060-1-git-send-email-hauke@hauke-m.de> (sfid-20150919_124007_995516_62A820AE)
References: <1442659190-6060-1-git-send-email-hauke@hauke-m.de>
	 (sfid-20150919_124007_995516_62A820AE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-09-19 at 12:39 +0200, Hauke Mehrtens wrote:
> modinfo iwlwifi showed the following required firmware:
> firmware: iwlwifi-3160-IWL3160_UCODE_API_OK.ucode

This is obviously wrong.

> 
>  MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
> -MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
> +MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3165_UCODE_API_OK));
> 
But this is also wrong, it should be 7260, and there should be a
separate entry for 3165. I'll get a patch on the way to fix it.

johannes
