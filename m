Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57580 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab0BHVpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 16:45:35 -0500
Date: Mon, 8 Feb 2010 16:39:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: fix PAE frame handling
Message-ID: <20100208213946.GC3852@tuxdriver.com>
References: <4B65F735.1020509@openwrt.org> <19302.24837.154697.822430@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19302.24837.154697.822430@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 01, 2010 at 10:35:09AM +0530, Sujith wrote:
> Felix Fietkau wrote:
> > ath9k's tx handling code contains a special case for PAE frames, which
> > looks like it was intended to be improving reliability by excluding
> > them from aggregates.
> > What it actually did is the opposite: By assigning a faulty sequence
> > number, yet still keeping it as a qos-frame, it caused bogus packet
> > reordering, which broke WPA rekeying.
> > The special case handling is completely unnecessary, so this patch
> > removes it.
> 
> Sending PAE frames as part of an aggregate broke crypto with several APs.
> Assigning the correct seq. number should work, no ?
> 
> Something like the patch below. Can you check if it fixes your issue ?
> Though, removing the seq. number mess in the driver would be great. :D

Sujith, are you going to post this formally?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
