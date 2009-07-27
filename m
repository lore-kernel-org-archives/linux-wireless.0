Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:35615 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZG0Pzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 11:55:33 -0400
Message-ID: <4A6DCE0E.3010103@lwfinger.net>
Date: Mon, 27 Jul 2009 10:55:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Possible BUG where mac80211 fails to stop queues
References: <4A6CDE26.3000409@lwfinger.net> <1248684480.19945.45.camel@johannes.local>
In-Reply-To: <1248684480.19945.45.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-07-26 at 17:52 -0500, Larry Finger wrote:
>> While stress testing the newest version of the open-source firmware
>> for BCM43XX devices with the latest pull of wireless-testing, I ran
>> into a problem of DMA TX queue overrun. Initially I thought this was
>> due to the firmware change; however, I got the same error with the
>> standard firmware. I have not seen this before, but it may not be a
>> regression as it seems to occur only under special circumstances.
> 
> I've also seen it under extreme stress on Intel hardware, cf.
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/36497

Fortunately, the b43 coding was robust enough to prevent queue
overrun, thus we just end up with a warning.
--snip--

>> The system generates the warning for ring->stopped and prints the "DMA
>> queue overflow" message.
> 
> Right. Exactly the same behaviour as I'm seeing on Intel hardware.
> 
>> My understanding is that mac80211 serializes the calls for each TX
>> queue, and that the TX callback should not have been entered for this
>> case.
>>
>> If I am not understanding the way that mac80211 works, please correct
>> me. I would also appreciate any suggestions for further debugging.
> 
> I stared at the mac80211 code for a long time and concluded that it was
> a race condition and couldn't really be fixed, see my analysis in the
> iwlwifi patch. I'd love to be proved wrong though.
> 
> Are you seeing this multiple times? I don't think you have fragmentation
> on, do you? At least I didn't and still saw the problem, which seemed a
> bit strange, but I really couldn't see any other way for it to happen.

When it occurs, I get just a single warning. Fragmentation was not on.

I will prepare a patch that acknowledges that mac80211 might send one
extra fragment after the queues are stopped and only issue a warning
if we get more than one.

Thanks,

Larry
