Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:45508 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZIZX5e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 19:57:34 -0400
Received: by bwz6 with SMTP id 6so627013bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2009 16:57:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253965154.5122.7.camel@johannes.local>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
	 <1253859759.3868.569.camel@johannes.local>
	 <3ace41890909250854t3062d1betf89501e5775ccdd0@mail.gmail.com>
	 <1253965154.5122.7.camel@johannes.local>
Date: Sun, 27 Sep 2009 00:57:37 +0100
Message-ID: <3ace41890909261657s53b38a2fl7939740fc53dd594@mail.gmail.com>
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 26, 2009 at 12:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2009-09-25 at 16:54 +0100, Hin-Tak Leung wrote:
>
>> > Can you try this? The last hunk is most important, but the other stuff
>> > helps debugging.
>>
>> Great. The extra timeout in wap_spplicant.log is gone, so it is back
>> to NM does it all by itself.
>
> Interesting, thanks for the test. I'll go submit the patch.
>
>> Here is the dmesg from this patch on top of everything else so far:
>>
>> wlan2: starting authentication with _id_
>> wlan2: deauthenticating from _id_ by local choice (reason=3)
>> wlan2: starting authentication with _id_
>> wlan2: direct probe to AP _id_ (try 1)
>> wlan2: direct probe responded
>> wlan2: authenticate with AP _id_ (try 1)
>> wlan2: authenticated
>> wlan2: starting association with _id_
>> wlan2: associate with AP _id_ (try 1)
>> wlan2: RX AssocResp from _id_ (capab=0x431 status=0 aid=1)
>> wlan2: associated
>>
>> There is still the extra deauth at the beginning, but I guess I can
>> live with it, it doesn't require user action to deal with (unlike
>> without this latest patch) I suppose there might be more tuning before
>> commit?
>
> I think I'll just remove some of the printks again, but leave the ones
> moving. Actually probably better to split it up into a mac80211 and a
> cfg80211 patch.
>
> The extra deauth is because cfg80211 already starts the auth with the
> BSS before wpa_supplicant set the BSSID, and then when setting the BSSID
> it asks for deauth, but before we ever actually did anything... I think
> we'll just have to live with that, since it's hard to fix in the layered
> design we have now.

I suppose (together with some of the newly added printk you mentioned
could be removed in the final version) the dmesg messages are somewhat
confusing, because as a user, I would rather have a deauth message
that's actually associated with a user action (e.g. if I switch AP or
rfkill). Is it possible to distinguish situation where a user action
is involved versus one that isn't? or is the distinction between any
consequence of 'user-action' vs wpa_supplicant doing-it-on-its-own too
much buried down in the layers?

>>  Otherwise Tested-by:
>>
>> Hmm, slightly side-tracked - was the original poster using NM on top
>> on wpa_supplicant, just curious?
>
> You mean Albert? I don't know.

Yes - I meant Albert - wpa_spplicant runs directly probably behaves a
little differently from NM starting/stopping it.

>
> johannes
>
