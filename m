Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49546 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab1BQSQd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Feb 2011 13:16:33 -0500
Received: by qyk12 with SMTP id 12so2968314qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 10:16:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201101301322.42545.IvDoorn@gmail.com>
References: <201101301316.04044.IvDoorn@gmail.com>
	<201101301322.04131.IvDoorn@gmail.com>
	<201101301322.23247.IvDoorn@gmail.com>
	<201101301322.42545.IvDoorn@gmail.com>
Date: Thu, 17 Feb 2011 19:16:31 +0100
Message-ID: <AANLkTine_5SnsKH9GF6z1VB+wiKANpx4g5MvVqYkYt29@mail.gmail.com>
Subject: Re: [PATCH 17/21] rt2x00: Fix WPA TKIP Michael MIC failures.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/1/30 Ivo van Doorn <ivdoorn@gmail.com>:
> From: Gertjan van Wingerde <gwingerde@gmail.com>
>
> As reported and found by Johannes Stezenbach:
> rt2800{pci,usb} do not report the Michael MIC in RXed frames, but do check
> the Michael MIC in hardware. Therefore we have to report to mac80211 that the
> received frame does not include the Michael MIC.

Thank you, thank you very much! This fixes:
https://bugzilla.kernel.org/show_bug.cgi?id=16608

Should it go to 2.6.38-rcX? As it fixes bug, does not introduce new
features and is quite "safe"?

-- 
Rafał
