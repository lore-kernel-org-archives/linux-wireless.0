Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40080 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab2DTORk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 10:17:40 -0400
Date: Fri, 20 Apr 2012 10:09:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Don Fry <donald.h.fry@intel.com>
Cc: linux-wireless@vger.kernel.org, kay@vrfy.org, jcm@redhat.com,
	linux-modules@vger.kernel.org
Subject: Re: question on non-kernel patch
Message-ID: <20120420140917.GA13844@tuxdriver.com> (sfid-20120420_161743_955858_9F78A34C)
References: <1334868960.7300.10.camel@dfry-linux1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334868960.7300.10.camel@dfry-linux1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 19, 2012 at 01:56:00PM -0700, Don Fry wrote:
> Hi John,
> 	We have a change to the iwlwifi driver for the near future
> which will dynamically load a different module based on the version
> of microcode installed on the system.  The driver does a
> request_module_nowait after obtaining the firmware file loaded as part
> of modprobe.  This all works fine, however unloading the module is not
> symmetrical/straight forward.
> 	It looks like there are capabilities already implemented to
> make this easy.  If I put the following script into /etc/modprobe.d
> then modprobe iwlwifi-r will do the right thing.
> 	It is backward compatible with the current iwlwifi driver.
> How do I get this out in the community before we submit the patch that
> would break iwlwifi removal?
> 
> Thanks,
> Don
> 
> 
> # /etc/modprobe.d/iwlwifi.conf
> # iwlwifi will dyamically load either iwldvm or iwlmvm depending on the
> # microcode file installed on the system.  When removing iwlwifi, first
> # remove the iwl?vm module and then iwlwifi.
> remove iwlwifi \
> (/sbin/lsmod | grep -o -e ^iwlmvm -e ^iwldvm -e ^iwlwifi | xargs /sbin/rmmod) \
> && /sbin/modprobe -r mac80211

Honestly, I'm not entirely sure -- this seems like a peculiar
situation.  Can you go into more detail about why this seems necessary?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
