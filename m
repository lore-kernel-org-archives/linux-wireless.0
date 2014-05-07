Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:51878 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692AbaEGLpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 07:45:30 -0400
Received: by mail-we0-f177.google.com with SMTP id x48so869159wes.36
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2014 04:45:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1399461582.10517.18.camel@jlt4.sipsolutions.net>
References: <1399038031-23206-1-git-send-email-luca@coelho.fi>
	<1399373244.4218.21.camel@jlt4.sipsolutions.net>
	<CB3B3D4774441E42AA3EA0E1BA8230A0333F3C57@HASMSX106.ger.corp.intel.com>
	<1399444778.5038.3.camel@jlt4.sipsolutions.net>
	<CB3B3D4774441E42AA3EA0E1BA8230A0333F41ED@HASMSX106.ger.corp.intel.com>
	<1399461582.10517.18.camel@jlt4.sipsolutions.net>
Date: Wed, 7 May 2014 13:45:29 +0200
Message-ID: <CA+BoTQnb996u2wicuetXzzcdw8ci0t93zD0G1eA7kFSX_NB9-g@mail.gmail.com> (sfid-20140507_134533_161352_E3A1FCC1)
Subject: Re: [PATCH 1/4] cfg80211/nl80211: add channel switch started and
 failed notifications
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Peer, Ilan" <ilan.peer@intel.com>, Luca Coelho <luca@coelho.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 May 2014 13:19, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-05-07 at 10:27 +0000, Peer, Ilan wrote:
>
>> > In the first case, there's no notification, nor any need for it. In the second
>> > case, the scenario you suggest doesn't apply, and STOP_AP has to happen
>> > anyway because the state is completely messed up, clients will be in the
>> > process of switching etc.
>> >
>> > > Other than that, a STOP_AP might introduce some races, as
>> > > wpa_supplicant/hostap will not know if the stop_ap was due to the
>> > > failed CS or due to some other reason.
>> >
>> > I don't see why that would matter - even if the STOP_AP *was* for some
>> > other reason, but happened in the middle of the CS flow, the reaction would
>> > presumably be the same?
>> >
>>
>> It can be beneficial to know that the STOP_AP was called due to
>> failure of CS, as wpa_supplicant/hostap can tear down the AP and then
>> (if possible) set it up again on the new channel or another channel.
>
> Maybe that's more of an argument for adding a sort of "reason" or
> "cause" to the STOP_AP? (Btw, no tear down needed in this case - that's
> already done)
>
> OTOH, what else are you thinking of doing? Why would you ever, under any
> circumstances, not restart the AP if it was stopped by the device?

I can smell a recursive start-stop ping-pong if you restart unconditionally.


Michal
