Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960AbYJJVcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 17:32:15 -0400
Date: Fri, 10 Oct 2008 17:32:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ath5k: kernel timing screwed - due to unserialised register
	access?
Message-ID: <20081010213207.GA7852@infradead.org> (sfid-20081010_233219_658884_97021761)
References: <alpine.LFD.2.00.0810072042140.3166@apollo> <87hc7ot804.fsf@denkblock.local> <87myhfnwne.fsf@denkblock.local> <alpine.LFD.2.00.0810082203360.3237@apollo> <alpine.LFD.2.00.0810091313380.3237@apollo> <87k5cgg87j.fsf@denkblock.local> <alpine.LFD.2.00.0810101127560.3271@apollo> <87abdck6sn.fsf@denkblock.local> <alpine.LFD.2.00.0810101432540.3271@apollo> <87y70wli6n.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87y70wli6n.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 10, 2008 at 02:59:28PM +0200, Elias Oltmanns wrote:
> That was my first thought when I discovered this. However, from what I
> read on the web, I somehow got the impression that [um]delay() was
> alright as opposed to msleep(). What exactly is the difference then?

Yes, only msleep() sleeps, mdelay spins.

