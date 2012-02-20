Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1594 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751682Ab2BTRpJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Feb 2012 12:45:09 -0500
Message-ID: <4F42865A.5060006@broadcom.com> (sfid-20120220_184515_938719_C709EDA2)
Date: Mon, 20 Feb 2012 18:43:54 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Kay Sievers" <kay.sievers@vrfy.org>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Tom Gundersen" <teg@jklm.no>,
	"Andy Whitcroft" <apw@canonical.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Greg KH" <greg@kroah.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: calling request_firmware() from module init will not work
 with recent/future udev versions
References: <CAPXgP11iT9K2KcDCJvw_druf5qdNjs0jLfrbpS7CcYh5vXrz_w@mail.gmail.com>
In-Reply-To: <CAPXgP11iT9K2KcDCJvw_druf5qdNjs0jLfrbpS7CcYh5vXrz_w@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2012 04:25 PM, Kay Sievers wrote:
> We changed udev to strictly enforce sequence order and dependency
> handling of events. This seems to break some netdev drivers which
> block in modprobe until the firmware from userspace is loaded into the
> driver.

Working on the issue complicated the behavior of the driver so I decided 
to take a step back to determine the actual issue.

> These are the drivers we received bug reports so far. We didn't look
> into any of details of the drivers, but according to the logs, they
> seem to block for 60 seconds in modprobe, when userspace is not
> behaving like expected:
>    bnx2/bnx2-mips-06-6.2.1.fw
>    rtlwifi/rtl8192sefw.bin
>    brcm/bcm43xx-0.fw

The main problem is that the init_module() syscall should not block. 
However, the driver I am responsible for (brcm80211) does not request 
firmware in the init_module() path. It does that on the probe() 
callback. So the problem is that the probe() code path is done in the 
context of the init_module() syscall. So the thing to do is decouple the 
probe() callback from the init_module() syscall.

One option is using the nowait version of request_firmware(), but 
another option I am considering is to defer the driver registration 
using a workqueue and schedule it in the init_module() syscall. That way 
I think I can avoid having to call the device_unregister_driver() when 
firmware loading fails.

Another thing to consider is to change the driver core subsystem and 
assure the probe() callback is never done in the init_module() context.

Any opinions?

Gr. AvS

