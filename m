Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60604 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbZGXJ2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 05:28:14 -0400
Received: by bwz28 with SMTP id 28so1314817bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jul 2009 02:28:14 -0700 (PDT)
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: wireless-testing regression: iwl3945 scan fails
References: <87k521s2wa.fsf@litku.valot.fi> <87fxcosron.fsf@litku.valot.fi>
	<1248278121.17896.2728.camel@rc-desk>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 24 Jul 2009 12:28:10 +0300
In-Reply-To: <1248278121.17896.2728.camel@rc-desk> (reinette chatre's message of "Wed\, 22 Jul 2009 08\:55\:21 -0700")
Message-ID: <874ot2sa51.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> Hi Kalle,

Hi Reinette,

>> I have looked at this now a bit and I don't think this is an iwl3945
>> problem. Scanning seems to stall in some situations and iwl3945 doesn't
>> even receive the scan command. 
>
> The patches we sent recently did undergo testing under various scenarios
> using wpa_supplicant. We have not done this testing after the
> 2.6.31-rc3-wl merge (yesterday) though. I just did a quick test on my
> 3945 using iwconfig to associate and it was able to do so on A and G
> bands. Looks like I need to do some wpa_supplicant testing.

This odd problem might happen only in my setup.

>> Also I have been able to reproduce the problem once with iw. For some
>> strange reason I have had to reboot my laptop to reproduce this,
>> unloading all wireless related modules (expect rfkill which I can't
>> unload due to dependencies) is not enough.
>
> Are you saying that this problem occurs always with wpa_supplicant and
> sometimes with iw?

I did some more testing and I can now reproduce this with iw as well. I
just need to reboot my laptop to reproduce it. I'll debug this more on a
rainy day.

-- 
Kalle Valo
