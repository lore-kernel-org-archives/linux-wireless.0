Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57830 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753435AbdBNNqM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:46:12 -0500
Subject: Re: [PATCH 02/10] rt2800: identify station based on status WCID
To: Stanislaw Gruszka <sgruszka@redhat.com>
References: <1487076368-7020-1-git-send-email-sgruszka@redhat.com>
 <1487076368-7020-3-git-send-email-sgruszka@redhat.com>
 <bf62370e-fe78-470b-4902-92fbb1d093f8@nbd.name>
 <20170214133244.GA6437@redhat.com>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <c2ad0e74-cbb2-2ded-a423-a2f107e52c53@nbd.name> (sfid-20170214_144648_089802_FA018BA2)
Date: Tue, 14 Feb 2017 14:46:10 +0100
MIME-Version: 1.0
In-Reply-To: <20170214133244.GA6437@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-14 14:32, Stanislaw Gruszka wrote:
> On Tue, Feb 14, 2017 at 02:10:01PM +0100, Felix Fietkau wrote:
>> On 2017-02-14 13:46, Stanislaw Gruszka wrote:
>> > Add station field to skb_frame_desc and assign it according to status
>> > WCID. This field will be used in the future.
>> > 
>> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> I see some potential for race conditions in this approach. You store the
>> sta pointer in struct skb_frame_desc, but I don't see anything that
>> guarantees that the sta will be around for as long as the tx frame is held.
>> I think a better approach would be to not store the sta pointer in
>> skb_frame_desc at all.
>> Instead, add a driver callback to look up the sta by wcid, and use rcu
>> properly there. Make sure you only hold the sta pointer obtained from
>> that call within a RCU read locked section.
> 
> On patch 7, where ->sta start to be used, I added RCU protection.
Maybe you should get rid of the skbdesc->sta assignment in patch 2,
because this is somewhat confusing.

- Felix
