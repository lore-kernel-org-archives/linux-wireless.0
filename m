Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44695 "EHLO
	g1u1820.austin.hp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958Ab1IIQhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 12:37:55 -0400
Message-ID: <4E6A3ECA.9010809@hp.com> (sfid-20110909_183758_767820_DEFFE1E0)
Date: Fri, 09 Sep 2011 09:28:58 -0700
From: Rick Jones <rick.jones2@hp.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about netperf terminology in the RTL8192SE and 802.11n
 problem thread
References: <4E6955B8.4000900@hp.com> <4E696378.3060005@lwfinger.net>
In-Reply-To: <4E696378.3060005@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Those numbers are from my tests. The TX numbers are the standard netperf
> output and give the rate from my test laptop to a server that is wired
> to the AP/router. Those are the numbers that you are used to.
>
> The RX numbers are obtained by starting a server on my laptop and
> ssh'ing a netperf command to the machine that was the server in the TX
> tests, i.e. I am measuring the TX rate from the former server, or the RX
> rate for the laptop. My script does 10 samples of each and calculates
> the mean and standard deviation.

Thanks.  If I have interpreted your answer correctly what you call 
TCP_STREAM RX should be the same as TCP_MAERTS TX and vice versa 
(modulo having the same -s, -S, -m and -M values or system defaults 
anyway)  Ie

system-A> netperf -H system-B -t TCP_MAERTS ...

should be the same as

system-A> ssh system-B netperf -H system-A -t TCP_STREAM

I put the TCP_MAERTS test into netperf specifically to help people avoid 
having to ssh :)

happy benchmarking,

rick jones
PS, if I or anyone else ever gets around to implementing the sendfile 
functionality in the "omni" tests, then they should also provide what we 
might call a TCP_ELIFDNES test - the netserver side calling sendfile() 
to send data to the netperf side.
