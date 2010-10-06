Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33424 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab0JFUsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 16:48:45 -0400
Received: by iwn5 with SMTP id 5so10187320iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 13:48:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286392799.3655.414.camel@jlt3.sipsolutions.net>
References: <20101006185000.GJ7070@tux> <1286391301.3655.403.camel@jlt3.sipsolutions.net>
 <20101006191215.GM7070@tux> <1286392799.3655.414.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 6 Oct 2010 13:48:23 -0700
Message-ID: <AANLkTinOTsYKFpQkg2B7GVMF-eKykFd8LM1m8xmtXX7j@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Deny new BA agreements from being started
 during offchannel operation
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
	Matt Smith <Matt.Smith@atheros.com>,
	Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 6, 2010 at 12:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2010-10-06 at 12:12 -0700, Luis R. Rodriguez wrote:
>
>> Good question, will ieee80211_offchannel_ps_disable() possibly be
>> called during suspend? I can imagine its possible. So how about we
>> check for local->quiescing prior to lifting the flag only:
>
> Or suspended?

If we're suspended we would be quiesced so I do not see us calling
ieee80211_offchannel_ps_disable() then, but we can also just bail out
if quescing or suspended on  ieee80211_offchannel_ps_disable() and
friends.

> I'm not really sure .. this will probably interact badly
> anyway. Hmm.

Which part?

  Luis
