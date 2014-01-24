Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51935 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaAXVds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 16:33:48 -0500
Received: by mail-ie0-f177.google.com with SMTP id at1so3474278iec.22
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jan 2014 13:33:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390572447.4257.43.camel@jlt4.sipsolutions.net>
References: <1390570161-25041-1-git-send-email-janusz.dziedzic@tieto.com>
	<1390572447.4257.43.camel@jlt4.sipsolutions.net>
Date: Fri, 24 Jan 2014 22:33:47 +0100
Message-ID: <CAFED-j=bfkffdtb8PLdbkCwWhXamWY2uiL6iFuAZhz95VLFHJg@mail.gmail.com> (sfid-20140124_223412_869932_AF17F934)
Subject: Re: [PATCH] cfg80211: set preset_chandef after channel switch
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014/1/24 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2014-01-24 at 14:29 +0100, Janusz Dziedzic wrote:
>> Set preset_chandef in channel switch notification.
>> In other case we will have old preset_chandef.
>
> Why would we care? We only keep the preset_chandef thing around because
> hostapd (currently) doesn't pass the frequency to START_AP/the first
> SET_BEACON, but after that this doesn't matter. And when you shut down
> hostapd, and restart it, then it'll set the preset_chandef again through
> explicitly setting the channel.
>
> So in which case would we care? Who would ever STOP_AP and then START_AP
> without a new frequency?
>

We have test code in cfg80211 that using preset_chandef when compare
chandefs when csa.
And after that I see we never change preset_chandef after csa.

>From other side, I could imagine case where we have two VAPs in hostapd.
- first we start first VAPs (eg. channel 36 HT40+)
- next we call CSA (channel 44 HT40+)
- now we start second VAPs - we will get err here because of
preset_chandef (36 HT40+)

BR
Janusz


-- 
Janusz Dziedzic
