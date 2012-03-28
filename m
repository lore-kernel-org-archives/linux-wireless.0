Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab2C1Mit (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2012 08:38:49 -0400
Date: Wed, 28 Mar 2012 14:38:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 1/4] rt2x00: broaden PCIE L1-state wakeup
 configuration
Message-ID: <20120328123808.GB3333@redhat.com> (sfid-20120328_143854_054721_1E417FCA)
References: <1332859867-27921-1-git-send-email-kubakici@wp.pl>
 <1332859867-27921-2-git-send-email-kubakici@wp.pl>
 <4F720494.3030509@gmail.com>
 <20120328005244.727d9f05@north>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120328005244.727d9f05@north>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 28, 2012 at 12:52:44AM +0200, Jakub Kicinski wrote:
> > 
> > I don't like the comparison against 0x3000. Maybe you should invert the
> > conditions and test for the chipsets for which this does not have to be
> > applied (e.g. !rt2x00_rt(rt2x00dev, RT2860) && !rt2x00_rt(rt2x00dev,
> > RT2872).
> Not sure about that. Excluding old chips would be opposite to what
> legacy driver is doing.
> 
> Legacy driver uses a long list of almost all > 0x3000 devices here. It
> leaves out only RT3070, RT3352 and RT5350 but those chips are not used
> on PCIe. The same list is later used throughout PCIe power management
> code. I can only guess that from 0x3000 on PCIe devices gained some
> kind of new power management capabilities.
> 
> It might be worth adding a macro which will check for all those devices
> (rt2800pci_has_pcie_ps or sth) later on, when implementing support for
> that PCIe PS, but for now I thought check against 0x3000 will be
> equally good.

Leaving > 0x3000 check, but wrap it in a macro with a descriptive name,
which could tell what this check actually mean, would be most
appreciated change IMHO.

BTW: if you plan to add ASPM quirks from vendor driver to rt2x00, don't
do it. ASPM should be configured by pci core.

Stanislaw
