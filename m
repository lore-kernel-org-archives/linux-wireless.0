Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45455 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbaBTCrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 21:47:46 -0500
Received: by mail-vc0-f174.google.com with SMTP id im17so1328544vcb.33
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 18:47:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <877g8rxgyf.fsf@kamboji.qca.qualcomm.com>
References: <1392197866-1261-1-git-send-email-yeohchunyeow@gmail.com>
	<877g8rxgyf.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 20 Feb 2014 10:47:45 +0800
Message-ID: <CAEFj9870+z+2yxjO7F69bGv3XzKNmi+ddyF41WSnv2aR98kjrw@mail.gmail.com> (sfid-20140220_034749_941243_D041DE0F)
Subject: Re: [PATCH] ath10k: set the mactime of ieee80211_rx_status
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Why? Where do you need tsf exactly? And what bug are you actually fixing
> here?

There are two type of configuration modes that require local TSF, IBSS
and mesh for operation and also monitor mode.

For IBSS, it is use for merging of BSSID (mac address) with same SSID
name, but currently this is taking care by the following "ugly" patch.
http://lists.infradead.org/pipermail/ath10k/2014-February/001159.html

Mesh mode needs this for more accurate synchronization purpose.

Besides, the monitor mode requires this to add extra piece of
information in radiotap header for local TSF.

> Do we get some regressions because of proving only a 32 bit TSF? Which
> one is better, provide a 32-bit TSF or not at all?
32-bit is not good. It could cause problem when inter-operate with
other non-ath10k drivers with 64-bit local TSF. The better is that we
can get the 64-bit local TSF. providing high TSF and low TSF as found
in "struct wmi_comb_phyerr_rx_hd". Is this possible with current FW?

---
Chun-Yeow
