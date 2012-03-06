Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54324 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030402Ab2CFLxp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 06:53:45 -0500
Date: Tue, 6 Mar 2012 12:53:22 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.3] rt2x00: fix random stalls
Message-ID: <20120306115321.GB31306@redhat.com> (sfid-20120306_125349_046987_215898F0)
References: <20120305164813.GB2979@redhat.com>
 <CAGXE3d9==tT-ukfn5RO9xTEfw=YXO=FAVJob2WMFJS-FS8j9GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAGXE3d9==tT-ukfn5RO9xTEfw=YXO=FAVJob2WMFJS-FS8j9GQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 06, 2012 at 08:45:21AM +0100, Helmut Schaa wrote:
> > -       if (!rt2x00queue_threshold(entry->queue))
> > +       if (!rt2x00queue_threshold(entry->queue)) {
> > +               spin_lock_irq(&entry->queue->tx_lock);
> >                rt2x00queue_unpause_queue(entry->queue);
> > +               spin_unlock_irq(&entry->queue->tx_lock);
> 
> Why do we need to disable interrupts here? spin_lock_bh should
> be sufficient.

I'm not 100% sure, and I was to lazy to find out, and chose safer
version. I guess I need to find out now ...

Stanislaw
