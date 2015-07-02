Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33696 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbGBK2j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 06:28:39 -0400
Received: by wiwl6 with SMTP id l6so192139627wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jul 2015 03:28:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1435826335.2285.6.camel@sipsolutions.net>
References: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
	<1435826335.2285.6.camel@sipsolutions.net>
Date: Thu, 2 Jul 2015 12:28:38 +0200
Message-ID: <CA+BoTQk1YT-CD2sA3Ev9v7+H2hV=OszawLFg9e4FehFoaPkV7A@mail.gmail.com> (sfid-20150702_122844_436901_45CA62A9)
Subject: Re: Association race when acting as AP?
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 July 2015 at 10:38, Johannes Berg <johannes@sipsolutions.net> wrote:
> [please try to send w/o html if you're CC'ing the linux-wireless list]

Ah, sorry. I suspect the "plain text mode" in gmail/www got disabled
for some reason for that e-mail..


>> To me this looks like a race in hostapd. The station should be
>> installed to driver _before_ sending Assoc Resp frame, not after. My
>> quick-n-dirty hack seems to help:
>>
> [...]
>> Is anyone aware of this problem already? Anyone working on it? Any
>> gotchas I should be aware of before I go into fixing this in a proper
>> way? Or am I missing something and this isn't actually a problem?
>
> The TI folks had a similar patch that broke open networks, not sure
> what was wrong there.
>
> Ultimately, depending on the nl80211 capabilities, the station should
> in fact be added (as unauthenticated) before even sending the
> authentication response frame, and then stepping through the stages
> appropriately.

While I think it does make sense (I thought of this too, sounds
desirable) I think it wouldn't solve the race problem entirely. The
station might no longer be rejected with Deauth but may end up
confusing AP's internal/offloaded STA powersave state depending on
implementation detail (what do you do when you receive NullFunc from a
station that you don't know assoc id of or isn't fully initialized as
associated?). I.e. station should be transitioned to Assoc state
before sending the Assoc Resp frame.


> It should also react to errors by sending a negative association
> response I guess.

Good point.


Michał
