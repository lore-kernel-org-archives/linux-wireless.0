Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:43958 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaIRFIW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 01:08:22 -0400
Received: by mail-la0-f54.google.com with SMTP id ge10so409996lab.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2014 22:08:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21530.23545.178915.653622@gargle.gargle.HOWL>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	<21529.8110.26388.664223@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
	<21529.9155.323515.987489@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
	<21529.10109.308613.563543@gargle.gargle.HOWL>
	<CANUX_P3hdFeCPmqHCdP8JKwqvUUnjgp3SNy1GQDrQd0bG+WKng@mail.gmail.com>
	<21530.19430.782437.984290@gargle.gargle.HOWL>
	<21530.23545.178915.653622@gargle.gargle.HOWL>
Date: Thu, 18 Sep 2014 08:08:20 +0300
Message-ID: <CANUX_P3o6=sdjHPp2L7tGAeXRW0v4xqSV-2q27Neetu75bDc1A@mail.gmail.com> (sfid-20140918_070827_097287_6EDDCDF6)
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Sep 18, 2014 at 7:13 AM, Sujith Manoharan <sujith@msujith.org> wrote:
> Sujith Manoharan wrote:
>> I don't think trying to switch channel contexts in the flush() callback
>> is a good idea. We would be changing the meaning of the callback if
>> we do that. Moreover flush() is called from many other places too, like the
>> PS code.
>>
>> It seems appropriate to instruct a driver to make the necessary
>> preparations before sending a deauth frame. Do you see any problems
>> if mgd_prepare_tx() is called before initiating deauth ?
>
> Calling mgd_prepare_tx() in ieee80211_send_deauth_disassoc(), which
> was the case originally, is probably more correct, since there are other
> situations where this will be a problem.
>
> CSA is one example. The driver can receive a beacon, mac80211 begins to
> process the CSA and if multiple contexts are active, initiates a disconnect
> operation. But, in the meantime, if the driver has switched to a different
> context, things will break.
>

I still think it does not match the original intent of mgd_prepare_tx().
The way I see it, mgd_prepare_tx() ensures that the Tx *will* happen
in cases the driver has no specific reason to be on channel, mainly
because the context is not associated yet. Note that after association
mac80211 does not interfere with the context switches. The driver is in
charge of all this - why would it be different in this case?
flush() makes sure that the Tx *has* happened before destroying things.
The context switches from association until destruction are under the driver's
responsibility.

At least this is the way I see it.
We (Intel) will not break if you add this call, but in my eyes this does not
comply with the design. I guess you can always send a patch to add it and
see what others will say, but Johannes is away right now.
If you choose to do that, please add a reason as a parameter to mgd_prepare_tx()
so that we can ignore it when it is called before sending a frame that
is flush()'ed.
I still prefer to rely on flush(). And I agree that flush() isn't a
trivial implementation.

Note that the only reason I implemented flush() is because of 11w that forces us
to make sure that the deauth is sent, otherwise you'd be kicked by the AP after
3 cycles of association / disassociation.
So not sending the deauth from time to time isn't really a big deal in
my eyes, but
one can argue about that (just like about pretty much everything) :)
