Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:36275 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbZIWHX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:23:56 -0400
MIME-Version: 1.0
In-Reply-To: <1253689036.4458.22.camel@johannes.local>
References: <1253662724-16497-1-git-send-email-tomas.winkler@intel.com>
	 <1253662724-16497-2-git-send-email-tomas.winkler@intel.com>
	 <1253689036.4458.22.camel@johannes.local>
Date: Wed, 23 Sep 2009 10:23:59 +0300
Message-ID: <1ba2fa240909230023v17fe2b49v4981d464dba469ed@mail.gmail.com>
Subject: Re: [PATCH 1/3] iwmc3200top: Add Intel Wireless MultiCom 3200 top
	driver.
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: davem@davemloft.net, linville@tuxdriver.com,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mmc@vger.kernel.org, yi.zhu@intel.com,
	inaky.perez-gonzalez@intel.com, cindy.h.kao@intel.com,
	guy.cohen@intel.com, ron.rindjunsky@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 23, 2009 at 9:57 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-09-23 at 02:38 +0300, Tomas Winkler wrote:
>
>> +config IWMC3200TOP
>> +        tristate "Intel Wireless MultiCom Top Driver"
>> +        depends on MMC && EXPERIMENTAL
>> +        select FW_LOADER
>> +     ---help---
>> +       Intel Wireless MultiCom 3200 Top driver is responsible for
>> +       for firmware load and enabled coms enumeration
>
> This seems like the wrong approach to me.
>
> To me, it seems like you have a device that contains an internal bus and
> allows bus enumeration. Typically, we would surface that bus in the
> driver/device model and allow sub-drivers to bind to that by way of
> exposing the internal bus, like e.g. drivers/ssb/.

>From HW perspective your assumption is not exactly correct. All the
devices are visible on the SDIO bus but they are not operational
(probe won't succeed) until TOP download the firmware and kicks the
devices. From SW perspective to create another bus layer is an option.
I'm not sure if it's not more complicated one.

Thanks
Tomas
