Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbHSPFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 11:05:09 -0400
Date: Wed, 19 Aug 2015 07:50:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra Gorentla <csgorentla@gmail.com>
Cc: rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, linux-kernel@vger.kernel.org,
	dan.carpenter@oracle.com
Subject: Re: [PATCH] staging: wilc1000: Set all options in region debugfs file
Message-ID: <20150819145028.GA20702@kroah.com> (sfid-20150819_170608_031322_743A1FE7)
References: <1439917337-18473-1-git-send-email-csgorentla@gmail.com>
 <20150819030100.GE4588@kroah.com>
 <20150819123012.GA20877@gcs-HP-Compaq-nx6320>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150819123012.GA20877@gcs-HP-Compaq-nx6320>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2015 at 06:00:12PM +0530, Chandra Gorentla wrote:
> On Tue, Aug 18, 2015 at 08:01:00PM -0700, Greg KH wrote:
> > On Tue, Aug 18, 2015 at 10:32:17PM +0530, Chandra S Gorentla wrote:
> > > This patch allows setting all options in the module's debug region
> > > options file 'wilc_debug_region'.  This functionality allows the user
> > > to enable logging from all regions (initialization, locks, firmware
> > > etc.) of the driver.  Logging from the following regions is enabled
> > > during the driver initialization:
> > > 
> > > INIT_DBG, GENERIC_DBG, CFG80211_DBG, FIRM_DBG and HOSTAPD_DBG
> > > 
> > > Before this change, the numerical value set is equal first byte of 
> > > input minus 0x30 (ASCII value of '0').  Because of this, after a write 
> > > to this debugfs file, it is difficult to predict the regions on which
> > > logging is enabled.
> > > 
> > > The DBG_REGION_ALL now includes 3 additional regions TCP_ENH, SPIN_DEBUG
> > > and FIRM_DBG.
> > 
> > Why did you add these extra ones?
> I added them because there is code support them and to avoid a holes in
> the range of the options.

But why do you need to debug such things?

> > All of this should eventually just be deleted, as network drivers need
> > to use the networking driver debug interfaces, not their own crazy ones.
> In that case, can I assume that we are not going forward with this change?

I hope not, please work on fixing the driver up to work properly (i.e.
not with this type of stuff...)

thanks,

greg k-h
