Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipv4.connman.net ([82.165.8.211]:32966 "EHLO mail.holtmann.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751739AbcGOTjh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 15:39:37 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [RFC] rfkill: Add new ACPI device for Realtek serial BT
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1468609696-8828-1-git-send-email-Larry.Finger@lwfinger.net>
Date: Fri, 15 Jul 2016 21:39:34 +0200
Cc: Kalle Valo <kvalo@codeaurora.org>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org
Message-Id: <7844586C-A1E2-4708-BFB3-CF740BAF0615@holtmann.org> (sfid-20160715_213940_360451_0F27213C)
References: <1468609696-8828-1-git-send-email-Larry.Finger@lwfinger.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> The Realtek RTL8723BS chips, which are connected via SDIO, also contain
> a serial Bluetooth device. In order for BT to work, the device must be
> added to the acpi_device_id table.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> I have no idea if this device should be added here, or if the device could
> be added to some structure supplied at device startup. If anyone has any
> suggestions, please let me know.

it should not be added here. Since most likely more is needed. For example within the hci_bcm.c and hci_intel.c drivers we handle the GPIO when attaching the UART to the Bluetooth subsystem. This means at minimum some sort of hci_rtl.c is needed. Can be for the beginning just an enhanced hci_h4.c.

Regards

Marcel

