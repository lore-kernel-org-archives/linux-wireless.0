Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753665AbdBNNhk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:37:40 -0500
Date: Tue, 14 Feb 2017 14:32:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 02/10] rt2800: identify station based on status WCID
Message-ID: <20170214133244.GA6437@redhat.com> (sfid-20170214_143810_670470_F9DA359A)
References: <1487076368-7020-1-git-send-email-sgruszka@redhat.com>
 <1487076368-7020-3-git-send-email-sgruszka@redhat.com>
 <bf62370e-fe78-470b-4902-92fbb1d093f8@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <bf62370e-fe78-470b-4902-92fbb1d093f8@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 14, 2017 at 02:10:01PM +0100, Felix Fietkau wrote:
> On 2017-02-14 13:46, Stanislaw Gruszka wrote:
> > Add station field to skb_frame_desc and assign it according to status
> > WCID. This field will be used in the future.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> I see some potential for race conditions in this approach. You store the
> sta pointer in struct skb_frame_desc, but I don't see anything that
> guarantees that the sta will be around for as long as the tx frame is held.
> I think a better approach would be to not store the sta pointer in
> skb_frame_desc at all.
> Instead, add a driver callback to look up the sta by wcid, and use rcu
> properly there. Make sure you only hold the sta pointer obtained from
> that call within a RCU read locked section.

On patch 7, where ->sta start to be used, I added RCU protection.

Stanislaw
