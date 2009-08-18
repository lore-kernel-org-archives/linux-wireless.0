Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:60124 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZHRTaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 15:30:03 -0400
Received: by bwz22 with SMTP id 22so3236747bwz.18
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 12:30:02 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: configure_filter() callback is allowed to sleep
References: <200908181954.23419.IvDoorn@gmail.com>
	<1250618324.9886.25.camel@johannes.local>
	<200908182004.58584.IvDoorn@gmail.com>
	<1250618853.7887.0.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 18 Aug 2009 22:30:00 +0300
In-Reply-To: <1250618853.7887.0.camel@johannes.local> (Johannes Berg's message of "Tue\, 18 Aug 2009 20\:07\:33 +0200")
Message-ID: <87my5wudhj.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> I wonder if drivers now ever have a reason to queue work on the mac80211
> workqueue? Some periodic calibration tasks maybe?

wl1251 and wl1271 queue tx frames to a workqueue. This is because they
use synchronous spi interface. This might change if we switch
asynchronous interface in the future. No idea how this affects sdio,
though.

-- 
Kalle Valo
