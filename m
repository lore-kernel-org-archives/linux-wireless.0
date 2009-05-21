Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:52310 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbZEUOKl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 10:10:41 -0400
Received: by bwz22 with SMTP id 22so1036814bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 21 May 2009 07:10:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242914188.4212.7.camel@johannes.local>
References: <1242872340-27417-1-git-send-email-yi.zhu@intel.com>
	<1242872340-27417-2-git-send-email-yi.zhu@intel.com> <f6ca9fed0905210012t2b494db5w3169ef2e8db2b04b@mail.gmail.com>
	<1242889781.24825.611.camel@debian> <1242897719.5471.1.camel@johannes.local>
	<20090521133839.GA2744@tuxdriver.com> <1242914188.4212.7.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 21 May 2009 16:10:22 +0200
Message-ID: <69e28c910905210710h722a09a1g5b68dad9cf684f5f@mail.gmail.com>
Subject: Re: [PATCH 1/2] wireless: move some utility functions from mac80211
	to cfg80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>, drago01 <drago01@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 21, 2009 at 3:56 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-05-21 at 09:38 -0400, John W. Linville wrote:
>> On Thu, May 21, 2009 at 11:21:59AM +0200, Johannes Berg wrote:
>> > On Thu, 2009-05-21 at 15:09 +0800, Zhu Yi wrote:
>> >
>> > > > Isn't lib80211 a better place for those ?
>> > > > Its purpose is sharing code between fullmac and softmac drivers.
>> > >
>> > > These functions are moved from mac80211 which currently doesn't link
>> > > with lib80211. Johannes might have more to comment.
>> >
>> > Yeah, lib80211's stated purpose is to share code, but on the other hand
>> > code that mac80211 and fullmac drivers may need seems better suited in
>> > cfg80211 since lib80211 also ships a large code bit of crypto routines
>> > etc. that are just useless for this and mac80211.
>>
>> The crypto stuff is mostly in separate modules.
>>
>> I would rather see these in lib80211, but I'll work that out myself.
>
> Heh. And I asked them to put it here... Then again, lib80211_crypt_*
> only exists for hostap and ipw2x00, so maybe we should separate that out
> into a separate lib80211_crypt module? That would leave lib80211 only
> with print_ssid, of course...

crypt80211, anyone? (Print_ssid is clearly not enough to consider
maintaining an extra module.)

>
> Basically I still think having lib80211 is pretty much pointless since
> all future fullmac drivers and mac80211 all need to use cfg80211.
>
> johannes
>
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
