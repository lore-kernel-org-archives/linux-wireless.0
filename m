Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49692 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1LMTmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Dec 2011 14:42:37 -0500
Date: Tue, 13 Dec 2011 13:42:31 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
Message-ID: <20111213194231.GA30788@thinkpad-t410> (sfid-20111213_204239_409354_99977ADF)
References: <20111118225422.GD19138@thinkpad-t410>
 <4EC88F58.1080203@lwfinger.net>
 <20111121181350.GC6736@thinkpad-t410>
 <4ECA99CC.7020008@lwfinger.net>
 <20111121185610.GD6736@thinkpad-t410>
 <4ECB028E.3030809@lwfinger.net>
 <20111122022008.GA17661@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111122022008.GA17661@thinkpad-t410>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2011 at 08:20:08PM -0600, Seth Forshee wrote:
> On Mon, Nov 21, 2011 at 08:01:50PM -0600, Larry Finger wrote:
> > On 11/21/2011 12:56 PM, Seth Forshee wrote:
> > >On Mon, Nov 21, 2011 at 12:34:52PM -0600, Larry Finger wrote:
> > >>On 11/21/2011 12:13 PM, Seth Forshee wrote:
> > >>>
> > >>>I've uploaded the capture along with the logs to
> > >>>http://people.canonical.com/~sforshee/rtl8188ce/.
> > >>
> > >>Unfortunately, I do not have permission to access the pcap file. The
> > >>other two are OK, but not the one of interest.
> > >
> > >Sorry about that, didn't notice the lack of permissions. Fixed now.
> > 
> > I got it now. I would like one other piece of information - what is
> > the MAC address of your RTL8188CE device? It is not found in any of
> > the dmesg logs that I have.
> 
> 7c:4f:b5:c7:a5:53

Larry,

I've been trying to look into this myself over the last couple of days,
but I'm still trying to learn all of this 802.11 stuff. I've kind of hit
the limit of what knowledge I've acquired so far, so I'd appreciate it
if you could look at my findings and offer suggestions.

What I'm doing is running wpa_supplicant manually to try and initiate a
connection while monitoring the traffic with wireshark on a separate
machine.  What I'm seeing is that when the rtl8192ce device sends a
probe request or authentication request, the majority of the time the AP
sends a response but the adapter fails to ack the response (I don't see
the ack in the wireshark capture, and the AP resends the probe response
several times). The logs show timeouts that correspond to the types of
responses that aren't being acked. It's as if the adapter doesn't see
the responses at all.

I have another AP that the rtl8192ce doesn't have any problems
associating with, so I also captured a trace with wireshark when
associating to that AP. I didn't see much that differed except that the
probe response frame with the problematic AP is about 350 bytes longer
(due to additional information elements).

Something else that I noticed is that with the problematic AP, inactive
power save seems to kick in shortly afer sending the
probe/authentication requests. I wondered if this might be behind the
issues, but loading the module with ips=0 makes no difference.

Any suggestions on what might be going wrong or next steps for
debugging?

Thanks,
Seth
