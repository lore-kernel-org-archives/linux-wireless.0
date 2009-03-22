Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:41424 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbZCVOtv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 10:49:51 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1398669rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 07:49:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237726612.19647.2.camel@johannes.local>
References: <20090322174515.22f11d92@home.aephome.ru>
	 <1237726612.19647.2.camel@johannes.local>
Date: Sun, 22 Mar 2009 10:49:50 -0400
Message-ID: <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com> (sfid-20090322_154956_271812_C4EAF362)
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org, mb@bu3sch.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2009 at 8:56 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2009-03-22 at 17:45 +0500, Alexander E. Patrakov wrote:
>
>> There are several different panic messages,
>> the common thing is "Fatal exception in interrupt". Without uvesafb,
>> they also include "zd_op_tx+0x98/0x1cc [zd1211rw]" as the last line,
>
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff;h=3b23889bb2366c1b10f69bcca16cf53426b5e309
>
>> but with uvesafb, this sometimes changes to
>> "rate_control_get_rate+0xb7/0xc3 [mac80211]".

Hmm, I've seen the rate_control one before, and there's a guy
with ath5k who can reproduce it easily.  Looks like minstrel
somehow gets confused about the rate table and eventually tries
to use -1 as a valid rate index.  Neither I nor Felix could come
up with a logical explanation, though (I am completely lost in
the RC code, so that's not saying much for me).

He is using ad-hoc too - but I use adhoc on a daily basis and
haven't seen it myself.

Bugzilla is here:
http://bugzilla.kernel.org/show_bug.cgi?id=12490

By the way Alexander, W taint means the kernel already warned
about something, probably that get_tx_rate is returning null.

-- 
Bob Copeland %% www.bobcopeland.com
