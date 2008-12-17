Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38185 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbYLQUaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 15:30:13 -0500
Date: Wed, 17 Dec 2008 15:29:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: mohamed salim abbas <mabbaswireless@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com,
	yi.zhu@intel.com, reinette.chatre@intel.com
Subject: Re: [RFC][RFT] fix iwlagn hw-rfkill while the interface is down
Message-ID: <20081217202943.GB3516@tuxdriver.com> (sfid-20081217_213018_695197_838DD502)
References: <200812161307.07193.helmut.schaa@gmail.com> <b3153e950812171210n7247bevc9470fa47942ce92@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b3153e950812171210n7247bevc9470fa47942ce92@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 12:10:11PM -0800, mohamed salim abbas wrote:
> the interrupt moved from pci_probe to mac_start for power saving. once
> the interface is up the driver will read some register to know rfkill
> status, if the interface in down the driver don't care to keep track
> of rfkill switch. I wonder what the purpose of changing this behavior?

I think it still isn't settled in everyone's minds whether rfkill
only matters if the device is "up" or if it is something that
e.g. NetworkManager might want to monitor as a clue to bring the
device up or down in response to rfkill changes.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
