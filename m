Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42039 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0JKR0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 13:26:22 -0400
Message-ID: <4CB348B0.3050909@candelatech.com>
Date: Mon, 11 Oct 2010 10:26:08 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	rainbow lum <rainbowlum@gmail.com>
Subject: Re: phyX enumeration conflict
References: <201010082159.59262.chunkeey@googlemail.com>	 <1286698152.3547.4.camel@jlt3.sipsolutions.net>	 <1286698604.3547.7.camel@jlt3.sipsolutions.net>	 <4CB1DE18.9070400@candelatech.com> <1286729035.3547.10.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286729035.3547.10.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2010 09:43 AM, Johannes Berg wrote:
> On Sun, 2010-10-10 at 08:39 -0700, Ben Greear wrote:
>
>> Sorry about that.  If anyone has any example udev magic to do this sort
>> of thing, I'd like to try that out.
>
> This works:
>
> /etc/udev/rules.d/70-phyname.rules:
> -- begin --
> ACTION!="add", GOTO="phyname_end"
> SUBSYSTEM!="ieee80211", GOTO="phyname_end"
>
> # read MAC address
> ENV{MATCHADDR}="$attr{macaddress}"
> ENV{PHYIDX}="$attr{index}"
>
> ENV{MATCHADDR}=="02:00:00:00:00:00", RUN+="/usr/sbin/iw %k set name hwsim0"
>
> LABEL="phyname_end"
> -- end --
>
> Of course, you'd probably want to do something like
> persistent-net-generator etc, but I'll leave that to somebody else.
>
> Just remember you can't actually name it "phy0".

Ok, that part is working.

However, the 'phy0' name doesn't change in
/debug/ath5k/[phy-dev]/ link, so it confuses my tools.

I'm going to see if I can get that fixed somehow...

Thanks,
Ben

>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

