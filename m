Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:47413 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbZI1TWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 15:22:39 -0400
Received: by ewy7 with SMTP id 7so4749572ewy.17
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 12:22:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254164123.3151.10.camel@johannes.local>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <29413.68229.qm@web28307.mail.ukl.yahoo.com>
	 <1254164123.3151.10.camel@johannes.local>
Date: Mon, 28 Sep 2009 20:22:41 +0100
Message-ID: <3ace41890909281222o5c345333y858e097166146577@mail.gmail.com>
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Albert Herranz <albert_herranz@yahoo.es>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2009 at 7:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-09-28 at 11:04 -0700, Albert Herranz wrote:
>
>> [   15.624121] wlan1: starting authentication with 00:12:17:15:e7:79
>> [   15.630717] wlan1: deauthenticating from 00:12:17:15:e7:79 by local choice (reason=3)
>> [   15.645151] wlan1: starting authentication with 00:12:17:15:e7:79
>
>> I'm using wpa_supplicant _without_ NM.
>
> Yeah, I since figured out why that's happening, and it's not so strange
> after all. Shouldn't be a big deal. At least I see you're getting
> connected too now.
>
> johannes
>

Yes, it looks like it is similar/same as my situation - the difference
being that I had wpa_supplicant talking to NM via D-bus and get the
extra user-prompt (not anymore with the latest patches) when the first
try from wpa_supplicant fails. When wpa_supplicant is run without -u
(the d-bus/NM option) it probably tries a bit harder on its own?

Hin-Tak
