Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36997 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252Ab1JDNiT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 09:38:19 -0400
Received: by wyg34 with SMTP id 34so528584wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 06:38:18 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
Date: Tue, 4 Oct 2011 15:38:12 +0200
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110032124.53937.chunkeey@googlemail.com> <CAB=NE6XBkisvFmj6F7wS6i8XV7WEsM6bQ5zsXFWXm9XM8z0pwA@mail.gmail.com>
In-Reply-To: <CAB=NE6XBkisvFmj6F7wS6i8XV7WEsM6bQ5zsXFWXm9XM8z0pwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201110041538.12885.chunkeey@googlemail.com> (sfid-20111004_153823_158054_75A1F450)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, October 03, 2011 09:31:12 PM Luis R. Rodriguez wrote:
> On Mon, Oct 3, 2011 at 12:24 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > On Monday, October 03, 2011 08:27:39 PM Luis R. Rodriguez wrote:
> >> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> >> >
> >> > Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> >> > ---
> >> >  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
> >> >  1 files changed, 12 insertions(+), 0 deletions(-)
> >> >
> >> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> >> > index e8aeb98..5defebe 100644
> >> > --- a/drivers/net/wireless/ath/ath9k/main.c
> >> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> >> > @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
> >> >                        "Unable to reset channel, reset status %d\n", r);
> >> >                goto out;
> >> >        }
> >> > +#ifdef CONFIG_ATH9K_DFS
> >>
> >> Please spare the #ifdef and just call something within dfs.c, then
> >> dfs.h would wrap it to nothing if DFS is disabled.
> > Why would anyone want to disable DFS driver support?
> > I would say: drop the ifdefs altogether since DFS
> > is and will be "required".
> 
> Because DFS requires to be properly tested before being enabled.
Testing if a driver detects a pulse is "trivial" compared to the
stuff mac80211/cfg80211 and hostapd will have to do to make a
channel-change as smooth as possible. I think if there's a DFS
"OFF" switch, it should be in hostapd and I hope more people
agree on this one.  

> You may also want to simply disable DFS if you do not want to
> deal with the regulatory test implications of having it enabled.
AFAIK you can't "simply" disable the DFS requirement: hostapd
(hw_features.c), [cfg80211] (checks if tx on secondary channel
is possible) and mac80211 (tx.c) all have checks. Indeed, the
easiest way is to modify crda's database. So there's no need
for an extra compile-time option.

Regards,
	Chr
