Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55209 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2G0G4Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 02:56:24 -0400
Received: by obbuo13 with SMTP id uo13so3865799obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2012 23:56:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343324856.4477.9.camel@jlt3.sipsolutions.net>
References: <1343231359-3024-1-git-send-email-eliad@wizery.com>
	<1343324856.4477.9.camel@jlt3.sipsolutions.net>
Date: Fri, 27 Jul 2012 09:56:23 +0300
Message-ID: <CAB3XZEfJbfhaECrKTO1+zZ1RU=sJ7Pi54tL4q-B8Rif1YWr+Zg@mail.gmail.com> (sfid-20120727_085653_883695_56AA99BB)
Subject: Re: [PATCH] mac80211: add PS flag to bss_conf
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 26, 2012 at 8:47 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-07-25 at 18:49 +0300, Eliad Peller wrote:
>
>> @@ -2085,6 +2092,9 @@ static int ieee80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
>>
>>       ieee80211_recalc_ps(local, -1);
>>
>> +     sdata->vif.bss_conf.ps = ieee80211_powersave_allowed(sdata);
>> +     ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_PS);
>
> It need not have changed, since the AP could be broken? We might also
> not even be associated, so I don't think this is right.
>
sure i'll fix it.
i think i'll just refactor this code to ieee80211_recalc_ps_vif() that
will do the recalc-and-notify-if-changed instead of duplicating it
each time.

>
> I also wonder if ieee80211_recalc_ps() should use vif.bss_conf.ps
> instead of calling powersave_allowed() itself?
>
i think we should better keep them decoupled. this way we can change
the per-vif functionality without affecting the legacy per-device one.

Eliad.
