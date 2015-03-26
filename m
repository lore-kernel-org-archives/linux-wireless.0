Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49434 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752266AbbCZA3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 20:29:52 -0400
Date: Thu, 26 Mar 2015 01:29:46 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4/8] NFC: NCI: Add a special nci_request for driver
Message-ID: <20150326002946.GC10954@ribalta.home> (sfid-20150326_012958_758904_E32ECEE0)
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
 <1424772112-27399-5-git-send-email-robert.dolca@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424772112-27399-5-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

On Tue, Feb 24, 2015 at 12:01:48PM +0200, Robert Dolca wrote:
> This patch adds nci_request_driver and nci_req_complete_driver
> as a wrapper for __nci_request. When nci_req_complete_driver is
> called it also sets cmd_cnt to 1. This is done because the response is not
> sent to the NFC subsystem so cmd_cnt is not decremented there.
> 
> nci_send_cmd was previously exported in order to send commands to
> the device from the driver. It shouldn't be used without
> nci_req_complete_driver because cmd_cnt will have the wrong value.
Any NCI packet should make it to the NCI core first, because the logic
and synchornization between Tx and Rx, commands and response is implemented
there. When exporting this kind of symbols, you're opening a can of worms by
potentially allowing each driver to implement the same kind of logic
that's already implemented in the NCI core.

The solution I'd like to see implemented is the following one: Add 1
additional nci_ops entry for handling proprietary packets on the Rx
path. From your driver perspective, you call nci_recv_frame for each and
every packet that you receive: No intercept, no trap. The core will call
your proprietary packets handler for each packet (NTF or RSP) with a
proprietary GID.
You should then be able to remove all the rx work, rx queue and
intercept logic from your driver.

Cheers,
Samuel.
