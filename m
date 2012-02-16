Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34890 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2BPOjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 09:39:09 -0500
Subject: Re: calling request_firmware() from module init will not work with
 recent/future udev versions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tom Gundersen <teg@jklm.no>, Andy Whitcroft <apw@canonical.com>
In-Reply-To: <4F3D0012.9070808@broadcom.com>
References: <CAPXgP11iT9K2KcDCJvw_druf5qdNjs0jLfrbpS7CcYh5vXrz_w@mail.gmail.com>
	 <1326621743.3448.1.camel@jlt3.sipsolutions.net>
	 <CAPXgP13b0uu3DgOGRL-_WKx-aSQN-f0xL6OmjNPBGf9fg0satA@mail.gmail.com>
	 ( sfid-20120115_163411_716244_29DE7A13) <1326704259.3510.3.camel@jlt3.sipsolutions.net>
	 <4F3CF0C1.3090304@broadcom.com>
	 <1329395881.3915.7.camel@jlt3.sipsolutions.net>
	 <4F3D0012.9070808@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Feb 2012 15:39:05 +0100
Message-ID: <1329403145.3915.10.camel@jlt3.sipsolutions.net> (sfid-20120216_153921_586251_AA7D60E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-16 at 14:09 +0100, Arend van Spriel wrote:


> > When the firmware loading fails, the driver should unbind from the
> > device that it failed for, and the retrying behaviour doesn't change
> > (and requires a rebind)

> That helps. My driver was happily bound to the device until unloading 
> the driver or unplugging the device.

Right, if it fails you should call device_release_driver()

johannes

