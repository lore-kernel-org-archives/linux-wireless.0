Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55175 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1K0KmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Nov 2011 05:42:18 -0500
Received: by wwo28 with SMTP id 28so5461805wwo.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2011 02:42:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1322386685.4044.8.camel@jlt3.sipsolutions.net>
References: <1322378621-14647-1-git-send-email-mar.kolya@gmail.com>
	<1322378621-14647-2-git-send-email-mar.kolya@gmail.com>
	<1322386685.4044.8.camel@jlt3.sipsolutions.net>
Date: Sun, 27 Nov 2011 12:42:17 +0200
Message-ID: <CANUX_P0UEnZLiDfk-aSnd3e_=v_gsZYV9BCtgdcPODLTaYkV8w@mail.gmail.com> (sfid-20111127_114222_396323_FFD8C360)
Subject: Re: [PATCH] mac80211: fix race condition caused by late addBA resp
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nikolay Martynov <mar.kolya@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 27, 2011 at 11:38, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sun, 2011-11-27 at 02:23 -0500, Nikolay Martynov wrote:
>> Currently if addBA respones comes in just after addba_resp_timer has
>> expired we still accept addBA response and (try to) open agg
>> session. This patch fixes this race condition and makes sure that if
>> addba_resp_timer has expired addBA response is not longer accepted and
>> we do not try to open half-closed session.
>

I just sent a patch to Norbert that looks a bit the same.
I prefer yours though, as Johannes said in the other thread, it checks
the stop condition better.
I also saw a few other holes in the state machine. Basically we don't
clear flags: i.e. I didn't see where we clear the driver ready flag.
This is the kind of things that can lead to weird stuff.
