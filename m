Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37913 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbcDYWjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 18:39:35 -0400
Received: by mail-wm0-f42.google.com with SMTP id u206so46796wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2016 15:39:34 -0700 (PDT)
MIME-Version: 1.0
From: Jaap Jan Meijer <jjmeijer88@gmail.com>
Date: Tue, 26 Apr 2016 00:39:14 +0200
Message-ID: <CAA+NYvROwDFdHpHN8e23WwDjMQeG=Y2U4_dnXdtJXDW_EiEApw@mail.gmail.com> (sfid-20160426_003938_862784_0554E7CF)
Subject: BCM43241B4 SDIO WiFi strength of connected network unavailable in
 Android (brcmfmac)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently working on a Baytrail tablet with a BCM43241B4 SDIO WiFi
card. WiFi is working very well but as of Kernel 4.2 wpa_supplicant
can't get signal strength of the currently connected network.
I'm running Android-x86 on this tablet, from what I can make of it the
SIGNAL_POLL command is used for this network. When using a full scan
the signal strength is displayed correctly. This is wpa_supplicant 8
with NL80211 driver.
I was able to bisect it down to "1f0dc59 - brcmfmac: rework
.get_station() callback", just reverting the commit fixes it for me
but of course that's no proper solution. If there is anything I can do
to debug this problem further, please let me know.

Kind regards,

JJ Meijer
