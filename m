Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:59922 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab2DTOl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 10:41:59 -0400
From: "Fry, Donald H" <donald.h.fry@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kay@vrfy.org" <kay@vrfy.org>, "jcm@redhat.com" <jcm@redhat.com>,
	"linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>
Subject: RE: question on non-kernel patch
Date: Fri, 20 Apr 2012 14:41:57 +0000
Message-ID: <193F82CA5D80C84A83D67BB5D5B9FDE548154FE8@ORSMSX101.amr.corp.intel.com> (sfid-20120420_164204_960058_DBA867CB)
References: <1334868960.7300.10.camel@dfry-linux1>
 <20120420140917.GA13844@tuxdriver.com>
In-Reply-To: <20120420140917.GA13844@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Today we have wifi devices with stuff implemented in hardware and other things done in microcode.  For example the 6205 device.  Today we do modprobe iwlwifi to install and modprobe iwlwifi -r to remove the module.

'Tomorrow' we use the same hardware but with a different microcode file which changes the driver quite a bit.  The PCI device/vendor id's are the same since the hardware has not changed, however the kernel driver is new.

We would like to shield the users from having to know the details of our driver and make things look pretty much like they do today.  What we have been testing, and have done a lot of code refactoring to clean the driver up in preparation for this change is the following:

The base/core/common functionality is still called iwlwifi which interacts with the hardware.  On modprobe, the driver tries to find a microcode file to run based on the device/vendor id/sub-id.  While parsing the microcode file, it will indicate which software API it supports, which will indicate which specific module to use, module A (old) or module B (new).  This way the user still uses modprobe iwlwifi to install, and iwlwifi will request the appropriate specific module to make the hardware function.

However, since module A (for example) requires iwlwifi, an attempt to modprobe iwlwifi -r results in a message that iwlwifi is still in use.  Module A must be removed first followed by iwlwifi, etc.  While this may be obvious from looking at lsmod for a kernel developer, it is not obvious for most users.  While trying to provide a user friendly way to accomplish this, I found the .conf files described in /etc/modprobe.d.  This is one way to hide the details of what we are doing, and allow most users to continue to install with modprobe iwlwifi and remove with modprobe iwlwifi -r.

If there is a better way to do this, I am very open to suggestions.  If this is an acceptable solution, how do we get the iwlwifi.conf file out to the distros and user community before or at the same time as this new change so we do not break things?

Thanks,
Don

-----Original Message-----
From: John W. Linville [mailto:linville@tuxdriver.com] 
Sent: Friday, April 20, 2012 7:09 AM
To: Fry, Donald H
Cc: linux-wireless@vger.kernel.org; kay@vrfy.org; jcm@redhat.com; linux-modules@vger.kernel.org
Subject: Re: question on non-kernel patch

On Thu, Apr 19, 2012 at 01:56:00PM -0700, Don Fry wrote:
> Hi John,
> 	We have a change to the iwlwifi driver for the near future which will 
> dynamically load a different module based on the version of microcode 
> installed on the system.  The driver does a request_module_nowait 
> after obtaining the firmware file loaded as part of modprobe.  This 
> all works fine, however unloading the module is not 
> symmetrical/straight forward.
> 	It looks like there are capabilities already implemented to make this 
> easy.  If I put the following script into /etc/modprobe.d then 
> modprobe iwlwifi-r will do the right thing.
> 	It is backward compatible with the current iwlwifi driver.
> How do I get this out in the community before we submit the patch that 
> would break iwlwifi removal?
> 
> Thanks,
> Don
> 
> 
> # /etc/modprobe.d/iwlwifi.conf
> # iwlwifi will dyamically load either iwldvm or iwlmvm depending on 
> the # microcode file installed on the system.  When removing iwlwifi, 
> first # remove the iwl?vm module and then iwlwifi.
> remove iwlwifi \
> (/sbin/lsmod | grep -o -e ^iwlmvm -e ^iwldvm -e ^iwlwifi | xargs 
> /sbin/rmmod) \ && /sbin/modprobe -r mac80211

Honestly, I'm not entirely sure -- this seems like a peculiar situation.  Can you go into more detail about why this seems necessary?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
