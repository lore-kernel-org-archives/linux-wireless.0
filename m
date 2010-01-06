Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44416 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab0AFAIQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 19:08:16 -0500
Subject: Re: [PATCH] iwlwifi: remove IWLWIFI_VERSION
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1262728499-31006-1-git-send-email-linville@tuxdriver.com>
References: <DA586906BA1FFC4384FCFD6429ECE860302D216F@shzsmsx502.ccr.corp.intel.com>
	 <1262728499-31006-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 05 Jan 2010 16:08:15 -0800
Message-Id: <1262736495.11849.305.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Tue, 2010-01-05 at 13:54 -0800, John W. Linville wrote:
> Also remove the MODULE_VERSION macros using IWLWIFI_VERSION.  Those
> places using IWLWIFI_VERSION at runtime are modified to use
> init_utsname()->release instead.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> How about this as a compromise?

Thank you for looking at this.

I do think it is valuable for a user to see the parameters the module
was compiled with when running "modinfo". I thus would like the
MODULE_VERSION to stay. Including the kernel version number at runtime
seems fine. The version number display may be a bit strange when a user
did not compile with any of the options since the version number will
then end with "-".

Reinette


