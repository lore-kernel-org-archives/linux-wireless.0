Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23105.mail.ird.yahoo.com ([217.146.189.45]:48524 "HELO
	web23105.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754531AbYKOAKg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 19:10:36 -0500
Date: Sat, 15 Nov 2008 00:10:34 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 0/3] rtl8187: throughput fix/conf_tx callback/ack tx pkts
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <491D080E.7040505@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <754954.88237.qm@web23105.mail.ird.yahoo.com> (sfid-20081115_011050_362494_FE2A6D72)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Fri, 14/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Herton Ronaldo Krzesinski wrote:
> > Three patches that fixes/introduces the following in
> rtl8187:
> > - Fixes 8187B reported throughput issues after short
> slot handling addition.
> > - Implement conf_tx callback, instead of hardcoding
> some tx queue values.
> > - Make rate control work for 8187B sending correct
> feedback about transmitted
> >   packet status, using one of the Bulk In endpoints
> that provides this info.
> 
> With these 3 patches applied, my throughput improved again.
> Using sftp with an
> 128 MB file, my transmit rate increased to to 1.5 MB/s.
> With tcpperf, I get 9.9
> Mb/s - roughly the same.

While anecdotal, yes, I think throughput has improved. 

> 
> I'm using the 'pid' rate-control method, which
> now stabilizes at a lower stated
> rate than previously seen, but the throughput is higher.
> Curious.

The stated rate is probably how fast packets can be shipped, but the actual throughput depends on re-transmission, errors, and whether there is any stutter i.e. bursts of packets with "silences" between.

I am just happy that the driver is shaping up quite nicely. Well-done everybody :-).

Hin-Tak


      
