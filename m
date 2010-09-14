Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47632 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0INWPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 18:15:38 -0400
Received: by iwn5 with SMTP id 5so6410800iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Sep 2010 15:15:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87mxrk5610.fsf@purkki.adurom.net>
References: <1284474071-8404-1-git-send-email-lrodriguez@atheros.com> <87mxrk5610.fsf@purkki.adurom.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 14 Sep 2010 15:15:18 -0700
Message-ID: <AANLkTikQx3RZcWPEjktBb0gkTLtMfCxXMma6h=9u+UBr@mail.gmail.com>
Subject: Re: [PATCH 08/10] mac80211: send last 3/5 probe requests as unicast
To: Kalle Valo <kvalo@adurom.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <amod.bodas@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 14, 2010 at 3:12 PM, Kalle Valo <kvalo@adurom.com> wrote:
> "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
>
>> We need to do this since the beacon monitor does not
>> push back the connection monitor by design so even if we
>> are getting beacons from these type of APs our connection
>> monitor currently relies heavily on the way the probe
>> requests are received on the AP. An example of an AP
>> affected by this is the Nexus One, but this has also been
>> observed with random APs.
>>
>> We can probably optimize this later by using null funcs
>> instead of probe requests.
>
> Beginning of this year I sent patches to use null funcs. Unfortunately
> I had to drop them due to time constraints.
>
> Also a major power consumption imporovement from using null func
> frames is that we don't have to trigger dynamic power save timer
> during the poll. Just send the frame with PSM bit set, wait for ack
> and go immeaditely back to sleep. So instead of having radios enabled
> for example 100 ms per frame, we can do it in just 1 ms.

Neat, do you have those patches dug up in a directory somewhere or
should I dig the archives?

  Luis
