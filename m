Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab3CDNtk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 08:49:40 -0500
Date: Mon, 4 Mar 2013 14:49:50 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-pci@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: is L1 really disabled in iwlwifi
Message-ID: <20130304134949.GB3021@redhat.com> (sfid-20130304_144945_004889_A41AFD8E)
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 10:41:14AM +0200, Emmanuel Grumbach wrote:
> In 1a7123cdd9f49cf1c908fb2c16d26f279c88d8c9, John Linville disabled
> ASPM for iwlwifi:
> 
> 	/* W/A - seems to solve weird behavior. We need to remove this if we
> 	 * don't want to stay in L1 all the time. This wastes a lot of power */
> 	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
> 			       PCIE_LINK_STATE_CLKPM);
> 
> Now, I took a laptop with 3.7.9 (that supports L1) and measured power.
> I would expect to see that as long as the driver isn't loaded, the
> power consumption is low (L1 enabled), and when I load the driver, the
> power consumption rises because L1 gets disabled.
> But this is not what I see. I see more the less the same numbers
> before and after driver load.
> I don't remember exactly the numbers, but I do remember they were low
> (around 1mA or so) - but I really need to check.
> I also removed the code above, and it didn't change anything.
> Can it be that this code doesn't have any effect?

Depend on BIOS settings ASPM can be enabled or disabled on the whole
system. I think kernel can change settings globally as well.
Reloading driver can not be enough to check that, try to reboot the
system with iwlwifi module blacklisted and check lspci -vvv to see
LnkCtl ASPM settings.

Additionally despite above code, iwlwifi try to enable L0S in
iwl_pcie_apm_config(), what is basically wrong. 

Stanislaw
