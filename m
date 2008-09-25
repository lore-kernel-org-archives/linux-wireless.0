Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:47583 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbYIYLup (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 07:50:45 -0400
Received: by fg-out-1718.google.com with SMTP id 19so276653fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 04:50:42 -0700 (PDT)
Message-ID: <1ba2fa240809250450x319d21bbr4e0fb072e47c60db@mail.gmail.com> (sfid-20080925_135049_340812_07299804)
Date: Thu, 25 Sep 2008 14:50:42 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
Cc: "Zhu Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <1222341663.10563.67.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
	 <1ba2fa240809250404i7e2404e7o3531ea1a889afb35@mail.gmail.com>
	 <1222341663.10563.67.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Didn't see it on iwl3945, but I only looked for the function that the
> sysfs code calls and didn't find any other callsite, might well be a
> different way.

Might be case for 3945 I'm less involved in that one.


>
>> except log level
>> which I want always visible and has proven to be most useful.
>
> Yeah, indeed, though it seems to be notably lacking printing out the
> physical addresses and the ringbuffer entries. But that's just the thing
> I was looking for yesterday when debugging the corruption issue.

I should have patches for that somewhere got lost somewhere in
selective merging, will bring them forward.

>> > generic option to disable hardware crypto in _mac80211_ rather than each
>> > driver because this is actually genuinely useful if you want to monitor
>> > frames at the same time.
>
>> This is good point also disabling and enabling hw scan I would like to
>> remove from module params.
>
> That would be doable via mac80211 too, though that is a much more debug
> option than disabling hardware crypto, I see disabling hw crypto as much
> more useful than disabling hw scan.

I would probably remove the option of disabling hw scan at all, think
it's stable enough.
Tomas
