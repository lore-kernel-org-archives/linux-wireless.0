Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33036 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450AbbLAV74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 16:59:56 -0500
Received: by iouu10 with SMTP id u10so25875805iou.0
        for <linux-wireless@vger.kernel.org>; Tue, 01 Dec 2015 13:59:55 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 1 Dec 2015 13:59:55 -0800
Message-ID: <CAOMFOmV-TdX2h2patazVuffZmy=MAqHfnLso90kQn5+d=ODU9w@mail.gmail.com> (sfid-20151201_225959_079001_7630D8E2)
Subject: MAC address randomization support
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: "Greenman, Gregory" <gregory.greenman@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

At ChromeOS we are looking at utilizing MAC address randomization.
There are some ChromeOS use-cases where it can be useful. I checked
upstream kernel and Android source code to understand the current
state of this feature.

This feature is supported in Android and a few products use it already
for Preferred Network Offload scan. There is a HAL method that allows
to set MAC OUI [1] that makes 3 first octets predefined and the rest
of MAC address is randomized. Kernel passes this OUI value to firmware
where the randomization is implemented.

I checked current upstream kernel and did not find any API for
enabling/dealing with MAC address randomization. If a firmware devs
want to add the feature easily then there should be some standard API
for enabling/configuring MAC randomization.

In fact there is one mention of the feature in upstream source tree -
macaddr_* fields in "struct iwl_tof_range_req_cmd" of iwlwifi driver.
It allows to enable/disable randomization for 11MC measurement.

The MAC randomization could be used by other drivers for many
use-cases and I think it worth making it a part of standard cfg80211
API. Is it something maintainers are interested in? Does anybody work
on it already?

[1] https://android.googlesource.com/platform/hardware/libhardware_legacy/+/master/include/hardware_legacy/wifi_hal.h
