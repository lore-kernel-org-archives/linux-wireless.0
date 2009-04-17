Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:34509 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759523AbZDQHcQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 03:32:16 -0400
Received: by fxm2 with SMTP id 2so760466fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 17 Apr 2009 00:32:14 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: roaming/scan/beacon filter braindump
References: <1239891420.8338.10.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 17 Apr 2009 10:32:12 +0300
In-Reply-To: <1239891420.8338.10.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 16\:17\:00 +0200")
Message-ID: <87ljpzhh1f.fsf@litku.valot.fi> (sfid-20090417_093222_695267_417D14EC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Now, you may want to roam before losing the connection completely while
> there's no traffic, so you have a good connection for when there's
> traffic again. In order to do that, you need to watch the beacon signal
> strength, and inform userspace (the roaming algorithm) of changes.
> However, this isn't via the scanning -- it's via the station info.
>
> So:
>  * need method for userspace to register what kind of signal changes it
>    is interested in (low/high threshold?)
>  * need signal change event for the AP station as multicast

And with hardware which support beacon filtering we want the hardware to
notify about signal changes. This is needed to avoid unnecessary cpu
wakeups.

-- 
Kalle Valo
