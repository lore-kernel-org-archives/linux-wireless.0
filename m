Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:35420 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbbCaOGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 10:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <20150326002937.GB10954@ribalta.home>
References: <1424772112-27399-1-git-send-email-robert.dolca@intel.com>
 <1424772112-27399-4-git-send-email-robert.dolca@intel.com> <20150326002937.GB10954@ribalta.home>
From: Robert Dolca <robert.dolca@gmail.com>
Date: Tue, 31 Mar 2015 17:05:53 +0300
Message-ID: <CAFPB+YcvZReLRsv5dYh=jTwASa1vo-0pK5T1AS-eGmzO=arDLQ@mail.gmail.com> (sfid-20150331_160622_063112_85FED8FA)
Subject: Re: [linux-nfc] [PATCH 3/8] NFC: NCI: Adds NCI init and reset API for drivers
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Robert Dolca <robert.dolca@intel.com>, linux-nfc@lists.01.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2015 at 2:29 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> Hi Robert,
>
> On Tue, Feb 24, 2015 at 12:01:47PM +0200, Robert Dolca wrote:
>> In order to communicate with the device during the setup
>> phase, the driver may need to initialize the device. After
>> the setup is done the driver should reset the device to leave
>> it in the same state that it was before the setup function
>> call.
> I would prefer not to export those symbols, but instead introduce a
> quirk bitmap to let the NCI core know that your device expects the core
> to be initialized before calling the setup ops.
> That would be done from nci_open_device().

As part of the initialization / firmware upgrade procedure the driver
needs to reset and initialize the NCI connection multiple times.
Having the connection initialized before calling setup is not enough.

Regards,
Robert
