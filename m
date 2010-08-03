Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40889 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab0HCMdD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 08:33:03 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi connection problems
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	<1279917523.10769.1.camel@wwguy-huron>
	<1280135867.3693.5.camel@jlt3.sipsolutions.net>
	<87mxtd5xlq.fsf@sycorax.lbl.gov>
	<1280212629.19098.0.camel@jlt3.sipsolutions.net>
	<87bp9l6f4k.fsf@sycorax.lbl.gov>
	<1280746705.3923.11.camel@jlt3.sipsolutions.net>
	<878w4pvx5e.fsf@sycorax.lbl.gov>
	<1280766201.24503.0.camel@jlt3.sipsolutions.net>
	<87aap4z70b.fsf@sycorax.lbl.gov>
	<1280817596.3874.0.camel@jlt3.sipsolutions.net>
Date: Tue, 03 Aug 2010 05:32:56 -0700
In-Reply-To: <1280817596.3874.0.camel@jlt3.sipsolutions.net> (message from
	Johannes Berg on Tue, 03 Aug 2010 08:39:56 +0200)
Message-ID: <87tynbnafb.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Mon, 2010-08-02 at 20:53 -0700, Alex Romosan wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>> 
>> > On Mon, 2010-08-02 at 08:42 -0700, Alex Romosan wrote:
>> >
>> >> so i think i finally managed to track this down. doing a git bisect i
>> >> get:
>> >> 
>> >> 3474ad635db371b0d8d0ee40086f15d223d5b6a4 is the first bad commit
>> >> commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4
>> >> Author: Johannes Berg <johannes.berg@intel.com>
>> >> Date:   Thu Apr 29 04:43:05 2010 -0700
>> >> 
>> >>     iwlwifi: apply filter flags directly
>> >
>> >> ...
>> >
>> > Thanks. I'll take a closer look tomorrow, am about to leave for today.
>> 
>> so i looked a little bit more at what happened. the only difference
>> between the non working and the working version is a call to
>> iwlcore_commit_rxon(priv) on line 1327 of iwl-core.c (the version in
>> 2.6.35). if i comment that line out then i can connect to the access
>> point without problems. hope this helps.
>
> Yes, thank you, but it's very strange. But it's probably ok, let's
> remove the call then, it wasn't there before. Want to post a patch
> yourself?

that's ok, i don't really know what's going on, i only noticed the
difference between the two versions. you post the patch.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
