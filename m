Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:60108 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966127Ab0BZVBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 16:01:55 -0500
Received: by qyk9 with SMTP id 9so311210qyk.5
        for <linux-wireless@vger.kernel.org>; Fri, 26 Feb 2010 13:01:55 -0800 (PST)
Message-ID: <4B8836BF.7000403@lwfinger.net>
Date: Fri, 26 Feb 2010 15:01:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Make b43 driver fall back gracefully to PIO mode after fatal
 DMA  errors
References: <alpine.LFD.2.00.1002261034140.4513@localhost.localdomain>  <4B881C70.9030004@lwfinger.net> <alpine.LFD.2.00.1002261112590.4513@localhost.localdomain>  <alpine.LFD.2.00.1002261205160.4513@localhost.localdomain> <69e28c911002261209m2b10ca27j5a62c91350e3597c@mail.gmail.com> <alpine.LFD.2.00.1002261246330.4513@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002261246330.4513@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/26/2010 02:50 PM, Linus Torvalds wrote:
> 
> 
> On Fri, 26 Feb 2010, Gábor Stefanik wrote:
>>
>> Does actually enabling mmiotrace fix it for you too?
> 
> I haven't seen the report. What do you need to do? Certainly just enabling 
> CONFIG_MMIOTRACE does nothing, but I'd not expect it to - I'd expect that 
> you have to actually do the tracing itself.
> 
> So if somebody has a recipe for me to test actual tracing of the module, I 
> can try to see if it makes a difference for me.

If you do the following (as root):

modprobe -r b43
echo 6400 > /sys/kernel/debug/tracing/buffer_size_kb
echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
cat /sys/kernel/debug/tracing/trace_pipe > mydump.txt &
modprobe b43

do some network activity, then

echo nop > /sys/kernel/debug/tracing/current_tracer
sleep 1
killproc cat

That should be a good enough test. If your machine behaves the same as has been
reported, you should see a DMA error at the point that tracing is turned off.

Larry

