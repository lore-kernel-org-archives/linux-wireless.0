Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:17197 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYKMXKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 18:10:34 -0500
Received: by qw-out-2122.google.com with SMTP id 3so697998qwe.37
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 15:10:32 -0800 (PST)
Message-ID: <69e28c910811131510w4fb4a204je611d7c18dd9b86d@mail.gmail.com> (sfid-20081114_001039_162952_35D29EA9)
Date: Fri, 14 Nov 2008 00:10:32 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: zd1211rw problem
Cc: "Karakontakis Apostolos" <akarako@freemail.gr>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081113002804.GA11329@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200811130120.48659.akarako@freemail.gr>
	 <20081113002804.GA11329@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 13, 2008 at 1:28 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Nov 13, 2008 at 01:20:48AM +0200, Karakontakis Apostolos wrote:
>> Hi,
>>
>> I have recenetly bought a usb wireless stick that requires zd1211rw driver
>> (ZyDAS ZD1211B chipset).With kernel 2.6.24 it works ok but with kernel
>> 2.6.27.2 it dos not.
>>
>> 1. I have the latest firmware in /lib/firmware/zd1211
>> 2. i have CONFIG_MAC80211 and CONFIG_FW_LOADER = y
>> 3. i have CONFIG_ZD1211RW=m
>>
>> when i insert the module i get the following errors
>>
>> Nov 13 01:02:20 hakarako kernel: mac80211: Unknown parameter
>> `ieee80211_regdom'
>
> This parameter no longer exists for mac80211.  A similar parameter
> now exists for cfg80211, but the format is different.
>
> The mac80211 module isn't loading due to the unknown parameter.
>
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_free_hw
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_alloc_hw
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
>> ieee80211_register_hw
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
>> ieee80211_tx_status_irqsafe
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
>> ieee80211_wake_queues
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
>> ieee80211_stop_queues
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol
>> ieee80211_unregister_hw
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_beacon_get
>> Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_rx_irqsafe
>
> Since mac80211 didn't load, zd1211rw won't load.
>
> Remove that mac80211 option from modprobe.conf (and possibly add the
> equivalent parameter to cfg80211), the modprobe zd1211rw again.
>
> John
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Also, be sure to set CONFIG_MAC80211=m (not =y).

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
