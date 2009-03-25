Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:17483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbZCYJBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 05:01:46 -0400
Received: by fg-out-1718.google.com with SMTP id e12so814262fga.17
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 02:01:43 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
References: <20090322195619.26460.48292.stgit@tikku>
	<1237900276.4320.86.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Mar 2009 11:01:41 +0200
In-Reply-To: <1237900276.4320.86.camel@johannes.local> (Johannes Berg's message of "Tue\, 24 Mar 2009 14\:11\:16 +0100")
Message-ID: <87iqly0ydm.fsf@litku.valot.fi> (sfid-20090325_100149_523927_5AA01110)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sun, 2009-03-22 at 21:56 +0200, Kalle Valo wrote:
>> Here's my proposal how to implement beacon filtering in mac80211. The
>> basic idea is simple, the driver enables filtering whenever mac80211
>> enables power save and the driver calls ieee80211_beacon_loss()
>> whenever hardware informs about beacon loss.
>> 
>> I have tested this with stlc45xx (with beacon filtering) and iwl3945
>> (without beacon filtering) and based on simple tests this seems to
>> work. For reference I'll send the stlc45xx patch as a followup.
>
> Something I've been wondering about now is how to populate the exclude
> list (which would probably be smarter as an include list, but anyway).

Yeah, an include list would be a lot better.

> This actually affects the entire stack, take for example the BSS load
> element, which could potentially change frequently. Unless
> wpa_supplicant would want to use it for roaming, we could ignore it.
>
> However, how do we know which elements the various pieces of the stack
> need?

I think we can just start with a fixed list and start improving that.
Or did you think of creating the list dynamically?

-- 
Kalle Valo
