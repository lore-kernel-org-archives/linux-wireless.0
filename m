Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab0JDRza (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 13:55:30 -0400
Subject: Re: carl9170: wnda3100 only 54MB/s
From: Dan Williams <dcbw@redhat.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Saqeb Akhter <saqeb.akhter@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201010020519.29042.chunkeey@googlemail.com>
References: <AANLkTimN3X_e4fZhUSoTs-GmQ9kmaJUrgnxAu8=W2dT_@mail.gmail.com>
	 <201010020452.24306.chunkeey@googlemail.com>
	 <AANLkTin2ycTicNim+ZiwNV3pWr7AQWPp432vJVLUL1k1@mail.gmail.com>
	 <201010020519.29042.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 12:58:41 -0500
Message-ID: <1286215121.2255.3.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-10-02 at 05:19 +0200, Christian Lamparter wrote:
> On Saturday 02 October 2010 04:56:35 Saqeb Akhter wrote:
> > Nope I already noticed that 1.8.8.3 was available so to that step, I
> > am getting frequent disconnects though, it might have to do with
> > NetworkManager doing background scanning so going to try and it it to
> > stop doing that.
> Channel changes (especially with HT) are more expensive with AR9170
> than AR9271 which features "fastcc" (fast channel change).
> 
> > The NetGear driver on windows seems to ignore the WMM requirement
> > looks like.
> You can actually peek into the Windows' driver logic.
> The code is available under drivers/staging/otus/(80211core)
> AFAIK, it only checks if the HT IEs are all present.
> 
> > Either way that's what the problem was, going to see if i
> > can get this disconnect problem sorted out.
> I thought "the new" NetworkManager is more intelligent and
> doesn't schedule scans while the device is actively
> transmitting/receiving data. Anyway, NetworkManager is
> "just" a manager for wpa_supplicant and wpa_supp works
> well enough.

NM >= 0.8.1 will request periodic scans unless you've locked the device
to a specific BSSID, because if you've done this you are indicating that
you don't need roaming.  If you haven't specified a BSSID, then we still
need periodic scans in case the device needs to roam between APs in a
multi-AP system.

Note that some drivers still appear to ignore BSSID locking.

Dan


