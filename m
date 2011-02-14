Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56004 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754782Ab1BND2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 22:28:53 -0500
Received: by bwz15 with SMTP id 15so5088827bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 19:28:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTin4MkMrz6Aa7g6JrB+QsNRHFvc26MFQ4UzcUM_L@mail.gmail.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<AANLkTin4MkMrz6Aa7g6JrB+QsNRHFvc26MFQ4UzcUM_L@mail.gmail.com>
Date: Sun, 13 Feb 2011 19:28:51 -0800
Message-ID: <AANLkTin6yoJcC+nPHPs=wWBptUu7pCu3ctdn+EdP7uS3@mail.gmail.com>
Subject: Re: [PATCH 0/5] iwlwifi: Auto-tune tx queue size to maintain latency
 under load
From: Nathaniel Smith <njs@pobox.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 13, 2011 at 4:32 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> The short term solution (but not an overall solution by any means) is
> to reduce these buffers so that packets are dropped when links are
> congested.

The job of a device transmit buffer is just to couple the "real"
generic networking layer buffer, where QoS, AQM, etc. are applied, to
the network hardware. They should just be as small as is consistent
with reasonable CPU utilization and throughput. There are many
different problems with over-large buffers, but this particular one is
very simple.

>> This patch series teaches the driver to measure the average rate of
>> packet transmission for each tx queue, and adjusts the queue size
>> dynamically in an attempt to achieve ~2 ms of added latency.
>
> IMHO, I'm not sure that this is the best method of implementing this
> solution: most wireless (and ethernet) devices have some form of
> buffer for the same reason, so implementing a solution for iwlwifi is
> not an overall solution - we need some method of doing this for *all*
> network devices, not just iwlwifi.

I agree, but I figure a good start is a good start, and at least it
scratches my itch. Maybe the other driver developers will move faster
once iwlwifi starts showing them up ;-).

-- Nathaniel
