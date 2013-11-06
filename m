Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:40776 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756504Ab3KFMIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 07:08:51 -0500
Received: by mail-la0-f41.google.com with SMTP id ea20so2287894lab.14
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 04:08:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1383732704.14307.18.camel@jlt4.sipsolutions.net>
References: <1383659329-11023-1-git-send-email-janusz.dziedzic@tieto.com>
	<1383659329-11023-5-git-send-email-janusz.dziedzic@tieto.com>
	<1383732704.14307.18.camel@jlt4.sipsolutions.net>
Date: Wed, 6 Nov 2013 13:08:49 +0100
Message-ID: <CALhHN=rGxOcLixBXzN-Azq4cQdriWD2VeAy6M4k8B8KqSDPaZA@mail.gmail.com> (sfid-20131106_130856_038566_AE2ADC9F)
Subject: Re: [PATCH v2 5/5] cfg80211: allow beaconing after DFS CAC
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 November 2013 11:11, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2013-11-05 at 14:48 +0100, Janusz Dziedzic wrote:
>> After going throught the Channel Availability Check (CAC)
>> required by DFS enable beaconing. Channels that have
>> gone through a CAC will be in the NL80211_DFS_AVAILABLE
>> state. Without this change APs don't start beaconing
>> after a successful CAC.
>> Change also cfg80211_secondary_chans_ok() where handle
>> prohibited_flags as prohibited.
>
> I can't really understand this commit message - can you please rephrase
> it?
>

Allow beaconing after we pass Channel Availability Check (CAC).
Allow non-DFS and DFS channels mix. All DFS channels have to
be in NL80211_DFS_AVAILABLE state (have to pass CAC).

BR
Janusz
