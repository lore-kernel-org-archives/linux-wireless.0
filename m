Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57340 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab1JDOum (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 10:50:42 -0400
Received: by ywb5 with SMTP id 5so553651ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 07:50:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110041642.54453.chunkeey@googlemail.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
	<201110041538.12885.chunkeey@googlemail.com>
	<4E8B157F.2080203@neratec.com>
	<201110041642.54453.chunkeey@googlemail.com>
Date: Tue, 4 Oct 2011 22:50:42 +0800
Message-ID: <CAJ-VmomWYUtd84APvEg7mKC-sevT3UVaX2qKBn3KiVriPZybgQ@mail.gmail.com> (sfid-20111004_165047_305022_A3BD5373)
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also whilst I'm at it, "SPECTRUM_MANAGEMENT" is a very broad flag to set.

For example: you may not want to do DFS on the AR5416 NICs because (as
documented in the open hal and earlier ath9k bits) there isn't support
for radar pulses on the ext channel. So even if you had a successful
DFS algorithm for this NIC, you'd have to somehow tell the DFS
machinery that HT40+DFS channels aren't supported but HT20+DFS
channels are.

But then, the AR5416 supports per-packet TPC, so you could use it in
STA mode perfectly fine and it'd support that part of spectrum
management. Since you get per-frame RSSI of RX'ed frames, you can
support the spectrum power histogram IE.

And since it supports quiet time stuff, you can use it in STA and
hostap mode for supporting the quiet time IE.

(Yes, I'm looking at how to make all of this work in FreeBSD net80211,
as some patches have been supplied to start fleshing out these
functions. :)

I'm not saying this needs to be solved now, but I think it's worth
thinking about how to encapsulate exactly what it is that NICs
support, rather than simply saying "yup, 11h is here, all good mate."


Adrian
