Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34939 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2ATJCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jan 2012 04:02:52 -0500
Received: by pbaa10 with SMTP id a10so209760pba.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Jan 2012 01:02:51 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 20 Jan 2012 10:02:51 +0100
Message-ID: <CAGXE3d-EDtfND7tCE3pOru4uyMP1GO3GYxu=HF39utMz3Swp7Q@mail.gmail.com> (sfid-20120120_100318_997901_10D41BD4)
Subject: nl80211 tx power interface when max tx power is unknown?
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the tx power calibration data of rt2800 devices sometimes doesn't
contain the actually used tx power.

As such we cannot
1) provide the max tx power to mac80211
2) configure the hw to arbitrary tx power values

The legacy driver deals with these two cases:
1) When the calibration data contains the maximum EIRP tx power it
will use that to calculate the setting of arbitrary values.
2) If it is not available the legacy driver allows to set a percentage
value (50% ~ -3dBm, 25% ~ -6dBm etc.).

Would it make sense to add support to nl80211 for setting
tx power values as percentage of the original tx power instead of
using arbitrary dBm values?

Thanks,
Helmut
