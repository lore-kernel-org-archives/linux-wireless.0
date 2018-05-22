Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:37586 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751575AbeEVVGo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 17:06:44 -0400
Received: by mail-ot0-f196.google.com with SMTP id 77-v6so22692888otd.4
        for <linux-wireless@vger.kernel.org>; Tue, 22 May 2018 14:06:44 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH] cfg80211: Fix support for flushing old scan results
From: Denis Kenzior <denkenz@gmail.com>
In-Reply-To: <1527022332.6787.51.camel@sipsolutions.net>
Date: Tue, 22 May 2018 16:00:47 -0500
Cc: Tim Kourt <tim.a.kourt@linux.intel.com>,
        linux-wireless@vger.kernel.org
Message-Id: <D2E91785-58E3-46FA-94B9-879E621D5049@gmail.com> (sfid-20180522_230648_621431_C04F3518)
References: <20180511164835.40161-1-tim.a.kourt@linux.intel.com>
 <1526631206.3805.1.camel@sipsolutions.net>
 <d12d4d4d-25d6-3cd0-1399-27de09c7f8c5@gmail.com>
 <1527019967.6787.45.camel@sipsolutions.net>
 <114ca20b-7b20-7a3e-75bd-8c336d26b9c0@gmail.com>
 <1527021608.6787.47.camel@sipsolutions.net>
 <2036335b-ca8f-d63f-8142-11d81cfb9a22@gmail.com>
 <1527022332.6787.51.camel@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> On May 22, 2018, at 3:52 PM, Johannes Berg <johannes@sipsolutions.net> =
wrote:
>=20
> On Tue, 2018-05-22 at 15:49 -0500, Denis Kenzior wrote:
>=20
>> Okay, so we need to use NL80211_BSS_PRESP_DATA if we want to filter =
out=20
>> scan results that are coming from beacons, right?
>=20
> You could do that, yes. In non-hidden cases you get the beacon/probe
> response data combined, in hidden cases you may get the beacon data
> separately and the (second, third, ...) entry with probe response data
> will come with beacon data too.
>=20
> I'm not really sure what value that would have though. In general, you
> might want to not display hidden SSIDs as such or at all in the UI.

Right.  The intent here is to handle auto-connect to hidden networks.  =
So if we have provisioned a network that is hidden, and we see hidden =
networks via beacons, we want to scan for our provisioned hidden SSIDs =
and only get the probe response results.

>=20
>> So what's the practical use of the flush flag?  Or is that something=20=

>> that was meant to be 'for-testing-only'?
>=20
> I think you misunderstand? The value is that it ensures that nothing =
is
> present in the list that was received *before* the scan.
>=20

We misunderstood how it was supposed to work, but no, I get how things =
work now.  I=E2=80=99m just curious what other potential uses this flag =
might have.

Regards,
-Denis
