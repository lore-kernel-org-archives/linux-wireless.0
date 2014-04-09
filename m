Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:59146 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaDIGZM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 02:25:12 -0400
Received: by mail-wi0-f171.google.com with SMTP id q5so8298207wiv.4
        for <linux-wireless@vger.kernel.org>; Tue, 08 Apr 2014 23:25:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53441D95.9000409@candelatech.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<5341F1A9.2030202@candelatech.com>
	<CA+BoTQndgEB7X-RUPPkxdjnp96LJzbv6=Q9K4XTTrky-QwE4Ww@mail.gmail.com>
	<53435F89.60500@candelatech.com>
	<CA+BoTQk6G4-h8HQENbK9snrXo6j6FW4D+07XKZMEEuvWiu03ww@mail.gmail.com>
	<53441D95.9000409@candelatech.com>
Date: Wed, 9 Apr 2014 08:25:11 +0200
Message-ID: <CA+BoTQkCDiUiV7dsg-myOZXQEB=B7JHH8NWm5BHsp1xExjLkSA@mail.gmail.com> (sfid-20140409_082519_063039_4236BC06)
Subject: Re: [RFT 0/4] ath10k: fix flushing and tx stalls
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 April 2014 18:02, Ben Greear <greearb@candelatech.com> wrote:
> On 04/07/2014 10:51 PM, Michal Kazior wrote:
>> On 8 April 2014 04:31, Ben Greear <greearb@candelatech.com> wrote:
>>> On 04/07/2014 02:11 AM, Michal Kazior wrote:
>>>
>>>> These logs are not enough. I'd love to see traces for this to see what
>>>> frames are actually submitted and when tx credits are replenished.
>>>>
>>>> I also wonder if this can be somehow related to your FW changes to
>>>> allow connecting multiple client virtual interfaces to a single AP?
>>>
>>>
>>> I think it is unlikely due to my firmware changes...little of that touched
>>> the handling of management frames.  It might very well be a basic problem in
>>> either the firmware or driver when using multiple station VIFS.  I think
>>> that
>>> aside from my testing that code has not been used much.
>>>
>>> Note my followup email that problems started with patch 3/4...not sure you
>>> saw that one or not.  I saw similar failure to associate & get DHCP (and
>>> slow/hung user-space) without the kernel error logs.
>>
>> I did get that mail. It's just that it makes little sense. Patch 3/4
>> simply extends ath10k_flush() to wait for management frames. It
>> shouldn't change behaviour of tx credit starvation which appears to be
>> the case in the logs you provided.
>
> Maybe this causes unexpected waits (under lock) that in turn causes other
> vifs trying to come up at the same time to time out?

Hm... Most stuff is configured while holding conf_mutex and is
completed while it is held. The exception are beacons and mgmt tx.
Perhaps waiting for mgmt tx in ath10k_flush() doesn't interleave mgmt
tx with other commands and ends up starving tx credit sooner.

I'm planning to submit RFTv2 later today with a few fixes.


> It seems easily reproducible, so let me know what sort of logging/tracing
> you would like to see (and how to enable it if it is not trivial)
> and I'll reproduce it and send you the logs.

Additional kernel config:

CONFIG_ATH10K_DEBUG=y
CONFIG_ATH10K_DEBUGFS=y
CONFIG_ATH10K_TRACING=y
CONFIG_MAC80211_MESSAGE_TRACING=y

This probably requires this to be set first:

CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y

(it's in Kernel Hacking)

Once you have this you can use trace-cmd command to gathers logs:

  trace-cmd record -e mac80211 -e cfg80211 -e ath10k

And then perform whatever tortures on ath10k you wish.

This creates trace.dat in your current directory. The file can get
pretty heavy and it might not fit into an email so we might need to
transfer it "out of band" somehow.

If you use wpa_supplicant/hostapd you can pass -T argument to those to
get all their messages into tracing as markers. This way you're able
to get unified logs in one file with correct chronological order.


Michał
