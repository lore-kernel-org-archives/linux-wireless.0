Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51332 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755937Ab2BXEo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 23:44:59 -0500
Received: by iacb35 with SMTP id b35so2520197iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 20:44:59 -0800 (PST)
Date: Thu, 23 Feb 2012 20:42:02 -0600
From: "Saul St. John" <saul.stjohn@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Rafal Milecki <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for SPROM
 storage
Message-ID: <20120224024202.GA30429@eris.garyseven.net> (sfid-20120224_054506_155763_FD29D1BD)
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330033977-5741-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2012 at 10:52:57PM +0100, Arend van Spriel wrote:
> Wireless Broadcom chips can have either their SPROM data stored
> on either external SPROM or on-chip OTP memory. Both are accessed
> through the same register space. This patch adds support for the
> on-chip OTP memory.
> 
> Tested with:
> BCM43224 OTP and SPROM
> BCM4331 SPROM
> BCM4313 OTP
> 
> This patch is in response so gmane article [1].
> 
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426
> 
Tested-by: Saul St. John <saul.stjohn@gmail.com>
> Cc: Rafal Milecki <zajec5@gmail.com>
> Cc: Hauke Mehrtens <hauke@hauke-m.de>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Determining the offset for OTP sprom data turned out to be
> easier as it boils down to reading a register. This change
> collides with patch posted by Hauke:
> 
> bcma: add support for sprom not found on the device.
> 
> Now working on changes in brcmsmac to start using the sprom
> data stored in struct bcma_bus. Feel free to comment this patch.
> 
> Gr. AvS

This works for me. Do you still need to define BCMA_CC_SPROM_PCIE6?
