Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37122 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYKFObI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 09:31:08 -0500
Date: Thu, 6 Nov 2008 08:49:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association
	in 5Ghz band
Message-ID: <20081106134950.GB14184@tuxdriver.com> (sfid-20081106_153132_117397_0A76B85E)
References: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com> <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 05, 2008 at 11:17:22PM +0100, Marcel Holtmann wrote:

>> This patch is related to bug 11870 at bugzilla.kernel.org. With
>> correct regulatory information the number of channels to scan
>> will be correct and not zero as seen in that bug.
>>
>> This patch eliminates the need for wireless to be compiled with
>> CONFIG_WIRELESS_OLD_REGULATORY to get correct regulatory behavior with
>> iwlwifi.
>
> so this is still for 2.6.28, but for 2.6.29 and wireless-testing the API 
> changed and we need a separate or different patch.
>
> John, Dave what is your take on pushing this to Linus this late in the  
> merge window? I personally think we should do that. And if not, then  
> change the Intel wireless Kconfig to select  
> CONFIG_WIRELESS_OLD_REGULATORY by default at least.

CONFIG_WIRELESS_OLD_REGULATORY is already 'default y' now.  I don't
really see why iwlwifi should _require_ that if someone decides to
choose a non-default configuration.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
