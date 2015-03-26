Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:16021 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbbCZA3l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2015 20:29:41 -0400
Date: Thu, 26 Mar 2015 01:29:37 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Robert Dolca <robert.dolca@intel.com>
Cc: linux-nfc@lists.01.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/8] NFC: NCI: Adds NCI init and reset API for drivers
Message-ID: <20150326002937.GB10954@ribalta.home> (sfid-20150326_012956_943477_F48A5D8E)
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
 <1424772112-27399-4-git-send-email-robert.dolca@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424772112-27399-4-git-send-email-robert.dolca@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robert,

On Tue, Feb 24, 2015 at 12:01:47PM +0200, Robert Dolca wrote:
> In order to communicate with the device during the setup
> phase, the driver may need to initialize the device. After
> the setup is done the driver should reset the device to leave
> it in the same state that it was before the setup function
> call.
I would prefer not to export those symbols, but instead introduce a
quirk bitmap to let the NCI core know that your device expects the core
to be initialized before calling the setup ops.
That would be done from nci_open_device().

Cheers,
Samuel.
