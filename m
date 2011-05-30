Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35858 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab1E3UN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 16:13:28 -0400
Received: by ywe9 with SMTP id 9so1559527ywe.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 13:13:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1306773994.3448.9.camel@jlt3.sipsolutions.net>
References: <1306418007-27573-1-git-send-email-eliad@wizery.com>
	<1306773994.3448.9.camel@jlt3.sipsolutions.net>
Date: Mon, 30 May 2011 23:13:27 +0300
Message-ID: <BANLkTi=ybhS9PGFdupz6-=sj-TMKuOVK4w@mail.gmail.com> (sfid-20110530_221331_751819_D027945C)
Subject: Re: [RFC 1/2] mac80211: add ieee80211_get_operstate() function
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 30, 2011 at 7:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-05-26 at 16:53 +0300, Eliad Peller wrote:
>> Add ieee80211_get_operstate() function to get the operstate
>> of the netdevice.
>>
>> This is needed for drivers that need to know when the interface
>> is IF_OPER_UP (e.g. wl12xx), and block notifiers can't be used
>> (e.g. because the interface is already IF_OPER_UP, like after
>> resuming from suspend)
>
> I don't see how this is necessary since the operstate can't change
> during suspend?
>
in the normal connection flow, after BSS_CHANGED_ASSOC, wl12xx waits
for IF_OPER_UP notification (the fw wants to know when the interface
is up and ready), which comes immediately (open networks) or after the
EAPOL exchange completed successfully.

when reconfiguring, after suspend, the operstate is already
IF_OPER_UP, so we won't get this notification.
we need some way to query the current operstate.

Eliad.
