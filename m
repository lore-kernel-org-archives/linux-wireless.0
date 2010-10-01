Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58117 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0JAUHf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 16:07:35 -0400
Received: by iwn5 with SMTP id 5so4214885iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 13:07:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikX82sSH3eJ_dSxb0v4MHw74ns8Ak0NREH0g1Vq@mail.gmail.com>
References: <20100928222945.GB10932@tux> <1285748303.3756.19.camel@jlt3.sipsolutions.net>
 <AANLkTi=qGb+aEz48kNKUvuhgA2RAr0pbQoENYV_DazWT@mail.gmail.com>
 <1285781138.3756.29.camel@jlt3.sipsolutions.net> <AANLkTikX82sSH3eJ_dSxb0v4MHw74ns8Ak0NREH0g1Vq@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 1 Oct 2010 13:07:14 -0700
Message-ID: <AANLkTikLkPgwpB9Tm829VHMKYu2u7VqarX+8Mj7tw-6-@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, stable@kernel.org,
	linux-wireless@vger.kernel.org, Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 30, 2010 at 10:53 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Wed, Sep 29, 2010 at 10:25 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Wed, 2010-09-29 at 10:10 -0700, Luis R. Rodriguez wrote:
>>
>>> > I really think that can be done more easily though. For one, clearly we
>>> > already have the warning, so we don't need more infrastructure to catch
>>> > such errors?!
>>>
>>> This is true, I just added that to ensure I hit these when testing
>>> really, I can nuke the counter, but it can help if eventually believe
>>> we have a proper fix to allow these frames through somehow too.
>>>
>>> > Also, this may end up hiding issues that we don't yet
>>> > understand, like the nullfunc one you were talking about.
>>>
>>> Yeah, good point, although I am under the impression this is a similar
>>> situation, we probably try to send a nullfunc to notify the old AP we
>>> are going to go awake if we are transmitting data while roaming. But
>>> yeah, its not easily triggerable yet.
>>>
>>> > The delBA one
>>> > we now understand fully, so it makes more sense to simply suppress
>>> > sending delBA when we are going to disassociate by way of associating
>>> > with a new AP, no?
>>>
>>> That's reasonable but we will still need the channel, otherwise how
>>> would we know its this issue?
>>
>> Why do we care? We can just always suppress sending the delba when we
>> get into _set_disassoc() from mgd_assoc(), no?
>
> Yeah, and I actually think I found another race with this code, I'm
> going to try something a bit different now.

OK yay, took a while but I think I found a better and proper fix for
this. Will post next.

  Luis
