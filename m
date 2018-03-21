Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:39759 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbeCUG7S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 02:59:18 -0400
Received: by mail-qt0-f196.google.com with SMTP id v11so4250659qtj.6
        for <linux-wireless@vger.kernel.org>; Tue, 20 Mar 2018 23:59:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521585916.19123.3.camel@sipsolutions.net>
References: <cover.1521209538.git.lorenzo.bianconi@redhat.com>
 <a159566d0970fb5c43da7758d8281b594b6ca48e.1521209538.git.lorenzo.bianconi@redhat.com>
 <1521585916.19123.3.camel@sipsolutions.net>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 21 Mar 2018 14:59:17 +0800
Message-ID: <CAK8P3a1aHXPzvpZET=d2+snMPvsKx=rwfMN-r1_F2HK-KvjC0g@mail.gmail.com> (sfid-20180321_075922_465429_621C8763)
Subject: Re: [PATCH] mt76: enable MAC80211_LEDS by default
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 21, 2018 at 6:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2018-03-16 at 15:45 +0100, Lorenzo Bianconi wrote:
>> --- a/drivers/net/wireless/mediatek/mt76/Kconfig
>> +++ b/drivers/net/wireless/mediatek/mt76/Kconfig
>> @@ -1,5 +1,8 @@
>>  config MT76_CORE
>>       tristate
>> +     select MAC80211_LEDS
>
> Should drivers really mess with mac80211's configuration that way? I
> believe this is a user-visible config, no?

We have a couple of drivers using 'select LEDS_CLASS' and others
doing 'depends on LEDS_CLASS'. I think the latter is what we should
have here for all those drivers.

MAC80211_LEDS looks like it's designed to be optional, so nothing
should select or depend on that.

          Arnd
