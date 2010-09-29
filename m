Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48480 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab0I2RQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 13:16:51 -0400
Received: by iwn5 with SMTP id 5so1262195iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 10:16:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100929085657.GD18450@vasanth-laptop>
References: <20100928222945.GB10932@tux> <20100928230211.GA9844@jm.kir.nu>
 <AANLkTimGPPUW6=QYpZz7q96vt1GOd5kJ-tvYEKxZZT2B@mail.gmail.com>
 <20100929052006.GC18450@vasanth-laptop> <AANLkTinKkTgUUGPxY82G1B6taToKeAMOmrJ+tYvzLY52@mail.gmail.com>
 <20100929085657.GD18450@vasanth-laptop>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 29 Sep 2010 10:16:30 -0700
Message-ID: <AANLkTikUAchrjeMraauLaUggtq7bYZoki=kz2o8XQ2yh@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 29, 2010 at 1:56 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Wed, Sep 29, 2010 at 12:54:27PM +0530, Luis R. Rodriguez wrote:
>> > (where we just authenticated with another AP)
>>
>> Not sure I get this part.
>
> I mean we are trying to tx frames on the channel where we got
> newly authenticated to another AP.

Ah yes, agred.

>> > just before starting association with the new AP.
>>
>> Right, but when we are already switched to the new channel, and the
>> reason is that when we try to send a frame we never kept track of the
>> peer's original channel. Now, I also see the teardown happen right
>> before mac80211 tells us its associated to the new AP as well but it
>> not sure what cfg80211 thinks at that point. At least the cfg80211
>> patch's intention seemed to be to allow association to both, and
>> tearing down the association to the other once you completed
>> association to the other. I do see, what you describe though too --
>> only authentication to the new AP, and right before association, we
>> send the teardown. The problem is though that when we send the
>> teardown we are already set on the new channel.
>
> Ok. From my understanding, the sequence of operations during roaming
> are
>
> 1. NL80211_CMD_AUTHENTICATE to an (better) AP from user space
>        - Change to New Ap's channel and send auth req (done by
>          ieee80211_work_work()).
>        - Notify auth resp to userspace (ieee80211_probe_auth_done())
> 2. NL80211_CMD_ASSOCIATE to newly authenticated AP from user space
>
>        - Clean up any existing BA session with an AP, if any.
>        Here the assumption is, ieee80211_work_work() has already
>        configured the device back to it's operating channel (the
>        old one) after the authentication is complete with the new
>        AP. This should have happened part of 1.
>        - Start the association process with the new AP.

No see, I believe we actually get the association response and *then*
we teardown the BA agreements. Let me review this some more today.

  Luis
