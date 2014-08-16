Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hygieia.santi-shop.eu ([78.46.175.2]:60279 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHPUYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2014 16:24:45 -0400
Date: Sat, 16 Aug 2014 22:15:05 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Subject: iwlwifi: fix Kconfig issues breaks CONFIG_MODULES=n
Message-ID: <20140816221505.5420b21e@neptune.home> (sfid-20140816_222511_461957_24A56988)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The commit ae7486a2b734ee03 (iwlwifi: fix Kconfig issues) in 3.17-rc1
breaks iwlwifi for kernels built without support for modules
(CONFIG_MODULES=n).

It changes the dependencies of IWLDVM and IWLMVM from
  depends on IWLWIFI
to
  depends on m
(while enclosing the whole set of options in 'if IWLWIFI').


Why that dependency on 'm' for apparently mandatory feature of the driver
(without DVM and MVM, Kconfig comment says
  "WARNING: iwlwifi is useless without IWLDVM or IWLMVM"


Up until 3.16 it was very well possible to operate iwlwifi built-in
in a kernel without support for modules, either by building firmware
into the kernel, or as needed re-binding the driver to the PCI device
once filesystems were mounted.

Removing those two 'depend on m' iwlwifi works fine for a 7260
wireless card.

Bruno
