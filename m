Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36741 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbcBWKrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:47:15 -0500
Received: by mail-wm0-f49.google.com with SMTP id g62so215362279wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 02:47:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 23 Feb 2016 12:47:00 +0200
Message-ID: <CA+XVXffpNDf0-5a6cPz0aUrrRfHgKQeu09zDt5eSe1K87m__pw@mail.gmail.com> (sfid-20160223_114719_795608_6A17501F)
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2016 at 12:42 AM, <greearb@candelatech.com> wrote:
>
> From: Ben Greear <greearb@candelatech.com>
>
> ath10k supports VHT on 2.4Ghz band.
> If supplicant and hostapd and radio think
> VHT should be allowed, then kernel should let them
> try.

Removing the 80Mhz check entirely is not the right way to go IMO. The
check is there because there are countries where VHT rates are not
allowed, even on 20MHz channels. We use the fact these countries have
no 80MHz-allowed ranges as a crude regulatory hint to disable VHT
entirely. I'm not sure about the regulatory landscape in these
countries regarding VHT in 2.4GHz, but please don't break compliance
for the 5Ghz use-case.

Arik
