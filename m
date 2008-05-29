Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:15040 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbYE2J6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 05:58:23 -0400
Received: by yw-out-2324.google.com with SMTP id 9so2217325ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 02:58:22 -0700 (PDT)
Message-ID: <1ba2fa240805290258of0559a0t183128d3f9889eae@mail.gmail.com> (sfid-20080529_115826_573977_29D8E9C0)
Date: Thu, 29 May 2008 12:58:21 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 38/43] mac80211: allow disable FAT in specific configurations
Cc: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
In-Reply-To: <1212053870.16917.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
	 <1212053870.16917.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 12:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-05-29 at 16:35 +0800, Zhu Yi wrote:
>> From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>>
>> This patch allows to disable FAT channel in specific configurations.
>>
>> For example the configuration (8, +1), (primary channel 8, extension
>> channel 12) isn't permitted in U.S., but (8, -1), (primary channel 8,
>> extension channel 4) is. When FAT channel configuration is not
>> permitted, FAT channel should be reported as not supported in the
>> capabilities of the HT IE in association request. And sssociation is
>> performed on 20Mhz channel.
>
> Can you explain more in detail the underlying regulatory rules?
>
> It seems to me that (12, -1) would be pretty much the same as (8, +1) as
> far as regulatory is concerned.

Yes, just beacons will flows on 12 and not on 8 so from protocol point
this is important

(But this is not what is written in the comment we comparing (8,-1) to
(8,+1) - Both are FAT channels - Beacons flow on 8 channel)

I'm just thinking about how we should
> express this in the regulatory database where we're not really concerned
> with channels but rather allowed bands.
>
Not sure what do you mean, You always need to keep in mind channel, band tuple.

Tomas
