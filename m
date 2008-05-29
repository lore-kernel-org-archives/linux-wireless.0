Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:54800 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbYE2KjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 06:39:13 -0400
Received: by wa-out-1112.google.com with SMTP id j37so3525558waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 03:39:12 -0700 (PDT)
Message-ID: <1ba2fa240805290339y77256fb7r296118775d3e85a8@mail.gmail.com> (sfid-20080529_123917_454583_6E102823)
Date: Thu, 29 May 2008 13:39:12 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 38/43] mac80211: allow disable FAT in specific configurations
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1212055950.16917.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
	 <1212053870.16917.39.camel@johannes.berg>
	 <1ba2fa240805290258of0559a0t183128d3f9889eae@mail.gmail.com>
	 <1212055950.16917.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 1:12 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> > It seems to me that (12, -1) would be pretty much the same as (8, +1) as
>> > far as regulatory is concerned.
>>
>> Yes, just beacons will flows on 12 and not on 8 so from protocol point
>> this is important
>
> Yes, but how is it important to the regulatory regulations?

I didn't say it does.

>
>> (But this is not what is written in the comment we comparing (8,-1) to
>> (8,+1) - Both are FAT channels - Beacons flow on 8 channel)
>>
>> I'm just thinking about how we should
>> > express this in the regulatory database where we're not really concerned
>> > with channels but rather allowed bands.
>> >
>> Not sure what do you mean, You always need to keep in mind channel, band tuple.
>
> Well our database just says: "ok, you're allowed to use 2400-2483.5 MHz,
> at a maximum bandwidth of 40 MHz, if it fits"

OK. Now I understand your question. The word 'band' is a bit
overloaded. Regulatory specs uses
'channel starting frequency' as for 2.4 or 5, 'channel spacing' as for
10 (Narrow) 20 (Wide) 40 (FAT) and
channel set as list of channels for particular reg domain class such as 36, 48.

I'm not aware of the cases that if (Ch1, +1) is on the same band  as
(Ch2, -1) it won't be allowed in some regulatory domain, so your DB
would be OK. Just the protocol doesn't talk in frequencies but in
channels.

When matching against such database you would need to check not only
if you can associate against
 X-Y Mhz (40Mhz) but also if you can fall to  X (20Mhz) or Y(20MHz)
depending if X or Y is the  primary channel.


Thanks
Tomas
