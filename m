Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56546 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989Ab0I0ROr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:14:47 -0400
Received: by iwn5 with SMTP id 5so4905322iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 10:14:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1285584763.4043.14.camel@jlt3.sipsolutions.net>
References: <1285379997-1544-1-git-send-email-lrodriguez@atheros.com> <1285584763.4043.14.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 27 Sep 2010 10:14:26 -0700
Message-ID: <AANLkTi=9iMqdpAjRDTE8BhLpa71T4BDR20BgHTucgz-e@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix offchannel assumption upon association
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Amod Bodas <amod.bodas@atheros.com>,
	Vasanth Thiagarajan <vasanth.thiagarajan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 3:52 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-09-24 at 21:59 -0400, Luis R. Rodriguez wrote:
>> Association is dealt with as an atomic offchannel operation,
>> we do this because we don't know we are associated until we
>> get the associatin response from the AP. When we do get the
>> associatin response though we were never clearing the offchannel
>> state. This has a few implications, we told drivers we were
>> still offchannel, and the first configured TX power for the
>> channel does not take into account any power constraints.
>>
>> For ath9k this meant ANI calibration would not start upon
>> association, and we'd have to wait until the first bgscan
>> to be triggered. There may be other issues this resolves
>> but I'm too lazy to colb the code to check.
>
> colb?

Heh oops typo, I meant "comb".

> But anyway, looks OK to me. Need to revisit some of the off-channel
> stuff eventually, but for now this is fine I think.

OK thanks.

  Luis
