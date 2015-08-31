Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33200 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbbHaUxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 16:53:18 -0400
Received: by obcji4 with SMTP id ji4so7914932obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 13:53:18 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 31 Aug 2015 15:53:18 -0500
Message-ID: <CAAGWusB5n7=62VFdq-=h7BsP3fkwnG6dvjFdixL_SPBhw06S3A@mail.gmail.com> (sfid-20150831_225321_978979_D2ACDA83)
Subject: How to set a scan on a given frequency
From: Shengrong Yin <syin@uh.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I was using iw to scan a given frequency.
For example,
iw wlan0 scan freq 2412 | grep freq:
However, the result was scanned ssids with different frequencies
across 2.4 GHz band, which is
freq: 2462
freq: 2462
freq: 2437
freq: 2412
...
Why this happened? Shouldn't it return only the ssid with 2412?
I tried to debug iw using ddd. But failed to trace from iw to netlink
library. I traced to
listen_events(state,ARRAY_SIZE(cmds), cmds)
and then I was expected to wait for the scanning result.
The iw tool did only send out the scan request. The netlink library
will handle the scan and call the API provided by mac80211.
Then mac80211 will then request scan from the driver.

Please correct me if I was wrong about the scanning steps.
Should I specify the given frequency for scanning directly in Mac80211?

My goal was to write my own user space process that can handle scan on
a given frequency within a shortest time. But only on one particular frequency.

Thanks,
-Shengrong
