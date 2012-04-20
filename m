Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44661 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197Ab2DTPSD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 11:18:03 -0400
Message-ID: <4F917E26.8060106@lwfinger.net> (sfid-20120420_171808_162628_417EF14E)
Date: Fri, 20 Apr 2012 10:17:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Fry, Donald H" <donald.h.fry@intel.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kay@vrfy.org" <kay@vrfy.org>, "jcm@redhat.com" <jcm@redhat.com>,
	"linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>
Subject: Re: question on non-kernel patch
References: <1334868960.7300.10.camel@dfry-linux1> <20120420140917.GA13844@tuxdriver.com> <193F82CA5D80C84A83D67BB5D5B9FDE548154FE8@ORSMSX101.amr.corp.intel.com>
In-Reply-To: <193F82CA5D80C84A83D67BB5D5B9FDE548154FE8@ORSMSX101.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/20/2012 09:41 AM, Fry, Donald H wrote:
> Today we have wifi devices with stuff implemented in hardware and other things done in microcode.  For example the 6205 device.  Today we do modprobe iwlwifi to install and modprobe iwlwifi -r to remove the module.
>
> 'Tomorrow' we use the same hardware but with a different microcode file which changes the driver quite a bit.  The PCI device/vendor id's are the same since the hardware has not changed, however the kernel driver is new.
>
> We would like to shield the users from having to know the details of our driver and make things look pretty much like they do today.  What we have been testing, and have done a lot of code refactoring to clean the driver up in preparation for this change is the following:
>
> The base/core/common functionality is still called iwlwifi which interacts with the hardware.  On modprobe, the driver tries to find a microcode file to run based on the device/vendor id/sub-id.  While parsing the microcode file, it will indicate which software API it supports, which will indicate which specific module to use, module A (old) or module B (new).  This way the user still uses modprobe iwlwifi to install, and iwlwifi will request the appropriate specific module to make the hardware function.
>
> However, since module A (for example) requires iwlwifi, an attempt to modprobe iwlwifi -r results in a message that iwlwifi is still in use.  Module A must be removed first followed by iwlwifi, etc.  While this may be obvious from looking at lsmod for a kernel developer, it is not obvious for most users.  While trying to provide a user friendly way to accomplish this, I found the .conf files described in /etc/modprobe.d.  This is one way to hide the details of what we are doing, and allow most users to continue to install with modprobe iwlwifi and remove with modprobe iwlwifi -r.
>
> If there is a better way to do this, I am very open to suggestions.  If this is an acceptable solution, how do we get the iwlwifi.conf file out to the distros and user community before or at the same time as this new change so we do not break things?

How large are these two modules? With debugging disabled, iwlwifi is less than 
250K, which is not that large. Perhaps you could load both, or build both into a 
monolithic iwlwifi. The appropriate calls can be setup after the fw is read. Any 
globals in the two routines need to be unique anyway, otherwise the build will 
fail when iwlwifi is built in and not compiled as a module.

Larry
