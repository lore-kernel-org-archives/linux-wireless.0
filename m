Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:31460 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751740AbYBZGLm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 01:11:42 -0500
From: bruno randolf <bruno@thinktube.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: ath5k bf=xxx bf_skb=0 warnings
Date: Tue, 26 Feb 2008 15:11:25 +0900
Cc: linux-wireless@vger.kernel.org
References: <m3ve4cqtfy.fsf@maximus.localdomain>
In-Reply-To: <m3ve4cqtfy.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802261511.25472.bruno@thinktube.com> (sfid-20080226_061145_802636_334105E0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 February 2008 12:37:21 Krzysztof Halasa wrote:
> Hi,
>
> Just wondering if "bf=xxx bf_skb=0" warnings printed to console
> (ath5k/base.c:ath5k_beacon_send) are normal?
>
> Linux ixp425 2.6.25-rc3 (ARM big-endian), AR5413
>
> iwconfig wlan0 essid $ESSID mode ad-hoc channel $CH
> iwconfig wlan0 key restricted $KEY
> ifconfig wlan0 up
>
> I understand sc->bbuf->skb is never set, the only possible place is
> ath5k_beacon_update() but it's never called.

yes, that's normal and harmless. i haven't got around to make a smarter 
solution yet.

that's because we call ath5k_beacon_config() each time after a channel is set 
or the chip is reset, even if the beacon has not been configured yet.

we should fix that at some point.

bruno
