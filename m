Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:24607 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbbBSKvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2015 05:51:36 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC] zero-copy AMSDU processing
Date: Thu, 19 Feb 2015 12:51:10 +0200
Message-ID: <1708052.J876aMsZU2@lx-wigig-72> (sfid-20150219_115139_326083_61D4FCF7)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am looking for ideas how can one process AMSDU in the software, without copying data.
Current implementation like ieee80211_amsdu_to_8023s() do copy packet data.

Assume I got in the driver, MPDU that is AMSDU containing several MSDU's.
It is in the single memory buffer that was allocated for DMA.
Can I construct skb's per MSDU with minimal data copy, having most of the
original data in place? Any ideas for this?

Thanks, Vladimir.
