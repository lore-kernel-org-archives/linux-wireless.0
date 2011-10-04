Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34356 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab1JDOnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 10:43:08 -0400
Received: by wwf22 with SMTP id 22so916353wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 07:43:07 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
Date: Tue, 4 Oct 2011 16:42:54 +0200
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110041538.12885.chunkeey@googlemail.com> <4E8B157F.2080203@neratec.com>
In-Reply-To: <4E8B157F.2080203@neratec.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201110041642.54453.chunkeey@googlemail.com> (sfid-20111004_164312_742141_971C5071)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 04, 2011 04:17:35 PM Zefir Kurtisi wrote:
> On 10/04/2011 03:38 PM, Christian Lamparter wrote:
> > On Monday, October 03, 2011 09:31:12 PM Luis R. Rodriguez wrote:
> >> On Mon, Oct 3, 2011 at 12:24 PM, Christian Lamparter
> >> <chunkeey@googlemail.com> wrote:
> >>> On Monday, October 03, 2011 08:27:39 PM Luis R. Rodriguez wrote:
> >>>> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> >>>>>
> >>>>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
> >>>>> ---
> >>>>>  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
> >>>>>  1 files changed, 12 insertions(+), 0 deletions(-)
> >>>>>
> >>>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> >>>>> index e8aeb98..5defebe 100644
> >>>>> --- a/drivers/net/wireless/ath/ath9k/main.c
> >>>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
> >>>>> @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
> >>>>>                        "Unable to reset channel, reset status %d\n", r);
> >>>>>                goto out;
> >>>>>        }
> >>>>> +#ifdef CONFIG_ATH9K_DFS
> >>>>
> >>>> Please spare the #ifdef and just call something within dfs.c, then
> >>>> dfs.h would wrap it to nothing if DFS is disabled.
> >>> Why would anyone want to disable DFS driver support?
> >>> I would say: drop the ifdefs altogether since DFS
> >>> is and will be "required".
> >>
> >> Because DFS requires to be properly tested before being enabled.
> > Testing if a driver detects a pulse is "trivial" compared to the
> > stuff mac80211/cfg80211 and hostapd will have to do to make a
> > channel-change as smooth as possible. I think if there's a DFS
> > "OFF" switch, it should be in hostapd and I hope more people
> > agree on this one.  
> > 
> Yes on both. Work on the management part of the DFS module has just
> been started by TI guys. When this is in, hostapd will be able to
> query the driver's DFS detection capabilities and leave DFS channels
> disabled for those devices with no (or insufficient) support
> (like it is generally done today for DFS channels).
> 
> The proper way for a driver's OFF switch would then be to just
> announce missing DFS capabilities.
Actually, I think we already have a flag for such a
purpose:
 * @IEEE80211_HW_SPECTRUM_MGMT:
 *      Hardware supports spectrum management defined in 802.11h
AFAIK 802.11h[now integrated in 802.11-2007] included DFS, right? 

> >> You may also want to simply disable DFS if you do not want to
> >> deal with the regulatory test implications of having it enabled.
> > AFAIK you can't "simply" disable the DFS requirement: hostapd
> > (hw_features.c), [cfg80211] (checks if tx on secondary channel
> > is possible) and mac80211 (tx.c) all have checks. Indeed, the
> > easiest way is to modify crda's database. So there's no need
> > for an extra compile-time option.
> > 
> There might be a demand for conditional compiling in addition to
> DFS capabilities announcements to reduce memory footprint, since
> (especially) pattern matching algorithms will increase it significantly.
I don't think memory footprint is such a big problem. After all ath9k
has around 170 kb [please correct me if I'm wrong here] of initvals
for all supported solutions since AR5008.

Regards,
	Chr
