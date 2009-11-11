Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:54818 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704AbZKKAGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 19:06:16 -0500
Received: by iwn8 with SMTP id 8so516943iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 10 Nov 2009 16:06:22 -0800 (PST)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 10 Nov 2009 16:06:02 -0800
Message-ID: <43e72e890911101606j46e1edfn64e331f3463d4da5@mail.gmail.com>
Subject: Oops on ath_txq_schedule() hit a BUG_ON()
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@lists.ath9k.org, Aeolus Yang <Aeolus.Yang@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I managed to get an oops the 2.6.32-rc wireless bits on ath9k by using
linux-backports-modules package on Ubuntu 9.10 which is on 2.6.31. I'm
pretty sure this is a real oops which can be reproduced on 2.6.32-rc6
but I was unable to boot the same laptop on 2.6.32-rc6 [1] due to an
early oops on what seems to be i915.

The EIP is at ath_txq_schedule() but the oops happens due to a
BUG_ON() (used to be ASSERT()) on this piece of code:

static void ath_tx_addto_baw(struct ath_softc *sc, struct ath_atx_tid *tid,
                             struct ath_buf *bf)
{
        int index, cindex;

        if (bf_isretried(bf))
                return;

        index  = ATH_BA_INDEX(tid->seq_start, bf->bf_seqno);
        cindex = (tid->baw_head + index) & (ATH_TID_MAX_BUFS - 1);

        /* The precious new bug is here */
        BUG_ON(tid->tx_buf[cindex] != NULL);
        tid->tx_buf[cindex] = bf;

        if (index >= ((tid->baw_tail - tid->baw_head) &
                (ATH_TID_MAX_BUFS - 1))) {
                tid->baw_tail = cindex;
                INCR(tid->baw_tail, ATH_TID_MAX_BUFS);
        }
}

This happens against an 802.11n AP, the WRT610n with 802.11n enabled.
The AP has this option to let you enable "only 802.11n", whatever that
means, its on the 2.4 GHz so I doubt the "only 802.11n" option is not
really only enabling 802.11n.

I managed to get a few pictures to remember this precious moment:

http://bombadil.infradead.org/~mcgrof/oops-img/2009/11/ath_txq_schedule_oops/01.jpg
http://bombadil.infradead.org/~mcgrof/oops-img/2009/11/ath_txq_schedule_oops/03.jpg
http://bombadil.infradead.org/~mcgrof/oops-img/2009/11/ath_txq_schedule_oops/02.jpg

This was with SpeedStep enabled, the power pulled off and doing iperf
UDP out (TX'ing). Haven't managed to find what makes the assumption
incorrect yet but it obviously is. If we cannot find what it is soon
we need to figure out a compromise and change it to a WARN_ONCE or so.

[1] http://lkml.org/lkml/2009/11/10/510

  Luis
