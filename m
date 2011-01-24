Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1AXPvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 10:51:01 -0500
Received: from hpaq6.eem.corp.google.com (hpaq6.eem.corp.google.com [172.25.149.6])
	by smtp-out.google.com with ESMTP id p0OFoxp8006299
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 07:51:00 -0800
Received: from eyg24 (eyg24.prod.google.com [10.208.7.24])
	by hpaq6.eem.corp.google.com with ESMTP id p0OForj5000900
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 07:50:54 -0800
Received: by eyg24 with SMTP id 24so1990517eyg.10
        for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 07:50:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1295868454.3639.0.camel@jlt3.sipsolutions.net>
References: <1295867209-6156-1-git-send-email-aidapalapati@nvidia.com>
	<1295868454.3639.0.camel@jlt3.sipsolutions.net>
Date: Mon, 24 Jan 2011 07:50:36 -0800
Message-ID: <AANLkTinmt7VcUAFL=GmZv46x8eC2THUEC-OhHGBCeSav@mail.gmail.com>
Subject: Re: [PATCH 1/1] CHROMIUM: config: bluetooth: rfkill driver
From: Olof Johansson <olofj@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: aidapalapati@nvidia.com, linville@tuxdriver.com, uraval@nvidia.com,
	krakesh@nvidia.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 3:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-01-24 at 16:36 +0530, aidapalapati@nvidia.com wrote:
>
>> A new "rfkill" driver is added to control BT radio.
>> A new kernel config variable CONFIG_BT_RFKILL needs to
>> be configured to include this driver in the kernel.
>>
>> Three resources are expected by the driver.
>> One Shutdown GPIO, One Reset Gpio and One reference Clock.
>> if any/all of the resources can be defined by a platform.
>
> If that's a generic driver, why can it use
>
>> +             tegra_gpio_enable(bt_rfkill->gpio_reset);
>
> tegra_* functions?

Good catch, I had missed that when I did the initial once-over on the driver.

Anantha, the tegra_gpio_enable should be moved to the board setup file
and out of the driver itself.


-Olof
