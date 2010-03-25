Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:49971 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab0CYVKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 17:10:20 -0400
Date: Fri, 26 Mar 2010 10:10:55 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
To: Bruno Randolf <br1@einfach.org>
cc: linville@tuxdriver.com, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH 00/10] ANI for ath5k
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
Message-ID: <alpine.DEB.2.00.1003261001530.24989@kauri.acheron.indranet.co.nz>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
On Thu, 25 Mar 2010, Bruno Randolf wrote:
> This is ANI for ath5k.
Fantastic!!
  I have used your initial ani patch set here, and it did help througput 
etc.
>
> - Improve beacon averaging algorithm for IBSS: Maybe we should keep track of
>  the average RSSI on a per-node basis and use the minimum of those in order
>  not to loose far away nodes? The other option would be to limit the
>  parameters we control similar to AP mode.

We have talked about this before. I thought that we agreed 
that adhoc nodes may
   a)be activated at any time
   b)be positioned at an unknown distance apart

it therefore makes no sense to average the RSSI over the current nodes.
If all the current nodes in the network are close by, the ani algorithm 
will wind the sensitivity down. Consequently, if a remote node is 
started, it will not be able to connect. Yet, the remote node should 
have been able to connect as the slot times etc were long enough, 
and the link budget is fine...

So yes, the only way to 
> - Improve beacon averaging algorithm for IBSS:
is to turn ani off. which means the issue you raised else where of 
providing reasonable userland controls (not via debugfs) becomes 
important.


Derek.

---
Derek Smithies Ph.D. 
IndraNet Technologies Ltd. 
ph +64 3 365 6485 
Web: http://www.indranet-technologies.com/

"How did you make it work??"
       "Oh, the usual, get everything right".
