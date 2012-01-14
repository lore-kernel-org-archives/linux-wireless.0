Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40296 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2ANUPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jan 2012 15:15:21 -0500
MIME-Version: 1.0
In-Reply-To: <4F11E1CE.2050008@lwfinger.net>
References: <CAPXgP11iT9K2KcDCJvw_druf5qdNjs0jLfrbpS7CcYh5vXrz_w@mail.gmail.com>
	<20120114175837.GA8504@tuxdriver.com>
	<4F11C75F.9030105@lwfinger.net>
	<4F11DEB8.7010708@broadcom.com>
	<4F11E1CE.2050008@lwfinger.net>
Date: Sat, 14 Jan 2012 22:15:19 +0200
Message-ID: <CANUX_P2OGvazES0pGA+RnfWnHNJ6+0Rre9j0SOav_7idHNM-2A@mail.gmail.com> (sfid-20120114_211526_203627_9029B06A)
Subject: Re: calling request_firmware() from module init will not work with
 recent/future udev versions
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tom Gundersen <teg@jklm.no>,
	Andy Whitcroft <apw@canonical.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 14, 2012 at 22:13, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 01/14/2012 01:59 PM, Arend van Spriel wrote:
>>
>> On 01/14/2012 07:20 PM, Larry Finger wrote:
>>>
>>> On 01/14/2012 11:58 AM, John W. Linville wrote:
>>>>
>>>> Kay, thanks for the reports.  Drivers should definitely be loading
>>>> firmware at IFF_UP time.
>>>
>>>
>>> As the maintainer for several drivers with this problem, I need to make
>>> some
>>> changes. What call from mac80211 corresponds to IFF_UP?
>>
>>
>> Hi, Larry
>>
>> The mac80211 start callback describes following:
>>
>>  * @start: Called before the first netdevice attached to the hardware
>>  *     is enabled. This should turn on the hardware and must turn on
>>  *     frame reception (for possibly enabled monitor interfaces.)
>>  *     Returns negative error codes, these may be seen in userspace,
>>  *     or zero.
>>  *     When the device is started it should not have a MAC address
>>  *     to avoid acknowledging frames before a non-monitor device
>>  *     is added.
>>  *     Must be implemented and can sleep.
>>
>> Seems to me a good place to do the firmware loading although it is not
>> really IFF_UP.
>>
>>> I have looked into using asynchronous firmware loading, but I have not
>>> yet found
>>> a good implementation.
>>>
>>> Larry
>>
>>
>> In brcmsmac we request the firmware in the probe function so not in
>> module_init, but I guess upon driver registration in the module_init the
>> probe is called.
>
>

I looked once at the pci_register_driver, and if I remember well, the
probe in called in the same context of pci_register_driver. The driver
registration fires a bus enumeration.
FWIW, drivers might need to fetch their fw before registering
mac80211. This can happen if they need their fw to know their
capabilities...

>
> The rtlwifi drivers also load the firmware in the probe function, but do so
> synchronously, which is where they get in trouble with the new udev.
>
> I'm planning on converting to asynchronous firmware loading with a check in
> the start routine.
>

so does iwlwifi
