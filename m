Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50158 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757892Ab3CTJpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 05:45:52 -0400
Received: by mail-wg0-f42.google.com with SMTP id 12so144425wgh.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 02:45:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363725845.8336.33.camel@jlt4.sipsolutions.net>
References: <1363691302-11947-1-git-send-email-mcgrof@do-not-panic.com> <1363725845.8336.33.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 20 Mar 2013 02:45:31 -0700
Message-ID: <CAB=NE6XgEjWG6j+J+1ycf+HkhDM_6dRn+dvzC81HPvq+MLRq1Q@mail.gmail.com> (sfid-20130320_104555_879282_05C01531)
Subject: Re: [RFC] mac80211: avoid rearming BA session timers unnecessarily
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 19, 2013 at 1:44 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2013-03-19 at 04:08 -0700, Luis R. Rodriguez wrote:
>> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>>
>> If mac80211 tears down the BA sessions with del_timer_sync()
>> technically mod_timer() can still rearm them. If mac80211
>> tears the BA sessions down we don't want to rearm the timers
>> at a later time so avoid this possibility.
>
> Hmm, you may be onto something, but I'm not sure I want to apply this.
> You don't seem to actually understand what you're doing -- two of the
> three changes you're making don't really seem to be needed and the third
> one should probably be fixed differently?

If I get to review it further to the point I don't disappoint, sure,
otherwise at least you now know of my suspicions.

  Luis
