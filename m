Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15563 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2JVOaL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 10:30:11 -0400
Date: Mon, 22 Oct 2012 16:30:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] NFC: Move pn544.h header file close to the driver
Message-ID: <20121022143009.GB5800@sortiz-mobl> (sfid-20121022_163015_943531_0A24277A)
References: <1350672971-29716-1-git-send-email-marcel@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1350672971-29716-1-git-send-email-marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Fri, Oct 19, 2012 at 11:56:11AM -0700, Marcel Holtmann wrote:
> With the removal of the deprecated pn544.c driver, the header
> file pn544.h is now used only by the new pn544_hci.c driver. So
> move the header file close to the driver.

There are quite a bit of junk in this header file, as outlined from your
second patch. But there is a platform data structure definition (struct
pn544_nfc_platform_data) that should be available from the arch code.

By passing function pointers (That don't do anything else than toggling
GPIOs) from arch code to the driver, this function is not very nice. Nor
flexible as it won't work with e.g. DT platforms. The driver should just get
the IRQ and the 3 potentially needed GPIOs and implement the functions itself.
Even when that happens, we'll still need a header file that !DT platform could
use to pass the GPIO numbers around. So the bottom line is: We need to keep
this one under include/linux/nfc/.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
