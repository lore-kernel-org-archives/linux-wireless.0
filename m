Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B93DC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 21:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D243A20857
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 21:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BEvBTgWH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729683AbfB1VcN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 16:32:13 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36775 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfB1VcM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 16:32:12 -0500
Received: by mail-qt1-f193.google.com with SMTP id p25so25397613qtb.3
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2019 13:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cQ14oEe98/SwJw5IXM6gnR+5NeWHeoyQHzbeXaq7azA=;
        b=BEvBTgWHPSHiYUvr7DkJ7l24pAQ8lExuym3FsuQhqaB3zg/dbgHZSi7fKotVNjfnou
         d6PjQ525q7XDRyJOZWiqGlrq6BdODzJrS8QMSbJxiUjHEf6JtenE7242QqLZ11tGsG0Y
         oKLSRPlW8l/rvLqRyhpJ3rnYAE8YyRSAQua6NqmRu339LFupEInhcThgQ7f+80IpV4QT
         Sgybxs2vqN/8gsa0nU6p102a6j4QTugGdM1UpWd/XdJwR7r0cPAuvZxfiKoa/6iSabmD
         35ydBuMn0sddd0HQAQzjHnEzPWQqopHTJoKNuCkVn6PK7AznVFGCPO4f0QCDwTNeh+4K
         PwPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cQ14oEe98/SwJw5IXM6gnR+5NeWHeoyQHzbeXaq7azA=;
        b=AZhYuGALb0JIFE2kaMkDDTRrLYmvOSrwBQNoIha25MBZg+klpGtXIaolDc7EGep6OG
         uivlPhB2BYhKyj/loo1JBSCT/J+FmNsQ4mb68Tap8EwV0ds9gOHzOqUeLBD/raexMeih
         ETvTombCE+aYrifWld4cIoIbPIMLEF8pZF7pGJLUOjjRgJtIGAv28mocG5YqCXKpHR6f
         q+g72lkAyky2PxXAIiYiwTRK3lzQeo1xsYg7VJgr+HKzLV7LcmXw22AeQtf1I7I/r9Uq
         gEnbROrfjk8zTJqJwHmdl6RtHpM0RoTtpJ7iItAZd6K7CKHBxGe6viHM9b3HYkx/92o8
         33yg==
X-Gm-Message-State: APjAAAUOaKpqQXEG0mLSJWv5nmMJ4VkMLfuZeTWJRCFwbktRU+8PFlfX
        R9knX5A7CGH9WmkdivtF7sYVMQncbOp1kK5Gte1yFQ==
X-Google-Smtp-Source: APXvYqzMgih3aZhCzT4t+HcN7oJS5BAUL0UeCjs5NddQ1wPC2P3cSG/WU41GBg5T3bNsMHleUUjmGzJwWo7G+zKA5Kg=
X-Received: by 2002:aed:3e97:: with SMTP id n23mr1217119qtf.201.1551389531023;
 Thu, 28 Feb 2019 13:32:11 -0800 (PST)
MIME-Version: 1.0
References: <20190228155823.24749-1-greearb@candelatech.com>
 <CABvG-CUTn3aHAUUvQ6P+BtaWPtrBeeO8b3vfm5w=hB753_+g0g@mail.gmail.com> <c67eeb9a-3444-dd49-58eb-4e633063fd0e@candelatech.com>
