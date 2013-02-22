Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:35965 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753933Ab3BVKH7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 05:07:59 -0500
Message-ID: <51274372.9030600@neratec.com> (sfid-20130222_110804_908071_EE843B9B)
Date: Fri, 22 Feb 2013 11:07:46 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, antonio@open-mesh.com,
	marek@open-mesh.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [RFC] design discussion: Collecting information for (non-peer)
 stations
References: <20130215171938.GA4140@pandem0nium>
In-Reply-To: <20130215171938.GA4140@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2013 06:19 PM, Simon Wunderlich wrote:
> Hello wireless folks,
> 
> Mathias Kretschmer and me would like to bring another new feature to the kernel:
> Collecting information for (non-peer) stations. [...]
> 
> Cheers,
>         Simon
> 
Hi Simon,

our areas of operations obviously highly overlap, since I did the same
consideration path only recently ;)

For the frequency planning feature we are currently working on, I need those
extended statistics you are proposing with additional filtering rules (OUI or mask
based) to classify peers.

My initial idea was to do a sliding time window aggregation of those statistics in
the kernel with almost the same interface to the userspace you are proposing.

But with your integration of the spectral feature I realized how efficient relay
based continuous data transfer is (as compared to sending samples over netlink).
Consequently I revised the initial plan and consider realizing the extended
statistics collection in userspace.

The modifications required in the kernel are minimal:
* create relay file in debugfs
* provide enable flag in debugfs
* based on this flag, extract relevant information from frames and write to relay

This way, you move complexity out of the kernel and maximize flexibility for
statistical evaluation in userspace. Also, the overhead for moving data between
kernel and userspace is minimized, since you do them in bulk.

This is all in the planning phase, so I have no proof-of-concept patches yet.
Would just like to hear what your thoughts are and whether this could be the way
to go.



Thanks for your initiative
Zefir
