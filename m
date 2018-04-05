Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:42897 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbeDEPsy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 11:48:54 -0400
Received: by mail-oi0-f47.google.com with SMTP id l190-v6so22996181oig.9
        for <linux-wireless@vger.kernel.org>; Thu, 05 Apr 2018 08:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAOGAQep2Yj62JDAY0qGwXFYohsje6fuu57Ss4U7+coygBe7u0A@mail.gmail.com>
 <1522917309.7140.2.camel@sipsolutions.net>
In-Reply-To: <1522917309.7140.2.camel@sipsolutions.net>
From: Bjoern Johansson <bjoernj@google.com>
Date: Thu, 05 Apr 2018 15:48:42 +0000
Message-ID: <CAL6gjmVQgZNeRKC4Gj5-bdOKgn1Fs+wnrg+1TBKkeHJpygNkyg@mail.gmail.com> (sfid-20180405_174858_088092_E57F3859)
Subject: Re: PATCH [1/1]: wireless: mac80211_hwsim: support/ignore power state changes
To: johannes@sipsolutions.net
Cc: Roman Kiryanov <rkir@google.com>, linux-wireless@vger.kernel.org,
        gregkh@google.com, Bo Hu <bohu@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 5, 2018 at 1:35 AM Johannes Berg <johannes@sipsolutions.net>
wrote:


> > indicate power state support. This in turn causes VTS failures because
> > the WiFi HAL can't enable power saving mode. The remaining code is
> > just there to deal with the incoming state change request.

> What's VTS?

> johannes

That message wasn't really intended as a commit message but an internal
clarification of why we needed this fix but I'll try to give an
explanation. VTS is the Android Vendor Test Suite (
https://source.android.com/compatibility/vts/). It's one of the test suites
required by Google to be able to put the Play Store on an Android device.
The tests verify that the device and APIs behave in the expected,
documented way (hopefully) without bugs or unexpected behavior. One of the
tests requires that WiFi can be placed in power saving mode to improve
battery life. Battery life is of course not really an issue for an emulator
but the tests cover other devices where this is important.

Regards,
Bjoern
