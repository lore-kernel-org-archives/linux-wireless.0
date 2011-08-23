Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51911 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1HWPup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:50:45 -0400
Received: by gya6 with SMTP id 6so187478gya.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 08:50:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ee2d58eb0311dee326623ee17d872926@secure.sipsolutions.net>
References: <1314099467-20464-1-git-send-email-eliad@wizery.com>
	<1314099467-20464-2-git-send-email-eliad@wizery.com>
	<ee2d58eb0311dee326623ee17d872926@secure.sipsolutions.net>
Date: Tue, 23 Aug 2011 18:50:44 +0300
Message-ID: <CAB3XZEcqwZxYYEcVrHcnCwBBS-z505yOoy2y8PjGxRSsnZp8Uw@mail.gmail.com> (sfid-20110823_175048_811000_C40A05E7)
Subject: Re: [PATCH 2/2] mac80211: add uapsd_queues and max_sp params fields
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 23, 2011 at 6:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 23 Aug 2011 14:37:47 +0300, Eliad Peller wrote:
>>
>> Add uapsd_queues and max_sp fields to ieee80211_sta.
>> These fields might be needed by low-level drivers in
>> order to configure the AP.
>
> So your device has uapsd built-in? What if a device doesn't -- do we need
> feature advertisement for this?
>
basically these params come from the supplicant on sta addition.
if the ap wasn't configured with uapsd, there won't be
NL80211_ATTR_STA_WME attribute, and these fields will be 0.

devices with no uapsd support will ignore these fields.
am i missing something?

(i'll send the supplicant patches later)

Eliad.
