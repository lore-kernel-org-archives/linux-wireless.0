Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58208 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab1LBE3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 23:29:05 -0500
Received: by wgbdr13 with SMTP id dr13so296683wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 20:29:03 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 1 Dec 2011 23:29:03 -0500
Message-ID: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com> (sfid-20111202_052910_037002_B91C34E9)
Subject: iwlwifi: kernel panic if try to open tid with large index (>=8)
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I have an intel 5300 card running on latest compat-wireless.
  If I do:
echo "tx start 8" >
/sys/kernel/debug/ieee80211/phy0/netdev\:wlan1/stations/XX\:XX\:XX\:XX\:XX\:XX/agg_status
  I get two pages of kernel stack trace and complete freeze, no
messages left in any logs after reboot.
  I looks like driver doesn't correctly check that this tid is
actually supported when it comes from mac80211 layer.
  This doesn't seem like a huge issue, just an annoying one.

  Please let me knoe if I can provide any more information.
  Thanks.

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
