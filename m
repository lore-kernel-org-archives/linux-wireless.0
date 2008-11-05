Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36764 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbYKEWRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 17:17:25 -0500
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Message-Id: <B887D922-0154-4365-A44D-F284A5DF9386@linux.intel.com> (sfid-20081105_231729_760712_964E8F9A)
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 1/2 2.6.28] iwlwifi : Fix channel scanning/association in 5Ghz band
Date: Wed, 5 Nov 2008 23:17:22 +0100
References: <> <1225912449-26625-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Reinette,

> A new wireless regulatory API has been added and
> static definitions of regulatory alpha2 have been removed.
> As a result of this 5Ghz channels have been disabled by default.
> Patch takes care of this by setting the regulatory domain
> by reading the EEPROM contents.
> It uses regulatory_hint function to dynamically set the regulatory
> channels.
>
> This patch is related to bug 11870 at bugzilla.kernel.org. With
> correct regulatory information the number of channels to scan
> will be correct and not zero as seen in that bug.
>
> This patch eliminates the need for wireless to be compiled with
> CONFIG_WIRELESS_OLD_REGULATORY to get correct regulatory behavior with
> iwlwifi.

so this is still for 2.6.28, but for 2.6.29 and wireless-testing the  
API changed and we need a separate or different patch.

John, Dave what is your take on pushing this to Linus this late in the  
merge window? I personally think we should do that. And if not, then  
change the Intel wireless Kconfig to select  
CONFIG_WIRELESS_OLD_REGULATORY by default at least.

Regards

Marcel

