Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38785 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1ISPqc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 11:46:32 -0400
Received: by fxe4 with SMTP id 4so4041245fxe.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 08:46:31 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
Date: Mon, 19 Sep 2011 17:46:27 +0200
Message-ID: <36569806.Rgjanm0GiI@alex-1> (sfid-20110919_174635_769341_BA91F565)
In-Reply-To: <1316437459.5995.29.camel@jlt3.sipsolutions.net>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wow. I've been looking for anything regarding HT IBSS in the standard but I 
must confess that I found nothing.
And, I must confess this is more work than I first expected.

Of course I agree to conforming to the standard.
9.13.3.1 and 11.5.1.1 should not be too difficult to implement and that sould 
be done.

I need some help understanding 11.14.2 and 10.3.2.2.2. (11.1.3.4 seems to 
explain them somewhat easier in words)

10.3.2.2.2 tells to adopt the HT Info IE or none if none found ("else null"), 
which means to disable HT.
Then, 11.14.2 says I should use "the most common value" for the extension 
channel, which implies that the HT Info could diverge. This contradicts the 
previous statement...

Let's say we'd adopt the HT Info:
We may join the HT IBSS from a legacy station. Logically, we would disable HT 
even if there are stations that have HT enabled.

We also could use the most common value, again joining from a legacy STA:
We must be constantly watching and saving IEs and calculate percentages for 
them. Over which time window? In larger networks, this could mean several 
beacons until this homogenization happened, especially in changing network 
environments of mobile devices. When the network is using an HT Mode we aren't 
capable of, should we drop HT or even leave the IBSS?

The problem just is that the TSFs are already the same - we have no chance to 
tell which HT configuration is the oder one.

My first patch was going in that direction (no most-recent algorithm, just the 
first HT Info received is adopted), which quite some work, had an 
unpredictable behaviour, needed to change skbs on the fly, etc...

With all this text I'm just trying to say that it would be quite some work and 
maybe the resulting code would still be ... problematic.
As broadcasting always happens in legacy mode, I see no problem having a 
inhomogeneous HT configuration.


If we want homogenization (I'll just call it that way) I'd like to propose my 
idea:
When joining, adopt the most common HT config out there. Save the number of 
stations using that configuration, including itself (variable num_configs).
If no HT config found after scanning, create one, setting num_configs to 0.
When another configuration shows up, compare num_configs to the count of that 
configuration (should be 1 as it is unlikely that more than one config will 
show up within beacon_intervall of typically 100ms).
A station that created its own config will always adopt another one (as 
num_configs == 0), but a station that has already changed won't (num_configs > 
0). 
Constantly update num_configs. Eg having 4 stations seeing each other should 
result in all stations having num_configs = 4. One STA leaving -> num_config = 
3 and so on.
This way we could limit the uncontrolled growth somewhat.

I'll apreciate any comments on this.

Thanks, Alex
