Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:39303 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3GIOLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 10:11:21 -0400
Received: by mail-bk0-f43.google.com with SMTP id jm2so2372693bkc.2
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jul 2013 07:11:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130709102751.GA21674@pandem0nium>
References: <1373289250-12259-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	<1373289250-12259-5-git-send-email-siwu@hrz.tu-chemnitz.de>
	<CA+BoTQnsDGtAp4n9hYQTjhNZFzsEsaT4qnX_W7hBcutTAZvjYw@mail.gmail.com>
	<20130709102751.GA21674@pandem0nium>
Date: Tue, 9 Jul 2013 16:11:19 +0200
Message-ID: <CA+BoTQnbkb6TuPBQM84sy5mgy8ittFa0mSkBCK1Pa-OxopZFiw@mail.gmail.com> (sfid-20130709_161124_410648_C58AF679)
Subject: Re: [PATCHv3 4/5] mac80211: add channel switch command and beacon callbacks
From: Michal Kazior <michal.kazior@tieto.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 July 2013 12:27, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> On Tue, Jul 09, 2013 at 09:17:41AM +0200, Michal Kazior wrote:
>> I'm wondering if it's a huge hassle to support drivers that depend on
>> channel context API? Perhaps local->open_count could be used instead
>> of local->use_chantx and chanctx->refcount?
>
> Actually I'm not using any chanctx drivers, and as long as I can't test
> I prefer to keep things disabled. :)

Understandable :) I'm not able to test it now either.

Hmm.. Just as an idea: mac80211_hwsim uses chanctx so it could be
modified to support CSA to test this case.


> local->open_count seems doable though,
> it should be the same if there is only one channel context. I can change
> that ... If you think it is safe I can enable support, nothing will happen
> anyway as long as the driver don't set the "CSA supported" wiphy flag ...

I looked at the code and I think local->open_count won't cut it. It
will fail with AP_VLAN interfaces present (and this isn't a problem
with your current approach). Monitor interfaces are counted in
local->monitors, but AP_VLAN aren't counted at all. mac80211 doesn't
really keep track of the number of interfaces it has reported to a
driver nor the number of software interfaces (that aren't reported to
the driver) unless I missed something.

Another idea is to verify there's exactly 1 chanctx present and it's
refcount is also 1.

CSA + chanctx is just a nice to have. If you're short on resources
it's fine the way it is I think.


>> It seems there's nothing preventing from multiple calls to channel
>> switch callback. Is this expected? Can this work if CSA is invoked
>> while other CSA is still in progress?
>
> This should not happen as long as there is only one interface
> doing a channel switch. If this is properly checked (need to fix
> the point you mentioned above) that should be safe, I think?

Yes it's okay as long as userspace doesn't do something stupid (i.e.
call channel switch more than once quickly). Whether this is a concern
is not for me to decide though.


Pozdrawiam / Best regards,
Michał Kazior.
