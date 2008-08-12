Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:4424 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbYHLR4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 13:56:47 -0400
Received: by wr-out-0506.google.com with SMTP id 69so2024772wri.5
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 10:56:46 -0700 (PDT)
Message-ID: <43e72e890808121056ua211e66lbc7bc8d619390bfd@mail.gmail.com> (sfid-20080812_195652_683577_19712257)
Date: Tue, 12 Aug 2008 10:56:45 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: Pondering: how to improve mac80211 roaming ...
Cc: "Helmut Schaa" <hschaa@suse.de>,
	"Holger Schurig" <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080812154223.GE4981@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200808120838.52888.hs4233@mail.mn-solutions.de>
	 <20080812082246.GD4981@jm.kir.nu> <200808121440.24098.hschaa@suse.de>
	 <20080812154223.GE4981@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 12, 2008 at 8:42 AM, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Aug 12, 2008 at 02:40:23PM +0200, Helmut Schaa wrote:
>
>> JFYI I already started to rework the existing scan code in mac80211
>> (software scan) to do something like background scanning:
>>
>> 1) notify current AP about leaving the channel
>> 2) scan one channel
>
> It might be useful to leave this "one" as a parameter to allow easy
> experiments with scanning more than one channel at a time to reduce
> latency. Ideally, this--along the interval for background scans--could
> be something that is dynamically changed based on the expected traffic
> pattern. Whenever there is lot of data traffic being (mostly
> successfully) transmitted, it would be beneficial not to jump to other
> channels as frequently or for as long a time. If there has not been any
> data transmission for some time, it may be more acceptable to scan more
> frequently and to remain away from the operational channel for longer
> periods of time. Though, we should also keep in mind that background
> scans are going to increase power consumption on otherwise inactive
> situation, so setting a suitable policy for this can get quite complex.
>
> If we can somehow figure out whether there is periodic need for some
> traffic (e.g., VoIP), it would also be nice to be able to schedule the
> background scans to happen when there is no expected packet being sent
> or received at the time. Obviously, this gets much more complex, so this
> is not really something that would need to be included in the first
> version ;-). Anyway, it would be useful to keep in mind that there may
> be needs for making the background scan parameters change dynamically
> and there is need to be able to configure a suitable policy from user
> space.

If someone is picking this up please extend our TODO list for roaming
and mention it:

http://wireless.kernel.org/en/developers/todo-list#Roaming

  Luis
