Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62308 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaCKNZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 09:25:40 -0400
Received: by mail-ob0-f170.google.com with SMTP id uz6so8473036obc.29
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 06:25:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394543651.30155.3.camel@jlt4.sipsolutions.net>
References: <1394176178-8504-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQkVfgkMR_cvv5dUNkzLd7KrDQ7VMYKucJybpF0aAWpESA@mail.gmail.com>
	<1394543651.30155.3.camel@jlt4.sipsolutions.net>
Date: Tue, 11 Mar 2014 14:25:39 +0100
Message-ID: <CA+BoTQk19_p8WcUpUbRNTZgStNMfYcSZEUhbEB9G6i0mvYy-=w@mail.gmail.com> (sfid-20140311_142543_469848_3B67BEFA)
Subject: Re: [PATCH] mac80211: fix possible NULL dereference
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 March 2014 14:14, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2014-03-11 at 12:30 +0100, Michal Kazior wrote:
>> On 7 March 2014 08:09, Michal Kazior <michal.kazior@tieto.com> wrote:
>> > If chanctx is missing on a given vif then the band
>> > is assumed to be 2GHz. However if hw doesn't
>> > support 2GHz band then mac80211 ended up with a
>> > NULL dereference.
>
>> Drop this, please. There are more places that need sband to be
>> NULL-checked. I'll send out a more thorough patch later.
>
> Ok. However, I'm not sure that we should ever really run into this? At
> least with Luca's patches we want to not go through NULL state to start
> with.

Current channel reservation patches do a sequence of
unassign_vif_chanctx() followed by assign_vif_chanctx(). This implies
you have no chanctx for a split second. All places that aren't
protected by chanctx_mtx (i.e. RCU) can get NULL chanctx during the
reassignment.

One way to trigger that would be to spam-call ieee80211_get_station().
If you get a NULL chanctx and you have 5GHz only hardware you get NULL
dereference kernel splat.

With multi-vif CSA the vulnerability timeframe will increase.


Michał
