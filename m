Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:39170 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbeCUP1D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 11:27:03 -0400
Received: by mail-wm0-f65.google.com with SMTP id f125so10520225wme.4
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 08:27:03 -0700 (PDT)
Date: Wed, 21 Mar 2018 16:27:00 +0100
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Johannes Berg <johannes@sipsolutions.net>, nbd@nbd.name,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mt76: enable MAC80211_LEDS by default
Message-ID: <20180321152659.GA8108@localhost.localdomain> (sfid-20180321_162707_865307_57C0713D)
References: <cover.1521209538.git.lorenzo.bianconi@redhat.com>
 <a159566d0970fb5c43da7758d8281b594b6ca48e.1521209538.git.lorenzo.bianconi@redhat.com>
 <1521585916.19123.3.camel@sipsolutions.net>
 <CAK8P3a1aHXPzvpZET=d2+snMPvsKx=rwfMN-r1_F2HK-KvjC0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK8P3a1aHXPzvpZET=d2+snMPvsKx=rwfMN-r1_F2HK-KvjC0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 21, Arnd Bergmann wrote:
> On Wed, Mar 21, 2018 at 6:45 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2018-03-16 at 15:45 +0100, Lorenzo Bianconi wrote:
> >> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> >> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> >> @@ -1,5 +1,8 @@
> >>  config MT76_CORE
> >>       tristate
> >> +     select MAC80211_LEDS
> >
> > Should drivers really mess with mac80211's configuration that way? I
> > believe this is a user-visible config, no?
> 
> We have a couple of drivers using 'select LEDS_CLASS' and others
> doing 'depends on LEDS_CLASS'. I think the latter is what we should
> have here for all those drivers.
> 
> MAC80211_LEDS looks like it's designed to be optional, so nothing
> should select or depend on that.
> 
>           Arnd

Reviewing the current code we do not actually need MAC80211_LEDS, so I agree
to remove it from Kconfig and let userspace selects the option. I would use
select for LEDS_CLASS. If you agree I can send a v2 otherwise I fine to apply
Arnd's patch.
Felix what do you think?

Regards,
Lorenzo
