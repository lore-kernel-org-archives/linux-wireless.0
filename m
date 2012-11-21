Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:52540 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab2KUJ4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 04:56:49 -0500
Message-ID: <50ACA55F.5050406@monom.org> (sfid-20121121_105655_702445_94B78936)
Date: Wed, 21 Nov 2012 10:56:47 +0100
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com> <50AA845C.2050809@monom.org> <50AB3182.5040505@monom.org> <20121120142822.GA26602@thinkpad-t410> <50ABC168.8080904@monom.org> <20121120205418.GB26602@thinkpad-t410> <50AC05A5.3090706@monom.org> <50AC07F2.8000400@monom.org> <50ACA28F.9010800@broadcom.com>
In-Reply-To: <50ACA28F.9010800@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21.11.2012 10:44, Arend van Spriel wrote:
> On 11/20/2012 11:45 PM, Daniel Wagner wrote:
>>>
>>> I am currently not able to reproduce a complete loss of connectivity.
>>
>> I fear it is a heisenbug. After turning the tracing off I was able to
>> reproduce it very easily.
> 
> That is too bad. I always wondered about the tracing overhead affecting 
> reproducibility. So the trace that you uploaded was not showing the 
> issue of connection loss you are having?

The trace does only show that the throughput goes considerable down and the 
download might even stop shortly but overall the system recovers again.

Well, to add some random observation here, I think I see the same pattern
when using MacOS (yeah, sorry, dual boot). With MacOS the link is usable but
the throughput sometimes really goes down and recovers then. Obviously, this
could also be something else, I tried it with an pretty old AP which only
support 11g. Using the 11g AP didn't show this behavior.

My 'test' setup is following: I downloaded a larger file and let a youtube 
video play. With tracing enabled the download and the playback did work nicely.

Without tracing enabled playing back only a youtube video was 'triggering' 
the problem. It downloads a few seconds of content in a burst and then the playback
starts. Under normal conditions, the app will continue downloading the video at a 
lower rate. But this normally doesn't happen right now. Often it will just stop
working and often the connection is completely blocked, e.g. pinging a host
wont work.


