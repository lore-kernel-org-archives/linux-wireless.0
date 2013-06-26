Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54485 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab3FZVp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 17:45:56 -0400
Received: by mail-ie0-f180.google.com with SMTP id f4so31990125iea.39
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 14:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51CB3E04.3000402@rempel-privat.de>
References: <51C52E79.30104@rempel-privat.de> <CAG6hwVOCfDK9nkh3e0fFMGcWp8XLQnPC8TzQb9eET2fwFPq3SA@mail.gmail.com>
 <51C93538.4050304@rempel-privat.de> <CAG6hwVMa+i=wXRyfcwaXH8NesCXgKXW6Ad4dzgd9DZONGYA=xQ@mail.gmail.com>
 <1372231882.8157.0.camel@jlt4.sipsolutions.net> <CAG6hwVNk-sA_RFYJN+MzSURwWZYd-X3Uu8g2sRP8AfyKWQUQbw@mail.gmail.com>
 <51CB3E04.3000402@rempel-privat.de>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 26 Jun 2013 14:45:36 -0700
Message-ID: <CAG6hwVOzi9OnD+Rt6bbjZpYF8ACHAEoHkHmwax_y0PakrbY97g@mail.gmail.com> (sfid-20130626_234559_856875_5D1D4836)
Subject: Re: regression after, " ath9k_htc: Add support for mesh interfaces"
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 26, 2013 at 12:16 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
> Am 26.06.2013 20:52, schrieb Thomas Pedersen:
> I just discovered one more issue with mesh on ath9k* devices.
> if i try to do "ifconfig mesh0 down" this task will freeze and after some
> time kernel will oops.
>
> Steps to reproduce:
> iw dev wlan2 interface add mesh0 type mp mesh_id mesh
> iwconfig mesh0 channel 1
> ifconfig mesh0 10.0.0.1 netmask 255.255.255.0 up
> sleep 30
> ifconfig mesh0 down

are you running wireless-testing master HEAD? There is a fix for that
deadlock in mac80211-next ("mac80211: update mesh beacon on
workqueue") still waiting to get into wireless-testing.

--
Thomas
