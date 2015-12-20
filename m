Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35739 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbbLTTMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2015 14:12:07 -0500
Received: by mail-io0-f194.google.com with SMTP id o67so12283896iof.2
        for <linux-wireless@vger.kernel.org>; Sun, 20 Dec 2015 11:12:06 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 20 Dec 2015 14:12:06 -0500
Message-ID: <CALGY4ftVUReiT-USxFWK3TKt5iLtTf7eWovEy=wvs_nYQWe9xQ@mail.gmail.com> (sfid-20151220_201235_072635_E16A7AA7)
Subject: QCA9377 constantly deauthenticating from 802.11ac access point
From: Nikolay Martynov <mar.kolya@gmail.com>
To: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I've got lenovo laptop with QCA9377 (chip_id: 0x003820ff). It
connects to TP-Link Archer C7 v2 AP (QCA9558), running OpenWRT.

On client I run Ubuntu 14.04 with 4.2.0 kernel and latest backports.
It connect just fine, but disconnects after about 1 minute with this message:

Dec 20 01:10:13 wpa_supplicant[7245]: nl80211: Ignored event (cmd=20)
for foreign interface (ifindex 4 wdev 0x0)
Dec 20 01:10:13 wpa_supplicant[7245]: nl80211: Drv Event 20
(NL80211_CMD_DEL_STATION) received for wlan0
Dec 20 01:10:13 wpa_supplicant[7245]: nl80211: Delete station xx:xx:xx:xx:xx:xx
Dec 20 01:10:13 kernel: [ 7107.316037] wlan0: deauthenticating from
xx:xx:xx:xx:xx:xx by local choice (Reason: 3=DEAUTH_LEAVING)

And then it keeps connecting and disconnecting. While it is connected
bandwidth is quite good and no errors seem to be happening, but then
connection drops for no obvious reason.

It looks like it doesn't do this when I switch AP to 802.11n mode.

Is this a known issue?
If not, what would be the best way to debug this? Is there any way to
get more information on why it decided to delete this station?

Thanks.

-- 
Martynov Nikolay.
Email: mar.kolya@gmail.com
