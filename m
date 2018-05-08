Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:45543 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754370AbeEHUDq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 16:03:46 -0400
Received: by mail-io0-f178.google.com with SMTP id c9-v6so33628916iob.12
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 13:03:46 -0700 (PDT)
Received: from mail-io0-f170.google.com (mail-io0-f170.google.com. [209.85.223.170])
        by smtp.gmail.com with ESMTPSA id m11-v6sm6442846ioo.60.2018.05.08.13.03.44
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 May 2018 13:03:44 -0700 (PDT)
Received: by mail-io0-f170.google.com with SMTP id g14-v6so36318533ioc.7
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2018 13:03:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1525781970.14830.11.camel@sipsolutions.net>
References: <20180428014732.4018-1-andrew.zaborowski@intel.com>
 <87in8b8ooy.fsf@purkki.adurom.net> <CAOq732JPfbJWyR0RROY-t67p7dOuoHoHS6eaMrZ1j39F1Q0zmg@mail.gmail.com>
 <1525720752.22388.3.camel@sipsolutions.net> <5AF1959E.6020605@broadcom.com> <1525781970.14830.11.camel@sipsolutions.net>
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
Date: Tue, 8 May 2018 22:03:44 +0200
Message-ID: <CAOq732+fenUS0GX+oHvc5u7kYZ2D9kT0uYJE_-8Qd+jvb7Nb_A@mail.gmail.com> (sfid-20180508_220351_433494_81838C1D)
Subject: Re: [PATCH] nl80211: Reject disconnect commands except from conn_owner
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 8 May 2018 at 14:19, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2018-05-08 at 14:18 +0200, Arend van Spriel wrote:
>> On 5/7/2018 9:19 PM, Johannes Berg wrote:
>> > On Sun, 2018-04-29 at 20:30 +0200, Andrew Zaborowski wrote:
>> > > On 28 April 2018 at 15:07, Kalle Valo <kvalo@codeaurora.org> wrote:
>> > > > Andrew Zaborowski <andrew.zaborowski@intel.com> writes:
>> > > > > Reject NL80211_CMD_DISCONNECT, NL80211_CMD_DISASSOCIATE,
>> > > > > NL80211_CMD_DEAUTHENTICATE and NL80211_CMD_ASSOCIATE commands
>> > > > > from clients other than the connection owner set in the connect,
>> > > > > authenticate or associate commands, if it was set.
>> > > > >
>> > > > > The main point of this check is to prevent chaos when two processes
>> > > > > try to use nl80211 at the same time, it's not a security measure.
>> > > > > The same thing should possibly be done for JOIN_IBSS/LEAVE_IBSS and
>> > > > > START_AP/STOP_AP.
>> > > >
>> > > > s-o-b missing.
>> > >
>> > > True, thanks.  Also I was going to send this as an RFC.
>> > >
>> >
>> > Looks fine to me, please resend if you want it in :)
>>
>> Do we really want this? Is the referred chaos hypothetical or an actual
>> issue. Nothing stops me from doing an 'ifconfig down' so why should 'iw
>> disconnect' be any different. As far I can tell it does not affect my
>> testing environment, but particularly in such use-cases I can expect
>> issues adopting this change, which is also hypothetical of course ;-)
>
> Yeah, it's a good question. But it might help with inadvertent issues,
> like starting wpa_s which immediately disconnects if it finds something
> connected. If that fails, perhaps you have a better chance of noticing
> the error?

This patch was only motivated by a case of running both iwd and
wpa_supplicant simultaneously by mistake.  They can both handle things
like 'ifconfig down', but when one daemon tries to connect the other
immediately commands a disconnect (makes sense) and it made us think
whether it was more correct if that disconnect command failed.  I'm
not really sure what's right here so I wanted to float this idea.

Best regards
