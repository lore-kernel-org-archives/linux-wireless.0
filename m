Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57002 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1H3Jvw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 05:51:52 -0400
Message-ID: <4E5CB2B3.2040700@qca.qualcomm.com> (sfid-20110830_115155_749891_1E66D0E3)
Date: Tue, 30 Aug 2011 12:51:47 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/20] ath6kl: AP mode and P2P
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> This set of patches adds preliminary support for AP mode and P2P
> operations into ath6kl. Since these require a new firmware build
> and more testing, the patches to actually enable either AP or P2P
> modes are not included in the series. These will be submitted
> after some more testing.

I reviewed the patches. Looks good, I only found some minor issues.
There are also some sparse warnings:

drivers/net/wireless/ath/ath6kl/cfg80211.c:1695:14: warning: incorrect
type in assignment (different base types)
drivers/net/wireless/ath/ath6kl/cfg80211.c:1695:14:    expected
restricted __le16 [addressable] [assigned] [usertype] ch
drivers/net/wireless/ath/ath6kl/cfg80211.c:1695:14:    got unsigned
short [unsigned] [usertype] next_chan
drivers/net/wireless/ath/ath6kl/wmi.c:2632:20: warning: incorrect type
in assignment (different base types)
drivers/net/wireless/ath/ath6kl/wmi.c:2632:20:    expected unsigned
short [unsigned] [usertype] reason
drivers/net/wireless/ath/ath6kl/wmi.c:2632:20:    got restricted __le16
[usertype] <noident>

If you want, I can fix the issues I found before I merge the patches.

Kalle
