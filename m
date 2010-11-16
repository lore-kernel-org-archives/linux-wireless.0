Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54842 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab0KPRDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 12:03:18 -0500
Message-ID: <4CE2B953.9090509@candelatech.com>
Date: Tue, 16 Nov 2010 09:03:15 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: RFC/PATCH:  Allow wpa_supplicant to share scan results.
References: <4CE1CEC6.2050103@candelatech.com> <20101116094512.GB21872@jm.kir.nu>
In-Reply-To: <20101116094512.GB21872@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2010 01:45 AM, Jouni Malinen wrote:
> On Mon, Nov 15, 2010 at 04:22:30PM -0800, Ben Greear wrote:
>> The attached (and inline) patch allows wpa_supplicant to share scan results
>> between all VIFS on the same radio (phy).  This patch is a bit rough, but
>> it does appear to do what I was hoping for.
>>
>> Please let me know if this has any chance and upstream inclusion.
>
> With the changes in wpa_supplicant/events.c, the likelihood of that
> getting anywhere is about zero, but if the driver specific changes were
> to be moved to src/drivers/driver_nl80211.c, this could be quite a
> reasonable change to include in the upstream tree. Note the
> global_init() and init2() struct wpa_driver_ops callbacks that should
> make it easy to track the interfaces within driver_nl80211.c.

It would be easy enough to save the phyname in the wpa_s struct so it
doesn't need to be probed all the time.

As for the logic that actually propagates scan results to all of the
peer VIFS, do you mean you want that moved farther up into the driver
as well?

> I would like to have more knowledge of virtual interfaces sharing the
> same radio in the driver wrappers anyway, e.g., for shared_freq()
> implementations. If this can be reliably detected from the driver (which
> hopefully is the case with mac80211-based ones), it would be great to be
> able to that without having to ask the user to configure anything.

It simple to know the phy-name for a particular VIF (on the latest kernel),
so knowing parent-child and sibling relationships is also easy.  Older
kernels don't have the phy-name available in sysfs, but they also didn't
support multiple VIFS well anyway..so maybe just ignore them?

>
>> I know I need to at least strip out some of the debug code, and make
>> this optional via the global config file, but I was hoping early feedback
>> might save more work later...
>
> What would be need for configuring this? In which case would it be
> preferred to not process the scan results from other virtual interfaces
> on the same radio? Wouldn't those scan events look exactly like the same
> if some other application would have triggered them?

I was afraid that one VIF might scan with one set of scan-options and another
a different set.  However, I have no real understanding of how wpa_supplicant
works, so if you think it can be always enabled, then I'm fine with that.

Also, with it enabled, I can currently reliably crash ath9k.  This is a
kernel bug that hopefully can be fixed soon, but it would be one small reason to
keep the old behaviour available.

> In addition, it might be interesting to considering sharing the BSS
> table and scan result parsing in wpa_supplicant among the interface,
> too, instead of just the scan completed events..

I'm happy to test patches..but I probably don't have time to do more
than the bare minimum to get the shared-scan results functional at
this time.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
