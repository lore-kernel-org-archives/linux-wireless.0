Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60505 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934801Ab1JEW1Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:27:24 -0400
Received: by qyk30 with SMTP id 30so4880696qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 15:27:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201110041538.12885.chunkeey@googlemail.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110032124.53937.chunkeey@googlemail.com> <CAB=NE6XBkisvFmj6F7wS6i8XV7WEsM6bQ5zsXFWXm9XM8z0pwA@mail.gmail.com>
 <201110041538.12885.chunkeey@googlemail.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 5 Oct 2011 15:27:03 -0700
Message-ID: <CAB=NE6VC3txpDh4SdDKDxKWKKZVtGQXKVH8opszKDnZeeZTjUQ@mail.gmail.com> (sfid-20111006_002728_329083_BE17E580)
Subject: Re: [ath9k-devel] [RFC 5/6] ath9k: enable DFS pulse detection
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: kgiori@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org,
	Zefir Kurtisi <zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 6:38 AM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Monday, October 03, 2011 09:31:12 PM Luis R. Rodriguez wrote:
>> On Mon, Oct 3, 2011 at 12:24 PM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > On Monday, October 03, 2011 08:27:39 PM Luis R. Rodriguez wrote:
>> >> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> >> >
>> >> > Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>> >> > ---
>> >> >  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
>> >> >  1 files changed, 12 insertions(+), 0 deletions(-)
>> >> >
>> >> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> >> > index e8aeb98..5defebe 100644
>> >> > --- a/drivers/net/wireless/ath/ath9k/main.c
>> >> > +++ b/drivers/net/wireless/ath/ath9k/main.c
>> >> > @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>> >> >                        "Unable to reset channel, reset status %d\n", r);
>> >> >                goto out;
>> >> >        }
>> >> > +#ifdef CONFIG_ATH9K_DFS
>> >>
>> >> Please spare the #ifdef and just call something within dfs.c, then
>> >> dfs.h would wrap it to nothing if DFS is disabled.
>> > Why would anyone want to disable DFS driver support?
>> > I would say: drop the ifdefs altogether since DFS
>> > is and will be "required".
>>
>> Because DFS requires to be properly tested before being enabled.
> Testing if a driver detects a pulse is "trivial" compared to the
> stuff mac80211/cfg80211 and hostapd will have to do to make a
> channel-change as smooth as possible. I think if there's a DFS
> "OFF" switch, it should be in hostapd and I hope more people
> agree on this one.

You do have a good point, but I disagree that you do not need to test
/ regress test hardware / driver code for DFS. This is what I'm
talking about. But yes, userspace also submits itself to the same
criteria.

>> You may also want to simply disable DFS if you do not want to
>> deal with the regulatory test implications of having it enabled.
> AFAIK you can't "simply" disable the DFS requirement: hostapd
> (hw_features.c), [cfg80211] (checks if tx on secondary channel
> is possible) and mac80211 (tx.c) all have checks. Indeed, the
> easiest way is to modify crda's database. So there's no need
> for an extra compile-time option.

No, DFS is set for certain channels on wireless-regdb/CRDA, I just
posted DFS master region support for wireless-regdb and CRDA. Apart
from this we then need driver support. To get DFS you need all of
these + hostapd part. Each one has its own set of components and does
deserve its own set of tests and review.

  Luis
