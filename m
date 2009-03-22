Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46711 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705AbZCVU3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 16:29:23 -0400
Received: by fxm2 with SMTP id 2so1541342fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 13:29:20 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
References: <20090322195619.26460.48292.stgit@tikku>
	<1237752930.19647.5.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 22 Mar 2009 22:29:18 +0200
In-Reply-To: <1237752930.19647.5.camel@johannes.local> (Johannes Berg's message of "Sun\, 22 Mar 2009 21\:15\:30 +0100")
Message-ID: <87hc1lfgip.fsf@litku.valot.fi> (sfid-20090322_212926_840887_0983C0A4)
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
> I'm getting bored saying this again and again ;) Looks good to me.

Sorry, I _had_ to fix the ieee80211_beacon_loss() interface ;)

Oh yeah, forgot to mention that I did some quick measurements and with
these patches I was able get 25% system power consumption decrease
with stlc45xx on Nokia N800 in the wlan idle case (associated to the
AP, no data traffic, display off). I'll do more measurements later.

-- 
Kalle Valo
