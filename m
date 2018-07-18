Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:34273 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731492AbeGRRAy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Jul 2018 13:00:54 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Ben Greear <greearb@candelatech.com>,
        Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
        SEDE <s.deronne@televic.com>,
        Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Setting tx retry count in ath10k
In-Reply-To: <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com>
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com> <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de> <8b9713fe-7573-f009-d002-13df73315898@televic.com> <9dd76e58-b514-26f2-2fe9-0c9a7f798054@candelatech.com> <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com>
Date: Wed, 18 Jul 2018 18:21:58 +0200
Message-ID: <877els5xax.fsf@toke.dk> (sfid-20180718_182332_194898_3D950AAC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

> On 07/18/2018 08:50 AM, Jean-Pierre TOSONI wrote:
>> Hi,
>>
>> We made retries configurable in our mac80211+ath9k system, and we ended with 3 counts:
>> 1) short retry count, defaults to 4
>> 2) long retrys count, defauts to 7
>> 3) software retry count, defaults to 30
>> This last one is used separately for each frame in an aggregated frame, since they can be separately acknowledged.
>
> Did you have to change code for #3, and if so, can you share the patch?
>
> I wonder also if retries should be different for different types of
> data. For instance, if someone is using UDP, maybe they don't care so
> much about lost packets and would prefer a lower retry count. Or,
> maybe IP type-of-service could be taken into account and retry frames
> different amounts based on ToS?

For general internet traffic, a retry count of 30 is way too high; that
is up to 120 ms of HOL blocking latency. Better to just drop the packet
at that point.

Ideally, the retry count should be dynamically calculated in units of
time (which would depend on the rate and aggregate size), and also take
queueing time into account. I've been meaning to experiment with this
for minstrel and ath9k, but haven't gotten around to it...

-Toke
