Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:51477 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaD2GAG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 02:00:06 -0400
Received: by mail-we0-f175.google.com with SMTP id q58so7197132wes.20
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 23:00:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398700073.4132.2.camel@jlt4.sipsolutions.net>
References: <20140428082225.GA15459@jouni.qca.qualcomm.com>
	<CA+BoTQ=gP49PDuyYovQmc-jtFwKN6JDOToSsT20ssnJZGaqieQ@mail.gmail.com>
	<1398699982.4132.1.camel@jlt4.sipsolutions.net>
	<1398700073.4132.2.camel@jlt4.sipsolutions.net>
Date: Tue, 29 Apr 2014 08:00:04 +0200
Message-ID: <CA+BoTQk6KGqnXGuDrVhKvPoxJCofwPw04Y-bLfU0Xnjfusgrqg@mail.gmail.com> (sfid-20140429_080434_863956_F82D135E)
Subject: Re: [PATCH 2/3] mac80211: Support dynamic AP mode channel width changes
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 April 2014 17:47, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-04-28 at 17:46 +0200, Johannes Berg wrote:
>
>> > Shouldn't interface combinations be verified here? What if there was a
>> > bandwidth upgrade (after a downgrade) but in the meantime a vif with a
>> > to-be incompatible chandef was brought up?
>>
>> Yeah that seems like a potential issue.
>
> Hm, wait, isn't this addressed by this code in
> ieee80211_vif_change_bandwidth():
>
>         ctx = container_of(conf, struct ieee80211_chanctx, conf);
>         if (!cfg80211_chandef_compatible(&conf->def, chandef)) {
>                 ret = -EINVAL;
>                 goto out;
>         }

Yeah, you're right.


Michał
