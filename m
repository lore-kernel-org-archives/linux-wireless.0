Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:10205 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754894AbYEUKNG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 06:13:06 -0400
From: bruno randolf <br1@einfach.org>
To: Henning Rogge <rogge@fgan.de>
Subject: Re: Get adhoc signal strength and bandwith from userspace
Date: Wed, 21 May 2008 12:13:01 +0200
Cc: linux-wireless@vger.kernel.org
References: <200805211106.42682.rogge@fgan.de>
In-Reply-To: <200805211106.42682.rogge@fgan.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805211213.01980.br1@einfach.org> (sfid-20080521_121321_328697_677BDA07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 21 May 2008 11:06:42 Henning Rogge wrote:
> Hello,
>
> I'm looking for an easy way to get average signal strength and bandwith for
> each communication partner in adhoc mode. I know this could be done with
> radiotap headers, but this would require to parse all incoming frames,
> which can consume lot's of cputime on embedded devices.
>
> Is there a userspace interface to get the bandwith and average signal
> strength of the communication partners in the 802.11 layer ?

i don't think that exists yet, but i'm interrested in something like that too, 
and i guess most people involvend in mesh networking protocols and metrics.

however i think "average signal quality" and "thruput" is a bit much to ask 
for (average over which period of time? weighted average? moving average?) - 
how about signal/noise of the last packet, physical rate and bytes in/out 
instead? you can average and calculate bandwidth in userspace.

now a question to the mac80211 maintainers: would that be something to be 
implemented with nl80211? 

bruno
