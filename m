Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:61975 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZENRwa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 13:52:30 -0400
Received: by pxi29 with SMTP id 29so690857pxi.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 10:52:32 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 May 2009 10:52:12 -0700
Message-ID: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
Subject: Scan while TX/RX'ing a lot of data
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>, Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm told Network Manager scans every 60 seconds. When TX'ing or RX'ing
a lot of data you will see a big dip in throughput and sometimes it
may cause issues with some connections. Jouni pointed out a possible
nice option here: split the scans per channel through time. Now with
nl80211 this is possible but right now Network Manager uses wext
through wpa_supplicant in many distributions and this won't change for
a bit (maybe by the next major distribution releases?). Since we're
stuck with wext for the current distribution releases I'd like to hear
feedback on a possible nice solution. Should we simply cancel scan?

  Luis
