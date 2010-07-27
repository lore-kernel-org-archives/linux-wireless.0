Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:47601 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452Ab0G0E7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 00:59:19 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi connection problems
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	<1279917523.10769.1.camel@wwguy-huron>
	<1280135867.3693.5.camel@jlt3.sipsolutions.net>
Date: Mon, 26 Jul 2010 21:59:13 -0700
In-Reply-To: <1280135867.3693.5.camel@jlt3.sipsolutions.net> (message from
	Johannes Berg on Mon, 26 Jul 2010 11:17:47 +0200)
Message-ID: <87mxtd5xlq.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2010-07-23 at 13:38 -0700, Guy, Wey-Yi wrote:
>> Hi Johannes,
>> 
>> On Fri, 2010-07-23 at 13:14 -0700, Alex Romosan wrote:
>> > since kernel 2.6.35-rc3 (i didn't try 1 or 2) i haven't been able to
>> > connect to a hidden wireless access point using the iwlwifi driver. i
>> > can connect to open ones though (the ones that broadcast their name).
>> > 2.6.34 worked without any problems. any ideas?
>> > 
>> > this is with the driver in the standard linux kernel (2.6.35-rc6 is the
>> > latest one i tried).
>> 
>> Do you aware any changes?
>
> Nope, and it works fine here on wireless-testing.

any ideas on how i can debug this? i tried to do a git-bisect but i
didn't get anywhere. i have the driver compiled in the kernel if that
makes any difference. as i played with the later kernels (after 2.6.34)
i discovered that if kept bringing the interface down and then up again
eventually i would get "cfg80211: Calling CRDA to update world
regulatory domain" the antenna light on the laptop (i have a thinkpad
t61) would go off and then at the next ifup the driver connected. looks
like some kind of reset/initialization problem to me.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
