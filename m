Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57088 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab3CDNpZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 08:45:25 -0500
Date: Mon, 4 Mar 2013 08:44:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-pci@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: is L1 really disabled in iwlwifi
Message-ID: <20130304134406.GA23686@tuxdriver.com> (sfid-20130304_144529_396553_92582E75)
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 04, 2013 at 10:41:14AM +0200, Emmanuel Grumbach wrote:
> Hi,
> 
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
> 
> And as you can see, I am not an expert at this...

Neither am I...that commit was a couple of years ago, and the code
seems to have moved around a bit since then.  FWIW, the "W/A -
seems to solve..." comment isn't even mine.  I don't even know what
"W/A" means...?

Anyway, ISTRC that change being suggested by Wey-Yi in response to
some device disconnects (i.e. from the PCI-E bus).  I have no idea
how much power it should cost or if it is really even necessary.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
