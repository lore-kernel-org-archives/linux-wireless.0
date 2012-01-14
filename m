Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2685 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab2ANUAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jan 2012 15:00:17 -0500
Message-ID: <4F11DEB8.7010708@broadcom.com> (sfid-20120114_210022_284836_40A04438)
Date: Sat, 14 Jan 2012 20:59:52 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Kay Sievers" <kay.sievers@vrfy.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Tom Gundersen" <teg@jklm.no>,
	"Andy Whitcroft" <apw@canonical.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: calling request_firmware() from module init will not work
 with recent/future udev versions
References: <CAPXgP11iT9K2KcDCJvw_druf5qdNjs0jLfrbpS7CcYh5vXrz_w@mail.gmail.com>
 <20120114175837.GA8504@tuxdriver.com> <4F11C75F.9030105@lwfinger.net>
In-Reply-To: <4F11C75F.9030105@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2012 07:20 PM, Larry Finger wrote:
> On 01/14/2012 11:58 AM, John W. Linville wrote:
>> Kay, thanks for the reports.  Drivers should definitely be loading
>> firmware at IFF_UP time.
> 
> As the maintainer for several drivers with this problem, I need to make some 
> changes. What call from mac80211 corresponds to IFF_UP?

Hi, Larry

The mac80211 start callback describes following:

 * @start: Called before the first netdevice attached to the hardware
 *	is enabled. This should turn on the hardware and must turn on
 *	frame reception (for possibly enabled monitor interfaces.)
 *	Returns negative error codes, these may be seen in userspace,
 *	or zero.
 *	When the device is started it should not have a MAC address
 *	to avoid acknowledging frames before a non-monitor device
 *	is added.
 *	Must be implemented and can sleep.

Seems to me a good place to do the firmware loading although it is not
really IFF_UP.

> I have looked into using asynchronous firmware loading, but I have not yet found 
> a good implementation.
> 
> Larry

In brcmsmac we request the firmware in the probe function so not in
module_init, but I guess upon driver registration in the module_init the
probe is called.

Gr. AvS

