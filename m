Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64146 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1IUXPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 19:15:16 -0400
Received: by qyk30 with SMTP id 30so5613890qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 16:15:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE66001323E269F@dnce02.ent.ti.com>
References: <AC090B9732AB2B4DB7FF476E907FE660013226A26C@dnce02.ent.ti.com>
	<CAK3JMAadvUag85SfjOhYN+yqW0con9RBo7PQ1_V1uYce_BXgKQ@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE66001323E269F@dnce02.ent.ti.com>
Date: Wed, 21 Sep 2011 20:15:15 -0300
Message-ID: <CAK3JMAb0kyVkdGiHfF1huVVLG2OxoCYyhAw1FvQDwLuqgCFPYQ@mail.gmail.com> (sfid-20110922_011523_146790_A46C0546)
Subject: Re: [PATCH v2 3/4] NFC: basic NCI protocol implementation
From: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
To: "Elias, Ilan" <ilane@ti.com>
Cc: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/9/21 Elias, Ilan <ilane@ti.com>:

>> > +
>> > +static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
>> > +{
>> > +       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
>> > +       int rc;
>> > +
>> > +       nfc_dbg("entry");
>> > +
>> > +       if (test_bit(NCI_DISCOVERY, &ndev->flags)) {
>> > +               nfc_err("unable to start poll, since poll
>> is already active");
>> > +               return -EBUSY;
>> > +       }
>> > +
>> > +       if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
>> > +               nfc_dbg("target already active, first
>> deactivate...");
>> > +
>> > +               rc = nci_request(ndev, nci_rf_deactivate_req, 0,
>> > +
>> msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
>> > +               if (rc)
>> > +                       return -EBUSY;
>> > +       }
>>
>> I don't think it is a good idea to implicitly deactivate a target. I
>> think you should just return EBUSY.
> The problem here is related to the NCI definition.
>
> The NCI defines that if only 1 target is discovered (the common case),
> it's automatically activated by the controller (i.e. in state POLL_ACTIVE).
> On the other hand, if more than 1 target is discovered, the controller
> sends RF_DISCOVER_NTF for each target, and the host need to select
> one (this case is much less common and I didn't implemented it yet).
>
> So, we're talking about the first case: once we start polling, and
> discover only 1 target, it's automatically activated.
> Now, if we call start_poll again, we have to deactivate the target before
> starting the poll again (as dictated by the NCI spec).
> I think this is the simplest solution to this issue: implicitly deactivate
> the target before starting to poll.

I don't see any problem in implicitly deactivating a target that was
implicitly activated. But if the target was activated by the user
(nfc_activate_target), it should not be deactivated.

>
> Another alternative is to always deactivate the target after it was
> automatically activated, and when activate_target is called, we'll have to
> poll again and hope that the same target will be activated again...
> I think this solution is much less preferred, since it's much more
> complicated and contradictes the NCI idea.

I agree that is not a good solution.

>
> Please advise.

>
>>
>>
>>
>> > +static int nci_data_exchange(struct nfc_dev *nfc_dev,
>> __u32 target_idx,
>> > +                                               struct sk_buff *skb,
>> > +
>> data_exchange_cb_t cb,
>> > +                                               void *cb_context)
>> > +{
>> > +       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
>> > +
>> > +       nfc_dbg("entry, target_idx %d, len %d", target_idx,
>> skb->len);
>> > +
>> > +       if (!ndev->target_active_prot) {
>> > +               nfc_err("unable to exchange data, no active
>> target");
>> > +               return -EINVAL;
>> > +       }
>> > +
>> > +       /* store cb and context to be used on receiving data */
>> > +       ndev->data_exchange_cb = cb;
>> > +       ndev->data_exchange_cb_context = cb_context;
>>
>> This is wrong. The data exchange can be called again before completing
>> the previous call. So, you shouldn't store the cb and cb_context in
>> the device.
> You're correct, of course.
> I see in your pn533 implementation that you also store the arguments
> (in the field pn533.cmd_complete_arg), but you do protect them with the
> 'cmd_lock' semaphore.
> If already in progress of data exchange transaction, you return EBUSY.
> I can also protect the 'cb' and 'cb_context' with such a semaphore.
> In fact, this is an implementation of a queue with max length of 1
> data exchange transaction.
>

You are right. The pn533 driver protects 'cb' and 'cb_context' but it
doesn't support full concurrency. Probably we will have to improve
this when the LLCP is implemented.
For your patch, I think it is enough to just protect the 'cb' and 'cb_context'.


Thanks,
Lauro
