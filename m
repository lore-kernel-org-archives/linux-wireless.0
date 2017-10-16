Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0044.outbound.protection.outlook.com ([104.47.33.44]:47122
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752678AbdJPTRa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 15:17:30 -0400
Subject: Re: [PATCH] iw: add command to register and capture mgmt frames
To: Johannes Berg <johannes@sipsolutions.net>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Avinash Patil <avinashp@quantenna.com>,
        Julian Calaby <julian.calaby@gmail.com>
References: <20171014210036.29556-1-sergey.matyukevich.os@quantenna.com>
 <CALLGbR+DonvXRDysZGx3fJ0wGQsmnWNW3db7mv9KObwTcicnOg@mail.gmail.com>
 <20171015095133.prxuuukv6osx52td@bars>
 <1508138777.10607.14.camel@sipsolutions.net>
 <20171016084810.plzog2dtzakra4ae@bars>
 <1508145899.10607.30.camel@sipsolutions.net>
From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <844c4931-f513-773b-21db-f8e5455088b9@quantenna.com> (sfid-20171016_211736_152151_54AA6A46)
Date: Mon, 16 Oct 2017 12:17:22 -0700
MIME-Version: 1.0
In-Reply-To: <1508145899.10607.30.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/2017 02:24 AM, Johannes Berg wrote:
> 
> 
> Right, and I didn't originally see the patch as such, just that the
> discussion (and in particular Julian's suggestion) veered off in that
> direction.
> 
>> Nevertheless in certain cases it is handy to dump selected types of
>> mgmt frames while system is up and running without adding the whole
>> monitor overhead. The idea was that NL80211_CMD_REGISTER_FRAME and iw
>> are the right tools for that task. Anyway, iw is something like a
>> 'swiss-army-knife' tool for various tasks related to
>> mac80211/cfg80211 reporting and troubleshooting.
> 
> I'd see this particular feature in iw more as a way to debug the
> registrations, but whatever you ultimately want to use it for I neither
> can nor want to control :-)
> 

Maybe we could add an additional nl attribute to 
NL80211_CMD_REGISTER_FRAME command to allow applications to advertise 
what is their intention, something like NL80211_ATTR_MGMT_LISTENER_TYPE. 
Only allow to register more then one listener if it explicitly specifies 
that it will not try to answer (TYPE_LISTEN_ONLY or smth like that).
This will preserve behavior for existing userspace.
