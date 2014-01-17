Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46833 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaAQOAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 09:00:09 -0500
Received: by mail-pb0-f46.google.com with SMTP id ma3so4117798pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 06:00:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAb+SYacFzn_ybhtVbH6upNbvL8L3xf299TPeJnExcmiqLk5Sw@mail.gmail.com>
References: <a8aa052ea196de8256dcdc5b3ae81cfa64d3f9ff.1389935084.git.gamerh2o@gmail.com>
	<1389939896.8062.53.camel@porter.coelho.fi>
	<CACna6rzkKGxBxReQJ0Y=TscY8GJ+r=S+6Cs+g+B0=7k1FFxW2w@mail.gmail.com>
	<CAOiHx=nui0nVGiCLoukRovB3zY5jiKAt__Numo4y4bQv0dzOcQ@mail.gmail.com>
	<1389949304.8062.55.camel@porter.coelho.fi>
	<CAAb+SYYyQF54Cib3Wae18orzH31RJ-vYoTEOBidMEPwVYYRv=g@mail.gmail.com>
	<CACna6rzTF8Wpj+Bn40iwEsZ9Ca+gE1ydYz1cgonb4u1rQPGQgw@mail.gmail.com>
	<1389952418.8062.57.camel@porter.coelho.fi>
	<CAAb+SYacFzn_ybhtVbH6upNbvL8L3xf299TPeJnExcmiqLk5Sw@mail.gmail.com>
Date: Fri, 17 Jan 2014 22:00:07 +0800
Message-ID: <CAAb+SYayF=9TrrVQz34FRfvFCFF4-OUW05LBbVwYCs-sXcB4Vg@mail.gmail.com> (sfid-20140117_150018_606959_1CFF7CEE)
Subject: Re: [PATCH 1/2] b43: fix the wrong assignment of status.freq in b43_rx()
From: ZHAO Gang <gamerh2o@gmail.com>
To: Luca Coelho <luca@coelho.fi>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Jonas Gorski <jogo@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 17, 2014 at 8:56 PM, ZHAO Gang <gamerh2o@gmail.com> wrote:
> On Fri, Jan 17, 2014 at 5:53 PM, Luca Coelho <luca@coelho.fi> wrote:
>> On Fri, 2014-01-17 at 10:37 +0100, Rafał Miłecki wrote:
>>> 2014/1/17 ZHAO Gang <gamerh2o@gmail.com>:
>>> > On Fri, Jan 17, 2014 at 5:01 PM, Luca Coelho <luca@coelho.fi> wrote:
>>> >> On Fri, 2014-01-17 at 09:56 +0100, Jonas Gorski wrote:
>>> >>> On Fri, Jan 17, 2014 at 8:11 AM, Rafał Miłecki <zajec5@gmail.com> wrote:
>>> >>> > 2014/1/17 Luca Coelho <luca@coelho.fi>:
>>> >>> >> On Fri, 2014-01-17 at 13:27 +0800, ZHAO Gang wrote:
>>> >>> >>> In following patch, replace b43 specific helper function with kernel
>>> >>> >>> api to reduce code duplication.
>>> >>> >>>
>>> >>> >>> Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
>>> >>> >>> ---
>>> >>> >>>  drivers/net/wireless/b43/xmit.c | 4 ++--
>>> >>> >>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>> >>> >>>
>>> >>> >>> diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
>>> >>> >>> index 4ae63f4..50e5ddb 100644
>>> >>> >>> --- a/drivers/net/wireless/b43/xmit.c
>>> >>> >>> +++ b/drivers/net/wireless/b43/xmit.c
>>> >>> >>> @@ -821,10 +821,10 @@ void b43_rx(struct b43_wldev *dev, struct sk_buff *skb, const void *_rxhdr)
>>> >>> >>>                * channel number in b43. */
>>> >>> >>>               if (chanstat & B43_RX_CHAN_5GHZ) {
>>> >>> >>>                       status.band = IEEE80211_BAND_5GHZ;
>>> >>> >>> -                     status.freq = b43_freq_to_channel_5ghz(chanid);
>>> >>> >>> +                     status.freq = b43_channel_to_freq_5ghz(chanid);
>>> >>> >>>               } else {
>>> >>> >>>                       status.band = IEEE80211_BAND_2GHZ;
>>> >>> >>> -                     status.freq = b43_freq_to_channel_2ghz(chanid);
>>> >>> >>> +                     status.freq = b43_channel_to_freq_2ghz(chanid);
>>> >>> >>>               }
>>> >>> >>>               break;
>>> >>> >>>       default:
>>> >>> >>
>>> >>> >> Why do you need this patch if you're going to remove these calls in the
>>> >>> >> next patch anyway?
>>> >>> >
>>> >>> > I was thinking about this for a moment too. You could just make a one
>>> >>> > patch and note in commit message that "translation" was reversed.
>>> >>>
>>> >>> That would mean mixing fixes and improvements, which is something you
>>> >>> are not supposed to do, so IMHO having these split into two is
>>> >>> correct. Think about stable maintainers wanting the fix but not the
>>> >>> other change because it might introduce unknown side effects.
>>> >>
>>> >> Makes sense.  In such case, the first patch should be clearly marked as
>>> >> a bug fix, so at least the commit message should be changed (ie.
>>> >> mentioning the next patch in the series is useless).
>>> >>
>>> >
>>> > I am OK to send this fix either in one patch or two, actually I have
>>> > sent a version 2 which is a one patch version :-)
>>> >
>>> > I'm not sure if this patch is needed for stable, yes, as you said, if
>>> > it's for stable, the commit message should be changed.
>>>
>>> Thanks for your help guys.
>>>
>>> I think it may be the best idea to send
>>> 1/2 as fix (probably 3.14) + stable CC
>>> 2/2 as improvement (for next)
>>> Does it make sense?
>>
>> Sounds good to me.  The actual fix is so simple and obvious that I don't
>> see any reason for not sending it as a fix + stable.
>>
>
> Hi, after reading the code, it seems that status.freq is not actually used
> in rx path, so this fix has no user sensible changes. So I think it is
> not needed
> to send this patch to stable.
>

Oh yes, at least it's used in ieee80211_rx -> __ieee80211_rx_handle_packet ->
ieee80211_scan_rx -> ieee80211_get_channel(local->hw.wiphy, rx_status->freq)

Now I think it should be sent to stable. I think I should resend the two patches
to update the commit message.

> Anyway, I should mention that the version 2 patch should be ignored.
>
>> --
>> Luca.
>>
