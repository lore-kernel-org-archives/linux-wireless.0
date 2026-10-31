Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793444773;
	b=p8NVA9T5iXx62V3CLos8W1vudiJGjg8rB5WlfYPWnj0wwOCD2PWXNOOL3nTs4Z2wNahH
	 G8TWY28aapy8LgwOvKIIDyiumIiUqUQpTHcRnRD0HF0G6WtW2fslHaR91jkvLntBH/HFp
	 op1+dv5WVDzq3y1QicYedguGScxmrGd+IgMoFfhAD/MBOdOTo0dk+rkoND1V50b/3K98W
	 CaFFpgjj4BeNovJnwMrC0QUttrMmPDJLRekThbVQuYBIV8ov78mVoNEM3Yj+MaorEM7xN
	 2i3hkrEMkx8AdZ/QhKDyO5NOI+02ky4HXXKszqh1IEwkW3sgfxhu4lv2sgEgN2KGg3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793444773;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=YYYiZeIarG26HWVQV4zePGaIw+qvE8QRJcOljSaV4/I=;
	b=mjjevWi2Q4/Ms9j1Yt0oR6kfqQY8q68X8rtvTL3+t0vq2dkAJdr5nP0iEumLPfggAdh5
	 d1b0hbpriF9ao9nk0vX/6uM2ePjBa12Y1J8D6cnspRqzvQkBbf84rcmf9RWduODwbKfOc
	 Drn8tVbZ4cH3TfiZuHOtTD5cMmRs5opL+OYaFXAYJ5l4fFQCuLQrmXPU3nxerXXfP3xxM
	 JHxxoZVS4n1LZ6OYzTvDDMFKTrOhCLmDrHpns0RDGN72XkVdLhPNU612WAoQbo8mLY69m
	 va0KZN/N6LtTszhX3dBo4Ca8oeYVIibfKFAeTDNU6fSnL/Tay3ABYbthITYTUB5F+EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=ivqmU6Ia;
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23010606A31C
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 11:06:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23010606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=ivqmU6Ia
Received: (wp-smtpd smtp.wp.pl 21341 invoked from network); 31 Oct 2026 12:06:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793444769; bh=YYYiZeIarG26HWVQV4zePGaIw+qvE8QRJcOljSaV4/I=;
          h=From:To:Cc:Subject;
          b=ivqmU6IaMbGCXikTf1UbD9GQ79SBcXQ1+hKLAMKhXPZRMuZsDbmL0/jrUXmWCFKQV
           EDhhXrSfDSDwtSbCTQrndUFWBTYjnddU2+hhzEvXp23+Rfsjc5b4QexyyoFIXmc31J
           y766Qhpezbw3Jnc3FstR87giVAC+wG2eH9EJGlYeUKndyaY5xd58vupzGuuUq4UqLW
           7GPkroGj3iEB+ZUkqTo0lWmnyqKd+rYkBcno/Kevtlmhyy+zL9IjBCsV5NrReVmTyx
           DNFjBNO5NZ2egN5RaZl3BTh04B0RLo7RxEsRYb9HTqGYob6HLpiEt5qPKdE6TsCKG5
           FfpzI5Dj77iIQ==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <hjf3108@gmail.com>; 31 Oct 2026 12:06:09 +0100
Date: Sat, 31 Oct 2026 12:06:08 +0100
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Jie Feng <hjf3108@gmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH wireless-next 6/8] wifi: rt2800: set the mac80211
 fast-xmit and aggregation flags
Message-ID: <20261031110608.GD31143@wp.pl>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
 <20261029134752.1299130-7-hjf3108@gmail.com>
 <20261030091743.GB27096@wp.pl>
 <CABOQOSX6mBCtTTg9eJX665t7tj65jo=9hVTgr7pmFRB6csG2Yg@mail.gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABOQOSX6mBCtTTg9eJX665t7tj65jo=9hVTgr7pmFRB6csG2Yg@mail.gmail.com>
X-WP-MailID: 8ae6e56a1c67c4863d898adb9f9c23ef
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [MbKR]                               

On Fri, Oct 30, 2026 at 07:33:44PM +0800, Jie Feng wrote:
> On Fri, 30 Oct 2026 at 17:17, Stanislaw Gruszka <stf_xl@wp.pl> wrote:
> >
> > On Thu, Oct 29, 2026 at 09:47:47PM +0800, Ho Jie Feng wrote:
> > > Enable AMSDU TX/RX support for this driver, which can increase
> > > throughput.
> > >
> > > Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
> > > ---
> > >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > index 032cd6ac345f0..8b4458a74d33d 100644
> > > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > @@ -11861,6 +11861,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
> > >       ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
> > >       ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
> > >       ieee80211_hw_set(rt2x00dev->hw, TX_STATUS_NO_AMPDU_LEN);
> > > +     ieee80211_hw_set(rt2x00dev->hw, SUPPORT_FAST_XMIT);
> >
> > IFICT this flag will not take the effect since we have SUPPORTS_PS.
> > Also for WAP3 (802.11w) we fallback to software encryption -
> > that will prevent fast xmit as well. To truly enable
> Yeah, that is true. I also have a patch that enables hwcrypto in that case.

So let's wait until all needed parts will be in tree or posted in the
same patchset before advertising the support.

> > fast xmit, I think we would need add hardware encryption support for
> > WPA3 and also compromise by remove Power Save support (which is disabled by
> > default, so that's possibly fine).
> I think maybe a more general patch to mac80211 to enable fast-xmit when PS
> is disabled and not only checking the feature flag will be better?

Sounds like good idea to me, but let check with Johannes (cc-ed).

> > > +     ieee80211_hw_set(rt2x00dev->hw, TX_AMSDU);
> > > +     ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_AMSDU_IN_AMPDU);
> Although I think this flag will still be useful for this patch.

AFICT TX_AMSDU require FAST_XMIT. I think we could potentially enable
RX SUPPORTS_AMSDU_IN_AMPDU as long all buffer sizes setup by the driver
and configured in registers allow handling big enough frames. Though
I don't know how much beneficial that would be since we most likely 
can not configure very large (A)MPDU buffers. Need to check.

Regards
Stanislaw

> > >
> > >       /*
> > >        * Don't set IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING for USB devices
> > > --
> > > 2.53.0
> > >
