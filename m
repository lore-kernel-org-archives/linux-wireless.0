Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:36616 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab0BFS0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 13:26:31 -0500
Received: by ewy28 with SMTP id 28so1140801ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2010 10:26:29 -0800 (PST)
Message-ID: <4B6DB44E.7030201@gmail.com>
Date: Sat, 06 Feb 2010 18:26:22 +0000
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, holgerschurig@gmail.com,
	sameo@linux.intel.com, dcbw@redhat.com
Subject: Re: [RFC 0/2] cfg80211: Retrieve missing BSS info after connect
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com> <1265464303.4041.24.camel@johannes.local>
In-Reply-To: <1265464303.4041.24.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2010-02-06 at 13:20 +0000, David Kilroy wrote:
>> This patchset attempts to address the issue where a driver that uses
>> the cfg80211 connect operation connects to an AP before the scan result
>> for the AP is available. This triggers a WARN_ON in sme.c, and the
>> connection fails.
> 
> With technical comments out of the way (see other emails) I guess I want
> to know whether this really makes sense.
> 
> Yes, we definitely need the right BSS struct when the driver signals
> that it connected, but we also need the same information when it roamed
> for example. Does it really make sense to scan after the fact, instead
> of asking the driver to provide the information? This is a genuine
> question -- I can see value in this if more than one driver needs it,
> but if the devices can just provide BSS information right before the
> connected call that would be a lot simpler here.

Thanks for the feedback. Like I said, the main point of posting was to
see if this logic helped libertas in any way. Sounds like it doesn't, so
I won't push this for now. When I get round to looking at orinoco again
I'll see if I can handle this within the driver. If not I'll address the
issues you've raised.

I don't think orinoco can provide the BSS info without explicitly doing
the scan (whether internally or via cfg80211). Even if I could get it to
work for the firmware version I have, there's no guarantee that it'll
work for the other supported firmware types (that I don't have).



Dave.
