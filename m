Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:63111 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYJATQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 15:16:43 -0400
Received: by gxk9 with SMTP id 9so610585gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 12:16:42 -0700 (PDT)
Message-ID: <43e72e890810011216y17c3f4a6v28c74215c023ecb2@mail.gmail.com> (sfid-20081001_211648_004202_EFFEEB15)
Date: Wed, 1 Oct 2008 12:16:42 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [RFC v4] mac80211: re-enable aggregation on 2.6.27
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809301707i22cab6b7hb1b22fc88ebda7f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1222790548-7391-1-git-send-email-lrodriguez@atheros.com>
	 <1ba2fa240809301318p16bedbdr31fdaea97c3cf3be@mail.gmail.com>
	 <20080930152524.GA8131@tesla>
	 <1ba2fa240809301707i22cab6b7hb1b22fc88ebda7f0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 30, 2008 at 5:07 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Tue, Sep 30, 2008 at 6:25 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> A quick test indicates it works but the removal is still an issue.
>
> I didn't implement it yet I just wanted a feedback if I'm in correct
> direction with the starting part.

Seems reasonable so far, my concern so far was just the introduction
of a new spinlock for the ba_session list, but I can't see yet a
better way.

At this point I've given up hope of this getting merged but I do think
distributions using 2.6.27 will want this anyway so we might as well
finish the job and maintain it ourselves should it not get merged.
What do you think?

> yes ieee80211_init_agg()

Thanks, I'm using this now.

>> I don't think it was locking before under the code which is now
>> under initiate_aggr_and_timer() though.
>
> Correct you cannot lock this part it leads to soft lock.

Oh ok v3 had this order.

  Luis
