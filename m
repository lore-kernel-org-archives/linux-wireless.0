Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.180]:22820 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYIOX5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 19:57:08 -0400
Received: by ik-out-1112.google.com with SMTP id c30so2143926ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2008 16:57:05 -0700 (PDT)
Message-ID: <1ba2fa240809151657xcdeb782j4fa55a1e6874866@mail.gmail.com> (sfid-20080916_015713_906200_1F47394F)
Date: Tue, 16 Sep 2008 02:57:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] mac80211: re-enable aggregation on 2.6.27
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080915230952.GG22572@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221503192-28502-1-git-send-email-lrodriguez@atheros.com>
	 <1ba2fa240809151606l31fe9d8jbdc34e179910ec8f@mail.gmail.com>
	 <20080915230952.GG22572@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2008 at 2:09 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Mon, Sep 15, 2008 at 04:06:18PM -0700, Tomas Winkler wrote:
>> On Mon, Sep 15, 2008 at 9:26 PM, Luis R. Rodriguez
>> <lrodriguez@atheros.com> wrote:
>> > Re-enable aggregation by addressing skb->cb overwrites
>> > after insertion into the qdisc. Aggregation was disabled
>> > after the new TX multiqueue changes were introduced. Instead
>> > of relying on the skb->cb we use two flags on the skb.
>> >
>> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> > ---
>> >
>> > Users have been reporting low rates on 2.6.27 with 11n drivers, the
>> > problem isbeen 11n aggregation was disabled due to the new TX multique
>> > changes. We should have addressed this sooner but we just got to it now.
>> >
>> > Without addressing this we won't get 11n aggregation on 2.6.27. I tried
>> > to minimize the changes required. I'm about to test this, it compiles.
>> >
>> > If this doesn't get upstream for 27 perhaps distributions are willing to
>> > carry it around then and if so oh well (grr...).
>> >
>> I'm cleaning this up.
>
> Great.
>
>> I will probably drop skb->is_part_ampdu so no
>> changes in the drivers will be required.
>
> How so? I mean, if the flag is modified it'll need modification.

I'll Set the original flag (info->flags) in sequence ctrl handler. No
need to keep it through requeuing.
Tomas
