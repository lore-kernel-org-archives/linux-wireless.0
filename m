Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from saarni.dnainternet.net ([83.102.40.136]:56524 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389AbZHHIdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 04:33:25 -0400
Message-ID: <20090808113324.11151dei7w1sr334@hayate.sektori.org>
Date: Sat, 08 Aug 2009 11:33:24 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Dan Williams" <dcbw@redhat.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	"Jouni Malinen" <Jouni.Malinen@Atheros.com>
Subject: Re: [PATCH] rndis_wlan: wait association to complete
References: <20090806181746.31308.15687.stgit@fate.lan>
	<1249584385.28278.124.camel@johannes.local>
	<20090806223406.27393zuzztewms74@hayate.sektori.org>
	<1249680718.26088.44.camel@localhost.localdomain>
In-Reply-To: <1249680718.26088.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Dan Williams" <dcbw@redhat.com>:

> On Thu, 2009-08-06 at 22:34 +0300, Jussi Kivilinna wrote:
>> Quoting "Johannes Berg" <johannes@sipsolutions.net>:
>>
>> > On Thu, 2009-08-06 at 21:17 +0300, Jussi Kivilinna wrote:
>> >> Fix WPA authentication problems by waiting to association to complete.
>> >> Otherwise userspace (wpa_supplicant) receives authentication  
>> packets before
>> >> association events from driver.
>> >
>> >> +	/* If we return now, userspace would get association events too late
>> >> +	 * (after receiving first packets from access point). This causes
>> >> +	 * WPA authentication to fail.
>> >
>> > This is a bit weird, shouldn't you just send the event later then?
>> >
>>
>> rndis_wlan bases on rndis_host/usbnet. Problem is that rndis_host uses
>> polling for rndis_command() results to avoid more complex interrupt
>> based solution. Because rndis_host and therefore rndis_wlan doesn't
>> handle interrupts on command channel, rndis_wlan knows about completed
>> association too late. 'Too late' means here that device starts
>> receiving packets from AP, which end up ignored because userspace
>> thinks device isn't assosiated yet (I think).
>>
>> So this patch adds waiting in set_essid() and active polling for
>> association completion in worker.
>>
>> Real fix would probably be to hold on data channel until association
>> is complete, but that would mean touching usbnet/rndis_host little bit
>> too much than I'd like to.
>
> If this patch ever blocks SIOSIWESSID, then a huge NAK.  Setting the
> ESSID is an asynchronous operation, it should *not* block for operation
> to complete.  Completion is signaled only when an IWESSID event is sent
> to userspace.  What you should be doing is dropping packets from the AP
> on the floor until the firmware things the association is complete.
>

Ok, I noticed that I need to do this 'right way' anyway for  
cfg80211-connect conversion. So I'm taking this one back and work out  
better fix for/with connect patches.

-Jussi

