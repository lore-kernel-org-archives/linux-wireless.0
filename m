Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail48.e.nsc.no ([193.213.115.48]:50379 "EHLO mail48.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041Ab3EXTLo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 May 2013 15:11:44 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	"Ismail\, Rahman" <abdul.r.ismail@intel.com>,
	"Wallick\, Stephanie S" <stephanie.s.wallick@intel.com>
Subject: Re: Mobile Broadband Interface Model (MBIM) support?
References: <20130524170915.GA15788@xanatos>
Date: Fri, 24 May 2013 20:14:54 +0200
In-Reply-To: <20130524170915.GA15788@xanatos> (Sarah Sharp's message of "Fri,
	24 May 2013 10:09:15 -0700")
Message-ID: <87ip28fdnl.fsf@nemi.mork.no> (sfid-20130524_211149_005400_77E12331)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sarah Sharp <sarah.a.sharp@linux.intel.com> writes:

> Do we have support for the new extensions for USB communication devices
> that use the Mobile Broadband Interface Model (MBIM) spec?

We do. See drivers/net/usb/cdc_mbim.c. It's a usbnet minidriver based on
reusing parts of cdc_ncm.  It should be fairly complete, but the IP
session multiplexing and Device Service Streams features are not tested
on actual devices.  I just haven't found any device with those features
yet.  Any hints are appreciated...

The management protocol implementation is completely delegated to
userspace. The driver isn't involved at all. One implementation is
libmbim, which just had its 1.0.0 release:
http://www.freedesktop.org/software/libmbim/

The next ModemManager release will support MBIM devices using this
library.

> http://www.usb.org/developers/devclass_docs/MBIM10Errata1.zip

Thanks for that pointer.  I haven't seen the errata before. Will study
it, but fortunately we are protected against anything involving
management protocol updates.

> The spec was released pretty recently, which is why I'm asking on the
> mailing lists, rather than digging around the kernel tree for a driver.

Well, a "git grep MBIM drivers/" would be enough.   But I'm happy to
answer your questions :)


Bjørn
