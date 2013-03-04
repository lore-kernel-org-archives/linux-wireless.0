Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:60632 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab3CDIlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 03:41:16 -0500
MIME-Version: 1.0
Date: Mon, 4 Mar 2013 10:41:14 +0200
Message-ID: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com> (sfid-20130304_094126_049828_E8F6E738)
Subject: is L1 really disabled in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-pci@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In 1a7123cdd9f49cf1c908fb2c16d26f279c88d8c9, John Linville disabled
ASPM for iwlwifi:

	/* W/A - seems to solve weird behavior. We need to remove this if we
	 * don't want to stay in L1 all the time. This wastes a lot of power */
	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
			       PCIE_LINK_STATE_CLKPM);

Now, I took a laptop with 3.7.9 (that supports L1) and measured power.
I would expect to see that as long as the driver isn't loaded, the
power consumption is low (L1 enabled), and when I load the driver, the
power consumption rises because L1 gets disabled.
But this is not what I see. I see more the less the same numbers
before and after driver load.
I don't remember exactly the numbers, but I do remember they were low
(around 1mA or so) - but I really need to check.
I also removed the code above, and it didn't change anything.
Can it be that this code doesn't have any effect?

And as you can see, I am not an expert at this...


Emmanuel Grumbach
egrumbach@gmail.com
