Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33613 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108Ab0JBDTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 23:19:36 -0400
Received: by bwz11 with SMTP id 11so2618966bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 20:19:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Saqeb Akhter <saqeb.akhter@gmail.com>
Subject: Re: carl9170: wnda3100 only 54MB/s
Date: Sat, 2 Oct 2010 05:19:27 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com> <201010020452.24306.chunkeey@googlemail.com> <AANLkTin2ycTicNim+ZiwNV3pWr7AQWPp432vJVLUL1k1@mail.gmail.com>
In-Reply-To: <AANLkTin2ycTicNim+ZiwNV3pWr7AQWPp432vJVLUL1k1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010020519.29042.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 02 October 2010 04:56:35 Saqeb Akhter wrote:
> Nope I already noticed that 1.8.8.3 was available so to that step, I
> am getting frequent disconnects though, it might have to do with
> NetworkManager doing background scanning so going to try and it it to
> stop doing that.
Channel changes (especially with HT) are more expensive with AR9170
than AR9271 which features "fastcc" (fast channel change).

> The NetGear driver on windows seems to ignore the WMM requirement
> looks like.
You can actually peek into the Windows' driver logic.
The code is available under drivers/staging/otus/(80211core)
AFAIK, it only checks if the HT IEs are all present.

> Either way that's what the problem was, going to see if i
> can get this disconnect problem sorted out.
I thought "the new" NetworkManager is more intelligent and
doesn't schedule scans while the device is actively
transmitting/receiving data. Anyway, NetworkManager is
"just" a manager for wpa_supplicant and wpa_supp works
well enough.

bye.

