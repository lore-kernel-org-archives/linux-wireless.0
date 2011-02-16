Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2316 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab1BPXoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 18:44:30 -0500
Subject: Re: [PATCH 0/5] iwlwifi: Auto-tune tx queue size to maintain
 latency under load
From: wwguy <wey-yi.w.guy@intel.com>
To: Nathaniel Smith <njs@pobox.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <AANLkTimJcGr=L6scJotzKeL+2AEvbHBRi16fo1MpqFJ3@mail.gmail.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	 <20110216155011.GC10287@tuxdriver.com>
	 <AANLkTimJcGr=L6scJotzKeL+2AEvbHBRi16fo1MpqFJ3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Feb 2011 15:42:36 -0800
Message-ID: <1297899756.21351.3.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-16 at 15:08 -0800, Nathaniel Smith wrote:
> On Wed, Feb 16, 2011 at 7:50 AM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > On Sun, Feb 13, 2011 at 09:56:37AM -0800, Nathaniel J. Smith wrote:
> >
> >> This patch series teaches the driver to measure the average rate of
> >> packet transmission for each tx queue, and adjusts the queue size
> >> dynamically in an attempt to achieve ~2 ms of added latency.
> >
> > How did you pick this number?  Is there research to support this as
> > the correct target for link latency?
> 
> I'm not aware of any such research, no. My reasoning is that in this
> scheme the ideal latency is based on the kernel's scheduling
> promptness -- at some moment t0 the hardware sends the packet that
> drops us below our low water mark, and then it takes some time for the
> kernel to be informed of this fact, for the driver's tasklet to be
> scheduled, the TX queue to be restarted, and for packets to get loaded
> into it, so that eventually at time t1 the queue is refilled. To
> maintain throughput, we want the queue length to be such that all this
> can be accomplished before the queue drains completely; to maintain
> latency, we want it to be no longer than necessary.
> 
> So the ideal latency for the TX queue is whatever number L is, say,
> 95% of the time, greater than (t1 - t0). Note that this is
> specifically for the driver queue, whose job is just to couple the
> "real" queue to the hardware; the "real" queue should be larger and
> smarter to properly handle bursty behavior and such.
> 
> I made up "2 ms" out of thin air as a number that seemed plausible to
> me, and because I don't know how to measure the real number L. Ideally
> we'd measure it on the fly, since it surely varies somewhat between
> machines. Maybe someone else has a better idea how to do this?
> 
> The queue refill process for iwl3945 looks like:
>   1) hardware transmits a packet, sends a tx notification to the driver
>   2) iwl_isr_legacy receives the interrupt, and tasklet_schedule()s
> the irq tasklet
>   3) iwl3945_irq_tasklet runs, and eventually from
> iwl3945_tx_queue_reclaim we wake the queue
>   4) Waking the queue raises a softirq (netif_wake_subqueue -> __netif_schedule)
>   5) The softirq runs, and, if there are packets queued, eventually
> calls iwl3945_tx_skb
> 
> So IIUC there are actually two trips through the scheduler -- between
> (2) and (3), and between (4) and (5). I assume that these are the only
> sources of significant latency, so our goal is to measure the time
> elapsed from (2) to (5).
> 
> Complications: (a) In the ISR, I'm not sure we have access to a
> reliable realtime clock. (b) If there aren't any packets queued and
> waiting, then we'll never get called in step (5).
> 
> The best bet -- assuming access to the clock from the interrupt
> handler -- might be to measure the time from iwl_isr_legacy being
> called to the tasklet being scheduled, and then multiply that by 2 + a
> fudge factor.
> 

I believe we need to test this on the newer device and re-think the
approach, keep in mind the newer iwlagn device has "interrupt
coalescing" to reduce the power and CPU usage, which will change the
timing. Also with 11n enable and aggregation is on, the behavior also
different.

Wey


