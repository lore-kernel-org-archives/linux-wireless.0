Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062Ab2CSO3Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 10:29:24 -0400
Date: Mon, 19 Mar 2012 15:29:06 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jakub Kicinski <moorray@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 3/5] rt2x00: rt2800usb: rework txstatus
 code
Message-ID: <20120319142905.GF6169@redhat.com> (sfid-20120319_152947_740797_B185F14E)
References: <1331720181-18564-1-git-send-email-sgruszka@redhat.com>
 <1331720181-18564-3-git-send-email-sgruszka@redhat.com>
 <20120317175311.1cf09433@north>
 <20120319075223.GC2251@redhat.com>
 <20120319141339.3596b6d8@north>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120319141339.3596b6d8@north>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 19, 2012 at 02:13:39PM +0100, Jakub Kicinski wrote:
> > > > +	if (rt2800usb_txstatus_pending(rt2x00dev) &&
> > > > +	    test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
> > > 
> > > I would put a bang before that test_and...
> > I don't understand what you mean, perhaps you could post a patch
> > or provide code snipset here, so I could comment.
> 
> If I understand correctly, status should be read again if there are
> pending entries and no one else has set TX_STATUS_READING yet. In that
> case return value of test_and_set_bit should be negated. I might be
> missing something though.

You are correct, this is another good catch! Fix is on the go.

> > I do not understand your objection here too. If rt2800usb_txstatus_pending()
> > will return true and if TX_STATUS_READING bit is not set, we will run hrtimer
> > to read status after 500 micro seconds. We exit the loop if kfifo is empty
> > and no entry timed out waiting to get corresponding TX status.
> 
> Yes, I don't mean that this code is wrong. I just think that
> rt2800usb_async_read_tx_status have no chance of actually going past
> TX_STATUS_READING check. If every dma_done schedules reading and
> reading stops only when all pending entries have their statuses then
> call to rt2800usb_async_read_tx_status after we processed statuses is
> excessive.
> 
> All that said, I haven't tested this hypothesis and may be completely
> wrong (again). Also I _don't_ mean that this call should be removed,
> just wanted to me sure I understand everything correctly ;-)

I think you have right. I'll review that carefully and remove those
lines if they are useless.

Thanks
Stanislaw
