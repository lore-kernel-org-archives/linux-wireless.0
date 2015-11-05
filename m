Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48007 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030665AbbKECJf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 21:09:35 -0500
Date: Wed, 4 Nov 2015 18:09:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: glen lee <glen.lee@atmel.com>
Cc: devel@driverdev.osuosl.org, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, Nicolas.FERRE@atmel.com,
	adel.noureldin@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com,
	adham.abozaeid@atmel.com
Subject: Re: [PATCH V2 04/17] staging: wilc1000: wilc_wlan_cfg_set: add
 argument struct net_device
Message-ID: <20151105020931.GA29296@kroah.com> (sfid-20151105_030938_304937_4BEBC243)
References: <1446198443-6623-1-git-send-email-glen.lee@atmel.com>
 <1446198443-6623-4-git-send-email-glen.lee@atmel.com>
 <20151104204624.GC23896@kroah.com>
 <563AB36F.3070900@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <563AB36F.3070900@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 05, 2015 at 10:39:59AM +0900, glen lee wrote:
> >>+int wilc_wlan_cfg_set(struct net_device *dev, int start, u32 wid, u8 *buffer,
> >>+		      u32 buffer_size, int commit, u32 drvHandler)
> >>  {
> >>  	wilc_wlan_dev_t *p = &g_wlan;
> >>  	u32 offset;
> >>  	int ret_size;
> >>+	perInterface_wlan_t *nic = netdev_priv(dev);
> >>+	struct wilc *wilc;
> >>+	wilc = nic->wilc;
> >Again here, pass in a struct wilc *.
> 
> Thank you for your advise,
> I can use local structure wilc as you said but there are print line inside the function.
> The custom print lines will be changed with netdev_xxx format later, so I need to pass dev if necessary.
> I used wilc if net_device is unnecessary or unavailable.
> For this reason, Is this OK to use net_device if it is necessary?

You have a pointer to net_device in struct wilc, right?  Use that
pointer when you need it, wilc is your "primary" thing, not struct
net_device, to pass around.  You should never have to cast back and
forth when calling internal functions like this.

thanks,

greg k-h
