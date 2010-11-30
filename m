Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35378 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab0K3Tg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 14:36:26 -0500
Message-ID: <4CF55231.5000205@ti.com>
Date: Tue, 30 Nov 2010 21:36:17 +0200
From: Gery Kahn <geryk@ti.com>
MIME-Version: 1.0
To: Arik Nemtsov <arik@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH 17/18] wl1271: Read MAC address from NVS file on HW startup
References: <1290079951-16793-1-git-send-email-arik@wizery.com> <1290079951-16793-18-git-send-email-arik@wizery.com> <4CF51CE8.9090809@ti.com> <AANLkTimtk2qXYOVPo+WRyV1Jhe-Fk-7hvoctuAF35ik7@mail.gmail.com> <4CF54A03.2090104@ti.com> <AANLkTinbFBXi9J5up65tV2Hp-5-0jDbbLuuCEn6ts2nJ@mail.gmail.com>
In-Reply-To: <AANLkTinbFBXi9J5up65tV2Hp-5-0jDbbLuuCEn6ts2nJ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30.Nov.10 21:20, Arik Nemtsov wrote:
>> The idea is to eliminate the situation where anyone "should be careful to
>> not set the
>> MAC twice".
>> If there is MAC from NVS, make it system wide, w/o need to care about it. On
>> the other hand,
>> if MAC set by `ifconfig' same story, make it system wide.
> No one has to set the MAC address twice. This patch degrades
> gracefully - if there is no NVS file on disk, no harm done.
> This means a solution that only uses ifconfig or TESTMODE commands
> before adding an interface will also work.
>
> This patch only gives one the option to set the MAC address right when
> the HW is initialized, without resorting to scripts or usermode
> daemons. One has to simply put the NVS file on the filesystem and the
> MAC will be read from there. I found this easier from an engineering
> perspective.
>
> Note that even without this patch its possible to set the MAC address
> twice - use ifconfig, add a monitor interface and then use ifconfig
> again to change the MAC.
>
Fully agree. Just set vif where u set wl and the solution would be 
synced for your flow.
> Regards,
> Arik

