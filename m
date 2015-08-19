Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55228 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbbHSDBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 23:01:01 -0400
Date: Tue, 18 Aug 2015 20:01:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com
Subject: Re: [PATCH] staging: wilc1000: Set all options in region debugfs file
Message-ID: <20150819030100.GE4588@kroah.com> (sfid-20150819_050106_744539_1D1C5221)
References: <1439917337-18473-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439917337-18473-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 18, 2015 at 10:32:17PM +0530, Chandra S Gorentla wrote:
> This patch allows setting all options in the module's debug region
> options file 'wilc_debug_region'.  This functionality allows the user
> to enable logging from all regions (initialization, locks, firmware
> etc.) of the driver.  Logging from the following regions is enabled
> during the driver initialization:
> 
> INIT_DBG, GENERIC_DBG, CFG80211_DBG, FIRM_DBG and HOSTAPD_DBG
> 
> Before this change, the numerical value set is equal first byte of 
> input minus 0x30 (ASCII value of '0').  Because of this, after a write 
> to this debugfs file, it is difficult to predict the regions on which
> logging is enabled.
> 
> The DBG_REGION_ALL now includes 3 additional regions TCP_ENH, SPIN_DEBUG
> and FIRM_DBG.

Why did you add these extra ones?

All of this should eventually just be deleted, as network drivers need
to use the networking driver debug interfaces, not their own crazy ones.

thanks,

greg k-h
