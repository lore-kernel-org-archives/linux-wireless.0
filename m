Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38962 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab1BNAdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 19:33:18 -0500
Received: by iwn9 with SMTP id 9so4286332iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 16:33:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 14 Feb 2011 11:32:57 +1100
Message-ID: <AANLkTin4MkMrz6Aa7g6JrB+QsNRHFvc26MFQ4UzcUM_L@mail.gmail.com>
Subject: Re: [PATCH 0/5] iwlwifi: Auto-tune tx queue size to maintain latency
 under load
To: "Nathaniel J. Smith" <njs@pobox.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 04:56, Nathaniel J. Smith <njs@pobox.com> wrote:
> I have an iwl3945 in my laptop, and find that whenever I saturate the
> outgoing connection -- which happens daily when my rsync backup kicks
> in -- then latency becomes astronomical (what Jim Gettys calls
> "bufferbloat"). I've measured 12-13 second ping times to my router. As
> you can imagine, this makes web browsing or interactive SSH somewhat
> uncomfortable.

For those who aren't aware of this, more info:
http://gettys.wordpress.com/2010/12/03/introducing-the-criminal-mastermind-bufferbloat/

Re-(re-)stating the issue in question: When a network link is
congested, packets are being buffered for a "long" time in an attempt
to not drop any traffic; despite almost all protocols being either
built on TCP or designed to deal with packet loss. This causes latency
issues as the sender is not receiving any indication that the network
is congested and hence continuing to send as fast as it can, filling
these buffers and causing high latencies as they are emptied out over
the congested link.

The short term solution (but not an overall solution by any means) is
to reduce these buffers so that packets are dropped when links are
congested.

> This patch series teaches the driver to measure the average rate of
> packet transmission for each tx queue, and adjusts the queue size
> dynamically in an attempt to achieve ~2 ms of added latency.

IMHO, I'm not sure that this is the best method of implementing this
solution: most wireless (and ethernet) devices have some form of
buffer for the same reason, so implementing a solution for iwlwifi is
not an overall solution - we need some method of doing this for *all*
network devices, not just iwlwifi.

That said, your reasoning for the queue management simplification
seems sound - but as I don't know the iwlwifi code so I can't really
comment on it any further than that.

Finally, your numbers are damn impressive, and this is the first
attempt that I'm aware of to solve this problem.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
