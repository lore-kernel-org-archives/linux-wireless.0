Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46255 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab2GEPB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 11:01:58 -0400
Received: by obbuo13 with SMTP id uo13so13153657obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2012 08:01:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120702181747.GA2010@tuxdriver.com>
References: <1341230905-8929-1-git-send-email-eliad@wizery.com>
	<1341231541.19642.3.camel@jlt3.sipsolutions.net>
	<20120702181747.GA2010@tuxdriver.com>
Date: Thu, 5 Jul 2012 18:01:58 +0300
Message-ID: <CAB3XZEe-ckFE3ivCpYtRsZaFw0v6dFjDaywUje4TKO18kWiz3A@mail.gmail.com> (sfid-20120705_170203_443077_52E99B4D)
Subject: Re: [PATCH] mac80211: always set in_reconfig=false on wakeup
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 2, 2012 at 9:17 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Mon, Jul 02, 2012 at 02:19:01PM +0200, Johannes Berg wrote:
>> On Mon, 2012-07-02 at 15:08 +0300, Eliad Peller wrote:
>> > If the interfaces were removed just before a restart
>> > work was started, open_count will be 0, and most of
>> > the reconfig work will be skipped, including the
>> > resetting of local->in_reconfig to false.
>> >
>> > Leaving local->inconfig = true will result in
>> > dropping any incoming packet.
>> >
>> > Fix it by always setting local->in_reconfig = false
>> > (even if there are no active interfaces).
>> >
>> > Signed-off-by: Eliad Peller <eliad@wizery.com>
>> > ---
>> > this should go to 3.5
>>
>> Also looks good, thanks
>>
>> Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
>>
>> John, could you also pick this up?
>>
>> johannes
>>
>>
>> >  net/mac80211/util.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/net/mac80211/util.c b/net/mac80211/util.c
>> > index 242ecde..e1b7c63 100644
>> > --- a/net/mac80211/util.c
>> > +++ b/net/mac80211/util.c
>> > @@ -1411,10 +1411,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>> >             if (ieee80211_sdata_running(sdata))
>> >                     ieee80211_enable_keys(sdata);
>> >
>> > + wake_up:
>> >     local->in_reconfig = false;
>> >     barrier();
>> >
>> > - wake_up:
>> >     /*
>> >      * Clear the WLAN_STA_BLOCK_BA flag so new aggregation
>> >      * sessions can be established after a resume.
>
> This doesn't apply to 3.5 -- the "local->in_reconfig = false" bit isn't there.
>
err... my mistake. this only applies on wireless-next.
sorry for the hassle.

Eliad.
