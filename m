Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:51896 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab3BXNUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2013 08:20:09 -0500
Received: by mail-ob0-f180.google.com with SMTP id ef5so1991152obb.11
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2013 05:20:08 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 24 Feb 2013 14:20:07 +0100
Message-ID: <CACna6rx57gx7fLEq5Om7q2Pbn82vgRRhH5DpkKtsgyPjHKuEvA@mail.gmail.com> (sfid-20130224_142018_659905_D77FF1E9)
Subject: Dead code in brcms_c_compute_rspec
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: brcm80211 development <brcm80211-dev-list@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

I was looking for adding support for more devices in b43 and wanted to
check how did you handled reading PHY type/id from rxchan/chanstat
(it's a part of hardware-specific part of RX header).

In rate.c you have brcms_c_compute_rspec which does:
phy_type = ((rxh->RxChan & RXS_CHAN_PHYTYPE_MASK) >> RXS_CHAN_PHYTYPE_SHIFT);
(you duplicate BRCMS_CHAN_PHYTYPE by the way).

The problem is that:
#define	RXS_CHAN_PHYTYPE_MASK	0x0007
and you're comparing the result to the
#define	PHY_TYPE_LCN		8
which looks like a minor dead code for me.

You may want to fix that.

-- 
Rafał
