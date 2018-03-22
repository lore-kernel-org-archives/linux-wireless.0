Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:38250 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754489AbeCVB7n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 21:59:43 -0400
Received: by mail-qt0-f194.google.com with SMTP id n12so7418483qtl.5
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 18:59:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180321152659.GA8108@localhost.localdomain>
References: <cover.1521209538.git.lorenzo.bianconi@redhat.com>
 <a159566d0970fb5c43da7758d8281b594b6ca48e.1521209538.git.lorenzo.bianconi@redhat.com>
 <1521585916.19123.3.camel@sipsolutions.net> <CAK8P3a1aHXPzvpZET=d2+snMPvsKx=rwfMN-r1_F2HK-KvjC0g@mail.gmail.com>
 <20180321152659.GA8108@localhost.localdomain>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 22 Mar 2018 09:59:42 +0800
Message-ID: <CAK8P3a1LdecQ7-3SfbCL90M3jysYJKfck6VhYmKgC7tJm4NN8g@mail.gmail.com> (sfid-20180322_030052_164885_9BB53397)
Subject: Re: [PATCH] mt76: enable MAC80211_LEDS by default
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, nbd@nbd.name,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2018, 23:27 Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> On Mar 21, Arnd Bergmann wrote:
> > On Wed, Mar 21, 2018 at 6:45 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Fri, 2018-03-16 at 15:45 +0100, Lorenzo Bianconi wrote:
> > >> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
> > >> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
> > >> @@ -1,5 +1,8 @@
> > >>  config MT76_CORE
> > >>       tristate
> > >> +     select MAC80211_LEDS
> > >
> > > Should drivers really mess with mac80211's configuration that way? I
> > > believe this is a user-visible config, no?
> >
> > We have a couple of drivers using 'select LEDS_CLASS' and others
> > doing 'depends on LEDS_CLASS'. I think the latter is what we should
> > have here for all those drivers.
> >
> > MAC80211_LEDS looks like it's designed to be optional, so nothing
> > should select or depend on that.
> >
> >           Arnd
>
> Reviewing the current code we do not actually need MAC80211_LEDS, so I agree
> to remove it from Kconfig and let userspace selects the option. I would use
> select for LEDS_CLASS. If you agree I can send a v2 otherwise I fine to apply
> Arnd's patch.
> Felix what do you think?

Looking at mt76 again, my impression is that the core driver should not have
an dependency on LEDS at all, the dependency should instead be restricted
to the CONFIG_MT76_LEDS symbol as my patch from January did (with the
change to 'default y').

      Arnd
