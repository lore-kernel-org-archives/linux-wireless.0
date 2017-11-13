Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:48404 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751268AbdKMKJt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 05:09:49 -0500
Message-ID: <1510567783.30497.33.camel@sipsolutions.net> (sfid-20171113_110956_757693_3342F5BA)
Subject: Re: Setting single rate in ath10k broken by "reject/clear user rate
 mask if not usable"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>, kirtika@google.com
Date: Mon, 13 Nov 2017 11:09:43 +0100
In-Reply-To: <a1adb2ea-44c4-67ae-1044-08c4dc16bb9a@candelatech.com>
References: <13895fa0-3685-dd2b-583d-2d6469d23cfe@candelatech.com>
         <1507708948.1998.15.camel@sipsolutions.net>
         <2c293255-aa79-75a0-1c28-994f864cddf4@candelatech.com>
         <1508312033.2674.9.camel@sipsolutions.net>
         <2ad42671-59c4-80ed-4bca-f874eb53d653@candelatech.com>
         <8c2e0e98-f3f4-6e0c-1bf0-43dfa6e97275@rempel-privat.de>
         <1508358869.2674.55.camel@sipsolutions.net>
         <9791c86a-a15f-4c99-ab84-ce00b242d70f@candelatech.com>
         <1508360527.2674.61.camel@sipsolutions.net>
         <0bfb289d-a9fa-03d9-f9c7-cc0d01b0bd43@candelatech.com>
         <1508944670.2421.49.camel@sipsolutions.net>
         <db23762d-3e65-7707-ca78-ad7e7bc7dfa6@candelatech.com>
         <1509135311.2283.12.camel@sipsolutions.net>
         <a1adb2ea-44c4-67ae-1044-08c4dc16bb9a@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-10-27 at 13:41 -0700, Ben Greear wrote:

> ath10k ignores the tx rateset pretty much entirely when sending management
> frames, so even if you set the tx rateset to have only VHT MCS 8,
> management frames are still sent with legacy ratesets.

So that's a driver bug.

> My end goal about this part is to be able to configure a single tx rate
> and have that be allowed again, at least with ath10k.
> 
> Maybe a new flag for drivers like ath10k that at least somewhat ignore
> the tx-rateset for management frames, and this flag would allow us to
> bypass the cannot-set-single-rate check?

What? No, I'm not going to put a driver bug into the API like that!

johannes
