Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53002 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab0LGPvl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:51:41 -0500
Received: by iwn9 with SMTP id 9so40554iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 07:51:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291736887.3607.47.camel@jlt3.sipsolutions.net>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com> <1291714709.3607.2.camel@jlt3.sipsolutions.net>
 <AANLkTikrLweKeSR-=XziaJ5rqDRf_Ny=mg1OD=jC4nqA@mail.gmail.com> <1291736887.3607.47.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Dec 2010 07:51:21 -0800
Message-ID: <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, pstew@google.com, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 7:48 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2010-12-07 at 07:44 -0800, Luis R. Rodriguez wrote:
>
>> >>       drv_stop(local);
>> >> +     ieee80211_recalc_idle_force(local);
>> >
>> > That one definitely can't be after drv_stop().
>>
>> OK why though?
>
> Because you can't call into drivers after you stop them? Shouldn't this
> be obvious?

That makes sense, but mac80211 is the one who tells the driver when
its idle or non-idle, if we stop the device do we want it to handle an
idle check itself? This change would only force out an idle change
notification, nothing else.

  Luis
