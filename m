Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:45746 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075AbaIQTBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 15:01:49 -0400
Received: by mail-la0-f54.google.com with SMTP id ge10so2505618lab.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2014 12:01:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <21529.10109.308613.563543@gargle.gargle.HOWL>
References: <1410928422-25587-1-git-send-email-sujith@msujith.org>
	<21529.5141.845629.86918@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B523034@hasmsx107.ger.corp.intel.com>
	<21529.8110.26388.664223@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B5230C9@hasmsx107.ger.corp.intel.com>
	<21529.9155.323515.987489@gargle.gargle.HOWL>
	<0BA3FCBA62E2DC44AF3030971E174FB31B52311D@hasmsx107.ger.corp.intel.com>
	<21529.10109.308613.563543@gargle.gargle.HOWL>
Date: Wed, 17 Sep 2014 22:01:47 +0300
Message-ID: <CANUX_P3hdFeCPmqHCdP8JKwqvUUnjgp3SNy1GQDrQd0bG+WKng@mail.gmail.com> (sfid-20140917_210210_587479_C51C132B)
Subject: Re: [PATCH] mac80211: Call mgd_prepare_tx before deauthentication
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 17, 2014 at 9:17 AM, Sujith Manoharan <sujith@msujith.org> wrote:
> Grumbach, Emmanuel wrote:
>> It can wait until a context switch will occur in ath9k - you should switch
>> from time to time anyway to avoid starvation, and this is not under the radar
>> of mac80211.
>
> But mac80211 doesn't wait for a switch to happen. It removes the BSS and station
> info immediately after sending the deauth frame to the driver and the driver doesn't
> get a chance to process the pending frames for the other context. I think
> this race could be avoided by making sure the driver switches to the
> required context before sending deauth.
>

mac80211 will not wait until the context switch happen specifically,
but if you can wait
in the driver in the flush() callback until the deauth is being sent -
whatever you need to
happen to have that done, context switch, TX queues to move etc... -
then you should be good?
IIRC, mac80211 sends the deauth to the driver and then calls flush() -
only then, it'll remove the
contexts.

So I guess that we agree - the solution for you I guess is to wait
until you have context switch
in the flush() callback.
