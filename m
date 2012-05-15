Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44396 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964804Ab2EOPSo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 11:18:44 -0400
Received: by qadb17 with SMTP id b17so3696543qad.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 08:18:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120515151625.GA1306@w1.fi>
References: <1337091676-29441-1-git-send-email-eliad@wizery.com>
	<1337092228.15553.0.camel@jlt3.sipsolutions.net>
	<CAB3XZEd49R_KSAMRwM-B9PW_yzmK7aS9zzFVueA=nrFM7odC=w@mail.gmail.com>
	<20120515151625.GA1306@w1.fi>
Date: Tue, 15 May 2012 18:18:43 +0300
Message-ID: <CAB3XZEfhrc74sabq0OUYCKBx4DQ0cQciQke4cP1GP5s9xNm0Kg@mail.gmail.com> (sfid-20120515_171847_776378_883DC9F6)
Subject: Re: [PATCH] mac80211: retry auth and assoc on error 17
From: Eliad Peller <eliad@wizery.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 15, 2012 at 6:16 PM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, May 15, 2012 at 05:40:17PM +0300, Eliad Peller wrote:
>> On Tue, May 15, 2012 at 5:30 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2012-05-15 at 17:21 +0300, Eliad Peller wrote:
>> >> In some congested environments APs return
>> >> WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA on auth/assoc
>> >> attempt. Instead of failing immediately, retry again
>> >> in 200 msec.
>> >
>> > I think this should be in wpa_supplicant?
>> >
>> it behaves similarly to WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY, which
>> handled by mac80211, so i thought it would be fine to handle it as
>> well (and this way it can also be used by iw).
>
> WLAN_STATUS_ASSOC_REJECTED_TEMPORARILY is a special case in which the AP
> provides a clear expectation of the association succeeding after the
> specified amount of time. WLAN_STATUS_AP_UNABLE_TO_HANDLE_NEW_STA is
> quite different since it can be used by APs to enforce load balancing.
> It does not sound like a good idea to enforce mac80211 to retry
> association with the same AP unconditionally in this case. I would also
> leave this for wpa_supplicant which has already been optimized to handle
> the load balancing case without this type of extra latency added.
> Disabling this functionality would not be good for many enterprise
> networks.
>
ok.
thanks for the detailed answer.

Eliad.
