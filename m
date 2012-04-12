Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48807 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2DLEYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 00:24:48 -0400
Message-ID: <1334204647.3788.19.camel@jlt3.sipsolutions.net> (sfid-20120412_062452_398362_0682CAAC)
Subject: backporting PCI PM calls
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Don Fry <donald.h.fry@intel.com>
Date: Thu, 12 Apr 2012 06:24:07 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We have a bug report against our driver in compat that will affect
everyone else too. In

commit f60dc0138aa19769bf8bab9f93b043235428b66f
Author: John W. Linville <linville@tuxdriver.com>
Date:   Mon Oct 25 16:12:37 2010 -0400

    iwlwifi: Convert to new PCI PM framework


and the similar patches to other drivers all drivers were converted to
use .driver.pm suspend/resume callbacks, and that removed

        pci_save_state(pdev);
        pci_disable_device(pdev);
        pci_set_power_state(pdev, PCI_D3hot);

on suspend and the corresponding calls on resume. The compat backport
never added them back but just re-wired the callbacks, so on older
kernels we don't call these functions at all any more, and that breaks
suspend/resume.

Anyone have ideas of how to handle it? Maybe with compat_pci_suspend(),
whatever that is? If it even needs to exist -- maybe we could redefine
SIMPLE_DEV_PM_OPS in compat instead or in addition?

johannes

