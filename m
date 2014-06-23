Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:57129 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495AbaFWS6A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 14:58:00 -0400
Received: by mail-lb0-f179.google.com with SMTP id z11so5031915lbi.24
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 11:57:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfe91Lcf2H1vEficPTNumdd2sBOR8KV8cD5tsy+po4M0mg@mail.gmail.com>
References: <1402469724-22358-1-git-send-email-arik@wizery.com>
 <1402469724-22358-3-git-send-email-arik@wizery.com> <CAB=NE6UZPcgAAJ6GAnjy2nSdYhLRqxo4h1ZZoZ7vYsAbYBiw+Q@mail.gmail.com>
 <CA+XVXfc=zDyie-3xO86k98zKQUZqDm0dEf9d5qMDAX83svfR_Q@mail.gmail.com>
 <20140623182333.GB1390@garbanzo.do-not-panic.com> <CA+XVXfe91Lcf2H1vEficPTNumdd2sBOR8KV8cD5tsy+po4M0mg@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 23 Jun 2014 11:57:38 -0700
Message-ID: <CAB=NE6Va7ynqAsRkgVQ1hCLMu6_Wco_=-Wa5dqrSzPMkA-pYeQ@mail.gmail.com> (sfid-20140623_205806_455884_6C4F63A7)
Subject: Re: [PATCH 3/5] cfg80211: treat the special "unknown" alpha2 as valid
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 23, 2014 at 11:32 AM, Arik Nemtsov <arik@wizery.com> wrote:
>> modifieres for user_reg_hint_type, you'd want a driver_reg_hint_type,

Minor note, since the driver reg hint type can be require the
regulatory data source to be internal to the driver (firmware or
driver, we won't know) and since the new API can allow the
driver/firmware to pass and let the request come from CRDA /
wireless-regdb / internal db the driver hint is different from the
final *set* regulatory domain. So for example although the goal was to
query firmware first if the driver passed and let the source of
regulatory data come from CRDA / wireless-regdb / internal regdb we'd
want to ensure userspace is informed of this. So I think we'd need a
regulatory data structure source type as well, right now it'd default
to wireless-regdb as the source (that would suffice for CRDA or
internal-db), and your changes would add an internal-driver source.

Since this is allowing drivers to be explicit about their regulatory
data it would be nice if as part of this we can then get 'iw reg get'
the ability to then spit out per wiphy regd. Since even the custom
regd requires passing a custom regd this could even enable parsing
that data as well. This should make trouble shooting for intersections
much easier on complex systems.

  Luis
