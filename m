Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:54518 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964771Ab2KWHcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 02:32:05 -0500
Message-ID: <50AF2673.6060706@monom.org> (sfid-20121123_083209_389841_8EB57035)
Date: Fri, 23 Nov 2012 08:32:03 +0100
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com> <50AA845C.2050809@monom.org> <50AB3182.5040505@monom.org> <20121120142822.GA26602@thinkpad-t410> <50ABC168.8080904@monom.org> <20121120205418.GB26602@thinkpad-t410> <50AC05A5.3090706@monom.org> <50AC07F2.8000400@monom.org> <50ACA28F.9010800@broadcom.com> <50ACA55F.5050406@monom.org> <20121121143528.GC23606@thinkpad-t410>
In-Reply-To: <20121121143528.GC23606@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth,

On 21.11.2012 15:35, Seth Forshee wrote:
> On Wed, Nov 21, 2012 at 10:56:47AM +0100, Daniel Wagner wrote:
>> On 21.11.2012 10:44, Arend van Spriel wrote:
>>> On 11/20/2012 11:45 PM, Daniel Wagner wrote:
>>>>>
>>>>> I am currently not able to reproduce a complete loss of connectivity.
>>>>
>>>> I fear it is a heisenbug. After turning the tracing off I was able to
>>>> reproduce it very easily.
>
> Just to clarify, you see the issue using the same kernel but without
> trace-cmd running?

Yes, exactly.

> If so you might try disabling the brcmsmac_tx
> tracepoing, which probably adds the most overhead, and see if you can
> reproduce the problem. It obviously won't give as much information but
> maybe it will still provide some clues.

Will do. To clarify what I mean with 'connectivity' loss, is that 
ConnMan/wpa_s still think everything is fine but nothing works anymore. 
So it could be a combination of issues which sums up to this behavior. 
I'll spend some more time to gather better information.

>>> That is too bad. I always wondered about the tracing overhead affecting
>>> reproducibility. So the trace that you uploaded was not showing the
>>> issue of connection loss you are having?
>>
>> The trace does only show that the throughput goes considerable down and the
>> download might even stop shortly but overall the system recovers again.
>>
>> Well, to add some random observation here, I think I see the same pattern
>> when using MacOS (yeah, sorry, dual boot). With MacOS the link is usable but
>> the throughput sometimes really goes down and recovers then. Obviously, this
>> could also be something else, I tried it with an pretty old AP which only
>> support 11g. Using the 11g AP didn't show this behavior.
>>
>> My 'test' setup is following: I downloaded a larger file and let a youtube
>> video play. With tracing enabled the download and the playback did work nicely.
>>
>> Without tracing enabled playing back only a youtube video was 'triggering'
>> the problem. It downloads a few seconds of content in a burst and then the playback
>> starts. Under normal conditions, the app will continue downloading the video at a
>> lower rate. But this normally doesn't happen right now. Often it will just stop
>> working and often the connection is completely blocked, e.g. pinging a host
>> wont work.
>
> I'll see if I can reproduce, but if it's specific to the AP then I may
> not have any luck. Don't expect to hear much from me until next week
> though; I'm on holiday starting today and will be visiting family.

Enjoy!

cheers,
daniel

