Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:51115 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2KTO23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 09:28:29 -0500
Date: Tue, 20 Nov 2012 08:28:22 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Daniel Wagner <wagi@monom.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121120142822.GA26602@thinkpad-t410> (sfid-20121120_152833_000221_F08F1E1C)
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com>
 <50AA845C.2050809@monom.org>
 <50AB3182.5040505@monom.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50AB3182.5040505@monom.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 08:30:10AM +0100, Daniel Wagner wrote:
> Hi Seth,
> 
> On 19.11.2012 20:11, Daniel Wagner wrote:
> > Works perfectly fine on my machine.
> 
> Well, not really true. Though I am not sure if this what I am seeing 
> related to your changes. I see following log only when I am using my 
> home AP. The pattern is that when the connection stop working I see
> something like this in the log:
> 
> [ 8735.159091] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 4
> [ 8735.197298] wlan0: Rx A-MPDU request on tid 0 result 0
> [ 8735.566368] wlan0: Open BA session requested for 1c:c6:3c:1f:50:68 tid 0
> [ 8735.573701] wlan0: activated addBA response timer on tid 0
> [ 8735.578826] wlan0: switched off addBA timer for tid 0
> [ 8735.578834] wlan0: Aggregation is on for tid 0
> [ 8749.687530] wlan0: tx session timer expired on tid 0
> [ 8749.687558] wlan0: Tx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0
> [ 8749.700550] wlan0: Stopping Tx BA session for 1c:c6:3c:1f:50:68 tid 0
> 
> 
> This is what I do: First establishing a connection, then after a while any
> traffic seems stops for a period and sometimes it recovers from that point. If
> not a disconnect/connect (using ConnMan) dance fixes the problem. 

The tx session timer expiring is a result of not having any aggregate
transfers in a while. In my testing with iperf I see periods where the
transfer seems to stall, but it always recovers. These are less frequent
after my patches, but they still happen, and I haven't been able to work
out the cause yet. I'm not sure whether these are related to what you're
seeing or not.

Luckily I've added a bunch of new debug code. Could you make sure you
have MAC80211_MESSAGE_TRACING and BRCM_TRACING enabled in your config
and collect a trace when this is happening by running:

 trace-cmd record -e mac80211 -e mac80211_msg -e brcmsmac \
        -e brcmsmac_tx -e brcmsmac_msg

This going to collect a lot of data, and you should bump up the trace
buffer size to avoid overruns. Once you've got a trace please compress
trace.dat and put it along with your dmesg somewhere where I can get at
them.

Thanks,
Seth

