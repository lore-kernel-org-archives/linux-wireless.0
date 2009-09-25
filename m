Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:42881 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbZIYPyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 11:54:20 -0400
Received: by fxm18 with SMTP id 18so2308576fxm.17
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 08:54:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253859759.3868.569.camel@johannes.local>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <3ace41890909241213q5b4992a0sffd4c34a69ac9bb6@mail.gmail.com>
	 <1253859759.3868.569.camel@johannes.local>
Date: Fri, 25 Sep 2009 16:54:22 +0100
Message-ID: <3ace41890909250854t3062d1betf89501e5775ccdd0@mail.gmail.com>
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 7:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Thanks for your analysis.
>
>> This seems to look like/relate to a little problem I have for the last
>> few days - lately I have authentication failure on first try and have
>> to click on NM a 2nd time for it to go through; blow away
>> compat-wireless & revert to as-shipped distro modules gives me the
>> older/smooth behavior  of NM just associating without me
>> clicking/asking.
>>
>> v2.6.31-38294-ged3ac87 + 'cfg80211: don't set privacy w/o key' doesn't
>> improve my situation.
>>
>> wpa_supplicant log:
>> --------- distro modules:
>> Trying to associate with <id> (SSID='ID' freq=2437 MHz)
>> Associated with <id>
>> CTRL-EVENT-CONNECTED - Connection to <id> completed (auth) [id=0 id_str=]
>> CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
>>
>> -------- compat-wireless
>> Trying to associate with <id> (SSID='ID' freq=2437 MHz)
>> Authentication with 00:00:00:00:00:00 timed out.
>> Trying to associate with <id> (SSID='ID' freq=2437 MHz)
>> Associated with <id>
>> CTRL-EVENT-CONNECTED - Connection to <id> completed (auth) [id=0 id_str=]
>>
>> ------ dmesg distro modules
>> wlan2: direct probe to AP <id> try 1
>> wlan2 direct probe responded
>> wlan2: authenticate with AP <id>
>> wlan2: authenticated
>> wlan2: associate with AP <id>
>> wlan2: RX AssocResp from <id> (capab=0x431 status=0 aid=1)
>> wlan2: associated
>>
>> ------ compat-wireless, note the extra deauth at the beginning, and
>> all those 'try 1''s.
>> wlan2: deauthenticating by local choice (reason=3)
>> wlan2: direct probe to AP <id> (try 1)
>> wlan2 direct probe responded
>> wlan2: authenticate with AP <id> (try 1)
>> wlan2: authenticated
>> wlan2: associate with AP <id> (try 1)
>> wlan2: RX AssocResp from <id> (capab=0x431 status=0 aid=1)
>> wlan2: associated
>
> I've analysed this, and now know the reason for the extra deauth, but it
> shouldn't hurt since we never send a wireless extensions event. The
> reason is that once wpa_supplicant sets the SSID we already start to
> connect with the new changes, but then setting the BSSID might require
> restarting the process. This could be optimised, but I would prefer not
> having to.
>
> I can see a problem with the code and it trying to scan once more again
> etc. Below patch seems to help for me. However, I only once managed to
> reproduce the problem you were seeing with the authentication timeout in
> wpa_supplicant.
>
> Can you try this? The last hunk is most important, but the other stuff
> helps debugging.

Great. The extra timeout in wap_spplicant.log is gone, so it is back
to NM does it all by itself.

Here is the dmesg from this patch on top of everything else so far:

wlan2: starting authentication with _id_
wlan2: deauthenticating from _id_ by local choice (reason=3)
wlan2: starting authentication with _id_
wlan2: direct probe to AP _id_ (try 1)
wlan2: direct probe responded
wlan2: authenticate with AP _id_ (try 1)
wlan2: authenticated
wlan2: starting association with _id_
wlan2: associate with AP _id_ (try 1)
wlan2: RX AssocResp from _id_ (capab=0x431 status=0 aid=1)
wlan2: associated

There is still the extra deauth at the beginning, but I guess I can
live with it, it doesn't require user action to deal with (unlike
without this latest patch) I suppose there might be more tuning before
commit?  Otherwise Tested-by:

Hmm, slightly side-tracked - was the original poster using NM on top
on wpa_supplicant, just curious?

Cheers,
Hin-Tak