In-Reply-To: <c67eeb9a-3444-dd49-58eb-4e633063fd0e@candelatech.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Thu, 28 Feb 2019 22:31:58 +0100
Message-ID: <CABvG-CVCZpKHuUufVZqAUWUwDYxJvUNSm9c=eRWMcT4GbAtRig@mail.gmail.com>
Subject: Re: [RFC] ath10k: Fix DMA errors related to beacons (CT FW only)
To:     Ben Greear <greearb@candelatech.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 28 Feb 2019 at 22:11, Ben Greear <greearb@candelatech.com> wrote:
> On 2/28/19 10:54 AM, Micha=C5=82 Kazior wrote:
> > On Thu, 28 Feb 2019 at 16:59, <greearb@candelatech.com> wrote:
> >>
> >> From: Ben Greear <greearb@candelatech.com>
[...]
> >> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wirel=
ess/ath/ath10k/mac.c
> >> index 154dcdabc48a..02a8efa2e783 100644
> >> --- a/drivers/net/wireless/ath/ath10k/mac.c
> >> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> > [...]
> >> @@ -6147,6 +6151,16 @@ static void ath10k_remove_interface(struct ieee=
80211_hw *hw,
> >>                  ath10k_warn(ar, "failed to stop spectral for vdev %i:=
 %d\n",
> >>                              arvif->vdev_id, ret);
> >>
> >> +       if (test_bit(ATH10K_FW_FEATURE_BEACON_TX_CB_CT,
> >> +                     ar->running_fw->fw_file.fw_features)) {
> >> +               int time_left;
> >> +
> >> +               time_left =3D wait_for_completion_timeout(&arvif->beac=
on_tx_done, (3 * HZ));
> >> +               if (!time_left)
> >> +                       ath10k_warn(ar, "WARNING: failed to wait for b=
eacon tx callback for vdev %i: %d\n",
> >> +                                   arvif->vdev_id, ret);
> >> +       }
> >
> > I think this can race against wmi tx credits replenishment and maybe
> > other wmi commands if they get issued (not many of them I suppose
> > though). The ordering would need to be something like this:
> >
> > cpu0                   cpu1
> >                         ath10k_wmi_op_ep_tx_credits
> >                         ieee80211_iterate_active_interfaces_atomic
> >                         ath10k_wmi_beacon_send_ref_nowait
> >                         # preempted
> > ieee80211_do_stop
> > clear sdata running
> > drv_remove_interface
> > wait_for_completion_timeout
> > ath10k_mac_vif_beacon_cleanup
> > free/unmap
> >                         gen_beacon_dma(bcn->xxx)
> >                         reinit_completion()
> >                         ath10k_wmi_cmd_send_nowait()
> >
> > Interestingly, this also shows it has been a possible use-after-free
> > without your patch. This is probably a unlikely scenario because
> > there's a disproportionate amount of code between these flows for this
> > to happen.
>
> Thanks for the thorough review.  One thing, the firmware
> cannot guarantee it can send the event (due to potential WMI event buffer
> exhaustion).  It would be rare that you got unlucky enough to hit the
> case where FW ran out of msg buffers right as you were deleting an
> interface though.

Right.


> As far as I can tell, my patch at least does not make the use-after-free
> scenario worse, so I'm tempted to ignore that for now.

Correct. Your patch doesn't make it worse.


> > There's also a memory leak because ath10k_mac_vif_beacon_free() exits
> > without freeing arvif->beacon if beacon_state is SENDING, which it
> > will be in in the above race case.
>
> Ok, this could be fixed by definitely freeing the mem in the remove_inter=
face
> logic, and is not new to my patch, right?

It's not new to your patch. It's just something I've noticed in the
codebase while reviewing your patch. Freeing it is going to be tricky
with the current design though.


> > With the per-skb beaconing case (which is dead code by the way it
> > seems..) iommu wouldn't be happy either because we'd hand over an
> > unmapped paddr to ath10k_wmi_cmd_send_nowait(). That's assuming kernel
> > didn't crash due to use-after-free on arvif->beacon (stored in `bcn`
> > on stack) before that >
> > This feels like a candidate for rcu if you wanted to have it fixed
> > neatly. It would fix both use-after-free and the locking conundrum -
> > ath10k_remove_interface() could NULL the pointer, call_rcu() and
> > wait_for_completion() in that call handler, and when its called back
> > unmap/free the beacon. This would require a refactor to how beacon
> > stuff is stored/maintained - a helper structure that would need carry
> > the beacon stuff + rcu_head, and this structure would be allocated and
> > assigned with rcu_assign_pointer() to a pointer in ath10k_vif. But I
> > feel like it's asking for unbound allocations or other bugs,
> > especially since I'm...
>
> This callback only happens at all with CT fw, and I definitely don't want=
 to
> deal with an out-of-tree rcu patch.  And, you are not guaranteed to get
> the callback as previously mentioned.  So I think rcu might be overkill
> for this?

You'd still need wait_for_completion with a timeout so even if you
don't get the beacon tx completion it'd still (have to) work. However
*it is* an overkill because the arvif->beacon can be simply removed
making the entire problem go away without adding extra logic.


Micha=C5=82
