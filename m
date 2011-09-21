Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18732 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab1IUP6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 11:58:34 -0400
Date: Wed, 21 Sep 2011 11:58:25 -0400
From: Pavel Roskin <proski@gnu.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Christian Kapeller <christian.kapeller@cmotion.eu>,
	linux-wireless@vger.kernel.org
Subject: Re: Oops while loading firmware of ath9k_htc device.
Message-ID: <20110921115825.6e28bd75@mj> (sfid-20110921_175838_077081_B4CC31D1)
In-Reply-To: <CAD2nsn1KBtDrxLNMr_gJZTJ0hr0aZKg5JM+TSE2EfXe8YOxpKg@mail.gmail.com>
References: <1314956005.12761.10.camel@christian-kapeller>
	<CAD2nsn1KBtDrxLNMr_gJZTJ0hr0aZKg5JM+TSE2EfXe8YOxpKg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 5 Sep 2011 13:19:39 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> On Fri, Sep 2, 2011 at 3:03 PM, Christian Kapeller
> <christian.kapeller@cmotion.eu> wrote:

> > I use the openwrt backfire distribution on an arm device, with
> > kernel 2.6.31.12 and compat-wireless-2011-06-22. The firmware file
> > is at /lib/firmware/ar9271.fw
...
> >  (2.6.31.12 #1) PC is at get_device_parent+0x78/0x14c
> > LR is at get_device_parent+0x70/0x14c
...
> > Something goes wrong, starting in compat_firmware_class.c. I wasn't
> > able to nail it down yet.
> 
> please try to use the updated firmware
> http://wireless.kernel.org/download/htc_fw/1.3/
> unlikely the oops disappears

Indeed, it's very unlikely.

I suspect the compat_firmware_class.c code, which is specific to
compat-wireless. The way do debug it is to find out what's wrong in
get_device_parent and work from there.

I suggest trying the latest compat-wireless.

I think it might be possible to reproduce the problem on the same
kernel version (2.6.31.12) on a PC.

-- 
Regards,
Pavel Roskin
