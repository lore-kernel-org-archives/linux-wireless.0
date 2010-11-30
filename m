Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33281 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0K3TB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 14:01:29 -0500
Message-ID: <4CF54A03.2090104@ti.com>
Date: Tue, 30 Nov 2010 21:01:23 +0200
From: Gery Kahn <geryk@ti.com>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH 17/18] wl1271: Read MAC address from NVS file on HW startup
References: <1290079951-16793-1-git-send-email-arik@wizery.com> <1290079951-16793-18-git-send-email-arik@wizery.com> <4CF51CE8.9090809@ti.com> <AANLkTimtk2qXYOVPo+WRyV1Jhe-Fk-7hvoctuAF35ik7@mail.gmail.com>
In-Reply-To: <AANLkTimtk2qXYOVPo+WRyV1Jhe-Fk-7hvoctuAF35ik7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30.Nov.10 18:04, Arik Nemtsov wrote:
>> The code flow of the add if (wl1271_op_add_interface) overwrites it from
>> vif.
> Thats the point of the patch. The MAC can be overwritten at any point
> between HW initialization and add_interface(). Either by a TESTMODE
> cmd or even by "ifconfig wlan0 hw ether xx:xx:xx:xx:xx:xx". The patch
> makes sure the MAC address is set (the default value is in the NVS)
> when the hardware is initialized.
>
> This allows the creation of monitor interfaces for instance. These are
> created without calling the driver's add_interface() and require a
> valid MAC address to be set. Such a monitor interface is added by
> hostapd when creating an AP (which explains why this patch is included
> in the AP-support patch-set).
>
> When this patch is applied one should be careful to not set the mac
> twice with different MAC addresses, as this might cause problems for
> the upper layers.
>
> Regards,
> Arik
The idea is to eliminate the situation where anyone "should be careful 
to not set the
MAC twice".
If there is MAC from NVS, make it system wide, w/o need to care about 
it. On the other hand,
if MAC set by `ifconfig' same story, make it system wide.

Best regards,
Gery
