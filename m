Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34441 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbbKSFxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2015 00:53:24 -0500
Received: by ioir85 with SMTP id r85so78655859ioi.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2015 21:53:23 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Nov 2015 21:53:23 -0800
Message-ID: <CAOMFOmX+D7sqjL+sKE3ae=6gowW-LJv1dHssdF71nTWODA950w@mail.gmail.com> (sfid-20151119_065329_637594_CB463AC4)
Subject: State of indoor navigation (11MC) in wireless core API
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: gregory.greenman@intel.com, johannes.berg@intel.com,
	emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

There is huge interest both from hardwire and software vendors in
using Indoor Navigation at mobile devices. We are interested in making
the ChromeOS ecosystem using this feature as well.

I checked how Android implements indoor navigation where it is used
for a while. It defines its custom API called Round-trip time [1].
Broadcom chips firmware implements 11MC draft for this.

I looked at current Linux tree and do not see any standard API for
this feature. iwlwifi/mvm/debugfs-vif.c file mentions "Time of Flight"
that seems 11MC related. Though this driver uses debugfs to
communicate with the driver. It does not sound like a best way to do
it. I would expect a callback in cfg80211 interface. Does anybody work
on more conventional API for this 11MC feature?

I expect that many wireless chips are going to implement 11MC in the
nearest future. Having such clean API from the start will simplify the
feature development.

[1] https://android.googlesource.com/platform/hardware/libhardware_legacy/+/master/include/hardware_legacy/rtt.h
