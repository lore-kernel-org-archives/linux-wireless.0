Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41407 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0I2HYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 03:24:49 -0400
Received: by iwn5 with SMTP id 5so675283iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 00:24:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100929052006.GC18450@vasanth-laptop>
References: <20100928222945.GB10932@tux> <20100928230211.GA9844@jm.kir.nu>
 <AANLkTimGPPUW6=QYpZz7q96vt1GOd5kJ-tvYEKxZZT2B@mail.gmail.com> <20100929052006.GC18450@vasanth-laptop>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 29 Sep 2010 00:24:27 -0700
Message-ID: <AANLkTinKkTgUUGPxY82G1B6taToKeAMOmrJ+tYvzLY52@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 28, 2010 at 10:20 PM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Wed, Sep 29, 2010 at 05:28:35AM +0530, Luis R. Rodriguez wrote:
>> On Tue, Sep 28, 2010 at 4:02 PM, Jouni Malinen <j@w1.fi> wrote:
>> > On Tue, Sep 28, 2010 at 03:29:45PM -0700, Luis R. Rodriguez wrote:
>> >
>> >> Added support for cfg80211/mac80211 to cleanly roam between two BSSes
>> >> on an ESS by allowing the station to reassociate to an old AP and
>> >> only when that is done drop the old association. What we forgot to
>> >> take into consideration is that when we disassociate with the older
>> >> AP we may need to transmit frames to that AP and those frames may
>> >> actually be intended to go under a different channel and even sometimes
>> >> a completely separate band than the new APs.
>> >
>> > which frames are you talking about here?
>>
>> ieee80211_send_delba()
>>
>> > When reassociating to a new BSS
>> > in an ESS, there should be no need to transmit frames to the old AP
>> > anymore, i.e., we are never associated with more than one BSS (when
>> > talking about a single vif). We could just drop any potential TX frame
>> > to the old AP after the moment the new AP is marked associated.
>>
>> That's the goal of this patch.
>
> From my debugging, this happens when cleaning up BA session for old
> AP but on a different channel

Right.

> (where we just authenticated with another AP)

Not sure I get this part.

> just before starting association with the new AP.

Right, but when we are already switched to the new channel, and the
reason is that when we try to send a frame we never kept track of the
peer's original channel. Now, I also see the teardown happen right
before mac80211 tells us its associated to the new AP as well but it
not sure what cfg80211 thinks at that point. At least the cfg80211
patch's intention seemed to be to allow association to both, and
tearing down the association to the other once you completed
association to the other. I do see, what you describe though too --
only authentication to the new AP, and right before association, we
send the teardown. The problem is though that when we send the
teardown we are already set on the new channel.

> Though local->work_work takes care of moving to right channel,

When we TX a frame we use  local->hw.conf.channel which would be the
new AP's channel, this is wrong, but we never kept track of the peer's
original channel so there no way to know the original channel.

> it is possible that cfg80211 receives NL80211_CMD_ASSOCIATE before
> local->work_work configures the hw back to old AP's channel (that
> is what happening in our case).

And how would mac80211 or cfg80211 know what channel that was?

  Luis
