Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49387 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab1JDP0y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 11:26:54 -0400
Received: by gyg10 with SMTP id 10so589094gyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 08:26:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
Date: Tue, 4 Oct 2011 17:26:40 +0200
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110041642.54453.chunkeey@googlemail.com> <CAJ-VmomWYUtd84APvEg7mKC-sevT3UVaX2qKBn3KiVriPZybgQ@mail.gmail.com>
In-Reply-To: <CAJ-VmomWYUtd84APvEg7mKC-sevT3UVaX2qKBn3KiVriPZybgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110041726.40722.chunkeey@googlemail.com> (sfid-20111004_172708_579919_C376E3C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 04, 2011 04:50:42 PM Adrian Chadd wrote:
> Also whilst I'm at it, "SPECTRUM_MANAGEMENT" is a very broad flag to set.

Hm, 802.11-2007 5.4.4 "Spectrum management services" explicitly
mentions that both services TPC and DFS are required in some
regulatory domains for operation in the 5 GHz band.

> For example: you may not want to do DFS on the AR5416 NICs because
> (as documented in the open hal and earlier ath9k bits) there isn't
> support for radar pulses on the ext channel. So even if you had a
> successful DFS algorithm for this NIC, you'd have to somehow tell
> the DFS machinery that HT40+DFS channels aren't supported but
> HT20+DFS channels are.
well, that's a pity. We do have seperated HT feature sets for each
band but they are not seperated by operation mode...

[ Just for fun: Do you know how the AR5418 handled radars in
the proprietary turbo mode in the 5 GHz band? And how does
Atheros own driver/stack/etc. deals with this limitation?
After all Unex sold/sells the DNBA-81 on their product page
as: <http://www.unex.com.tw/product/dnba-81>

"DNBA-81 is a 802.11n 2x3 2-stream a/b/g dual band wifi
Cardbus designed specifically for laptops and *access points*/
home gateways/consumer electronics/multimedia entertainment
devices/peripherals with standard Cardbus slot." ]

Regards,
	Chr
