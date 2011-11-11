Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46157 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1KKRpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 12:45:15 -0500
Date: Fri, 11 Nov 2011 12:35:49 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Franky Lin <frankyl@broadcom.com>
Subject: Re: [PATCH 17/19] brcm80211: fmac: stop using hard coded
 firmware/nvram name
Message-ID: <20111111173548.GC2485@tuxdriver.com> (sfid-20111111_184520_522336_91AE44A9)
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
 <1320953434-16859-19-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1320953434-16859-19-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 10, 2011 at 08:30:32PM +0100, Arend van Spriel wrote:
> From: Franky Lin <frankyl@broadcom.com>
> 
> The nvram file contains info for firmware which varies with different
> hardware designs. Current nvram file in Linux firmware repository is
> for a internal development board. It is not applicable for any exsisting
> end-user product. Every device with a fullmac support wifi dongle
> should have its own nvram file in the system. Similar rule can be applied
> to the dongle firmware. This patch remove the hard coded firmware/nvram
> name in the driver. The paths of firmware and nvram file must be
> passed to the driver through module parameter during or configured
> in kernel option.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Arend van Spriel <arend@broadcom.com
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

I can't say that I'm too fond of this one.  Why do you need to be
able to change the name of the file?  Other drivers seem to handle
this without having to set the filename at Kconfig time?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
