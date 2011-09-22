Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3651 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1IVHYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 03:24:39 -0400
Message-ID: <4E7AE2B0.3060905@qca.qualcomm.com> (sfid-20110922_092443_122530_BD51463E)
Date: Thu, 22 Sep 2011 10:24:32 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/9] ath6kl: Use cfg80211 BSS table without local node
 table
References: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1316448907-10166-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 07:14 PM, Jouni Malinen wrote:
> This patch set fixes number of issues in how scan results were being
> reported to cfg80211 by properly using the cfg80211 BSS inform
> mechanism. There is no point in maintaining the internal node table in
> ath6kl since it is not really used for anything and the duplicated table
> implementation was just trying to handle functionality that is already
> present in cfg80211. In addition to fixing various roaming cases that
> resulted in errors due to incorrect information in the cfg80211 BSS
> table, this series removes the internal node table implementation that
> had its own issues that apparently could cause crashes in some cases.

This is really cool. I hated the node table right from the beginning.

I noticed that there were two magic constants used few times, 8 + 2 + 2
for the IE length and 95 for RSSI conversion. I would prefer to use a
define for those, but that can be changed later.

I have applied all nine patches. Thank you!

Kalle
