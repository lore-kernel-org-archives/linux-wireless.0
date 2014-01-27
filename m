Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37478 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbaA0JhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jan 2014 04:37:25 -0500
Received: by mail-ie0-f177.google.com with SMTP id at1so5279906iec.8
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jan 2014 01:37:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390810765.4251.0.camel@jlt4.sipsolutions.net>
References: <1390566001-9698-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEc94pTAMXWPYeWhu7o_YLEnD1_9O035-+YXYiR0Uij28w@mail.gmail.com>
	<1390810765.4251.0.camel@jlt4.sipsolutions.net>
Date: Mon, 27 Jan 2014 11:37:24 +0200
Message-ID: <CAB3XZEczgVTALA3_4hSBikJs=TXOhHHTHSLzmuU3MGot-hG+1g@mail.gmail.com> (sfid-20140127_103734_721830_7189AFA6)
Subject: Re: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute confusion
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 27, 2014 at 10:19 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2014-01-26 at 10:56 +0200, Eliad Peller wrote:
>
>> this means that min-rssi-only sched scan request will be seen as
>> req->n_match_sets = 1 with empty SSID?
>
> Yes.
>
>> i don't think that's desirable (at least the current documentation
>> assumes n_match_sets=0 for this case).
>
> I don't think that's true? I looked at the drivers that use this and
> they all skip empty SSIDs, except the one that I fixed.
>
ok. so at least fix the documentation? :)

Eliad.
