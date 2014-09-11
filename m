Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:36092 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaIKLi2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 07:38:28 -0400
Received: by mail-wi0-f174.google.com with SMTP id n3so751877wiv.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2014 04:38:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1410432565.23822.11.camel@dubbel>
References: <1410418181.14130.7.camel@dubbel>
	<CA+BoTQ=dqQz1epo=-odvVQjOx0K-yLNtivufE5BKBK9+QV2wGQ@mail.gmail.com>
	<1410432565.23822.11.camel@dubbel>
Date: Thu, 11 Sep 2014 13:38:26 +0200
Message-ID: <CA+BoTQkLmX=u9AxcTpyo4pgE=2TEKo+E4qeJc4-PpODk76xJuw@mail.gmail.com> (sfid-20140911_133831_498929_243447A9)
Subject: Re: CSA broken with !use_chanctx drivers?
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 September 2014 12:49, Luca Coelho <luca@coelho.fi> wrote:
> On Thu, 2014-09-11 at 11:28 +0200, Michal Kazior wrote:
>> On 11 September 2014 08:49, Luca Coelho <luca@coelho.fi> wrote:
[...]
>> > It seems that we're not updating the chandef in non-chanctx drivers.  Or
>> > are we missing something?
[...]
>> From what I've tested just now it seems iwldvm (3.17-rc2, fw
>> 18.168.6.1) calls ieee80211_chswitch_done() almost immediately most of
>> the time. This obviously ends up with beacon loss with larger CS
>> count. With small CS count it works though. This doesn't seem to be
>> related to the missing hw_confg().
>
> The hw_config() call is not really missing, right? We're actually now
> calling it even for drivers that implement drv_channel_switch()
> (previously we wouldn't).

I've had a brain fart.. You're right. I meant "This doesn't seem to be
related to the fact we call hw_config() now".


> I don't know why iwldvm is finalizing the channel switch almost
> immediately... It doesn't make much sense, because all the traffic until
> the switch will be lost.  Unless the CSA is marked as "quiet", because
> then nobody should be transmitting and it doesn't really matter when you
> switched.

It wasn't quiet. Just a simple "hostapd_cli chan_switch 50 5200".
Maybe it doesn't like ath10k being the AP? Or maybe there's something
wrong with tsf/timestamp on either side?


> Anyway, I don't think the problem is that we call hw_config() now,
> because that is done *after* chswitch_done() is called.

Yep. If the CS is small or the chswitch_done() is called in a timely
fashion iwldvm doesn't seem to be bothered by the extra hw_config()
call.


>> Now that I think it's probably a good idea to make multi-vif CSA
>> mutually exlusive with drv_channel_switch() based STA CSA..
>
> In the iwlmvm driver, we have to do the actual context switch when we
> decide to, not exactly at TBTT count=0 as mac80211 does with "software
> channel switch".  The way I solved this (will be upstreamed soon, I
> believe) is that I implement a dummy drv_channel_switch().  I only do
> this to prevent mac80211 from starting its own timer, allowing me to
> call ieee80211_chswitch_done() when I need to.

Oh.. ok.


Michał
