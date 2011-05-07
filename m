Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48734 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1EGUkw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 16:40:52 -0400
Received: by qyg14 with SMTP id 14so3290849qyg.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 13:40:51 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 7 May 2011 22:40:51 +0200
Message-ID: <BANLkTimRasoDAbK+tLNFx8zK96Xe1hnHXg@mail.gmail.com> (sfid-20110507_224105_450553_DADC3891)
Subject: ssb: where to reject dangling cores?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>
Cc: b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael, I can see code for ignoring dangling cores in both: ssb and b43.

In ssb it's quite common, we have:
1) we_support_multiple_80211_cores for 80211
2) inline checks in ssb_bus_scan for PCI(E)
3) inline check in ssb_bus_scan for ETHERNET

However there is also check in b43 at the beginning of b43_one_core_attach:
if (!pdev ||
	((pdev->device != 0x4321) &&
	(pdev->device != 0x4313) && (pdev->device != 0x431A))) {
	b43dbg(wl, "Ignoring unconnected 802.11 core\n");
	return -ENODEV;
}

Should I move this check into ssb?

-- 
Rafał
