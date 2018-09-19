Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48442 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbeISQnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 12:43:07 -0400
Date: Wed, 19 Sep 2018 13:05:41 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
Message-ID: <20180919110540.GC22689@redhat.com> (sfid-20180919_130547_123431_F6403406)
References: <20180918122015.GB15481@redhat.com>
 <1537280073-9873-1-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1537280073-9873-1-git-send-email-pozega.tomislav@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 18, 2018 at 04:14:33PM +0200, Tomislav Požega wrote:
> On Tue, 18 Sep 2018 14:20:16 +0200, Stanislaw Gruszka wrote:
> 
> >On Mon, Sep 17, 2018 at 06:32:51PM +0200, Tomislav Požega wrote:
> >> Use curr_band instead of rf->channel among various subroutines -
> >> mostly for 2.4GHz band but in some circumstances for 5GHz band too.
> >
> >What is the reason for that change ?
> 
> Operating band should be fetched from device capabilities, not from userspace
> variables. More changes will needed to be made to accomplish that.

Driver should provide on what channels are supported to mac80211, but
user space decide what channel to use and that imply band 2.4GHz or
5GHz. ->curr_band is just shortcut for band of current channel. Is set 
in rt2x00lib_config() after we call rt2x00dev->ops->lib->config()
[rt2800_config() for rt2800] . So patch is wrong. Either ->curr_band 
should be set before ->config call or we need to consistently use
rf->channel <= 14 for band check in any rt2800_config() function and
all it's subroutines. I prefer the second solution (i.e. rf->channel)
and now I can see few places when we use ->curr_band, what is a bug.

> >> -	if (spec->num_channels > 14) {
> >> +	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
> >>  		default_power1 = rt2800_eeprom_addr(rt2x00dev,
> >>  						    EEPROM_TXPOWER_A1);
> >>  		default_power2 = rt2800_eeprom_addr(rt2x00dev,
> >
> >Above looks wrong.
> >
> >Thanks
> >Stanislaw
> 
> Worked fine when I tried run two USB cards (RT3070-RF0005, RT5390-RF5370).
> Why do you think it's wrong? Is there a dual-band card that operates on
> both bands at the same time?

It's because ->curr_band initialize to 0 and NL80211_BAND_2GHZ
happen to be 0. Also problem will not trigger on single band
2.4GHz devices.

Regards
Stanislaw
