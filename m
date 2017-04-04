Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38227 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753123AbdDDVbS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 17:31:18 -0400
Received: by mail-wm0-f46.google.com with SMTP id t189so39151185wmt.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 14:31:17 -0700 (PDT)
Subject: Re: [PATCH RFC] remove custom Michael MIC implementation
To: "Tobin C. Harding" <me@tobin.cc>
References: <1490935659-7196-1-git-send-email-me@tobin.cc>
 <20170331075851.GB1435@katana> <20170331102113.GA2930@eros>
 <87fuhq6par.fsf@purkki.adurom.net> <20170403090359.GK3755@eros>
 <87y3vhx1ju.fsf@alrua-karlstad>
 <9bfd1405-fd32-e896-b6f0-09ffedeaac33@broadcom.com>
 <20170403213910.GA7480@eros>
Cc: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Tycho Andersen <tycho@tycho.ws>,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <060699f7-df85-8530-17bc-6174efb946f2@broadcom.com> (sfid-20170404_233153_828564_49A92176)
Date: Tue, 4 Apr 2017 23:31:14 +0200
MIME-Version: 1.0
In-Reply-To: <20170403213910.GA7480@eros>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 3-4-2017 23:39, Tobin C. Harding wrote:
> On Mon, Apr 03, 2017 at 12:15:15PM +0200, Arend Van Spriel wrote:
>> seems we are missing out again?
> 
> Sorry, I don't understand what this comment means?

My bad. I had to reset my email account in thunderbird and now it needs
to learn anew what is spam and what is not. So I missed out on the
conversation as some messages (a lot actually) ended up in my spam folder.

>> On 3-4-2017 11:50, Toke Høiland-Jørgensen wrote:
>>> "Tobin C. Harding" <me@tobin.cc> writes:
>>>
>>>> Except one: do you know off the top of your head of a canonical
>>>> implementation of a softmac wi-fi driver.
>>>
>>> I'll suggest taking a look at the ath9k driver :)
>>
>> Looking at ks7010 driver it looks like it has 802.11 stack in firmware
>> and not sure if Renesas is actively supporting this effort to come up
>> with mac80211-friendly firmware or provide detailed chip info.
> 
> Thanks for taking a look. If the ks7010 driver has 802.11 stack in
> firmware does that mean it is not compatible with using the kernel
> mac80211 stack with the current firmware? I do not have my hopes up
> about getting any chip information out of Renesas, all I think we have
> to go in is the current WEXT driver.

Indeed. That is my gut feeling as well and if that is truly the case
your best option would be a cfg80211-based driver like ath6kl, mwifiex,
and brcmfmac.

> This is an exercise in learning for me, but I do not want to take any
> ones time up with a project that is not that useful. Is getting the
> ks7010 driver out of staging something that is of use to the kernel
> community or are there other wi-fi tasks that our time is better spent
> on?

If there are linux users with this hardware than sure. Especially if it
revised to interface with the latest wireless subsystem so tools like iw
can operate on it.

Also I suppose it is preferred if a driver is maintained. I do not see
the ks7010 listed in the MAINTAINERS file yet.

> thanks,
> Tobin.
> 
