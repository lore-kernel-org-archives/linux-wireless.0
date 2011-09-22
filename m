Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:48683 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab1IVGaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 02:30:06 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 22 Sep 2011 08:29:52 +0200
Subject: RE: [PATCH v2 3/4] NFC: basic NCI protocol implementation
Message-ID: <AC090B9732AB2B4DB7FF476E907FE66001323E2E34@dnce02.ent.ti.com> (sfid-20110922_083011_061203_1178627B)
References: <AC090B9732AB2B4DB7FF476E907FE660013226A26C@dnce02.ent.ti.com>
	<CAK3JMAadvUag85SfjOhYN+yqW0con9RBo7PQ1_V1uYce_BXgKQ@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE66001323E269F@dnce02.ent.ti.com>
 <CAK3JMAb0kyVkdGiHfF1huVVLG2OxoCYyhAw1FvQDwLuqgCFPYQ@mail.gmail.com>
In-Reply-To: <CAK3JMAb0kyVkdGiHfF1huVVLG2OxoCYyhAw1FvQDwLuqgCFPYQ@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro, 

> >> > +static int nci_start_poll(struct nfc_dev *nfc_dev, 
> __u32 protocols)
> >> > +{
> >> > +       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
> >> > +       int rc;
> >> > +
> >> > +       nfc_dbg("entry");
> >> > +
> >> > +       if (test_bit(NCI_DISCOVERY, &ndev->flags)) {
> >> > +               nfc_err("unable to start poll, since poll
> >> is already active");
> >> > +               return -EBUSY;
> >> > +       }
> >> > +
> >> > +       if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
> >> > +               nfc_dbg("target already active, first
> >> deactivate...");
> >> > +
> >> > +               rc = nci_request(ndev, nci_rf_deactivate_req, 0,
> >> > +
> >> msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
> >> > +               if (rc)
> >> > +                       return -EBUSY;
> >> > +       }
> >>
> >> I don't think it is a good idea to implicitly deactivate a 
> target. I
> >> think you should just return EBUSY.
> > The problem here is related to the NCI definition.
> >
> > The NCI defines that if only 1 target is discovered (the 
> common case),
> > it's automatically activated by the controller (i.e. in 
> state POLL_ACTIVE).
> > On the other hand, if more than 1 target is discovered, the 
> controller
> > sends RF_DISCOVER_NTF for each target, and the host need to select
> > one (this case is much less common and I didn't implemented it yet).
> >
> > So, we're talking about the first case: once we start polling, and
> > discover only 1 target, it's automatically activated.
> > Now, if we call start_poll again, we have to deactivate the 
> target before
> > starting the poll again (as dictated by the NCI spec).
> > I think this is the simplest solution to this issue: 
> implicitly deactivate
> > the target before starting to poll.
> 
> I don't see any problem in implicitly deactivating a target that was
> implicitly activated. But if the target was activated by the user
> (nfc_activate_target), it should not be deactivated.
I agree. I'll send a patch for this.

> >> > +static int nci_data_exchange(struct nfc_dev *nfc_dev,
> >> __u32 target_idx,
> >> > +                                               struct 
> sk_buff *skb,
> >> > +
> >> data_exchange_cb_t cb,
> >> > +                                               void *cb_context)
> >> > +{
> >> > +       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
> >> > +
> >> > +       nfc_dbg("entry, target_idx %d, len %d", target_idx,
> >> skb->len);
> >> > +
> >> > +       if (!ndev->target_active_prot) {
> >> > +               nfc_err("unable to exchange data, no active
> >> target");
> >> > +               return -EINVAL;
> >> > +       }
> >> > +
> >> > +       /* store cb and context to be used on receiving data */
> >> > +       ndev->data_exchange_cb = cb;
> >> > +       ndev->data_exchange_cb_context = cb_context;
> >>
> >> This is wrong. The data exchange can be called again 
> before completing
> >> the previous call. So, you shouldn't store the cb and cb_context in
> >> the device.
> > You're correct, of course.
> > I see in your pn533 implementation that you also store the arguments
> > (in the field pn533.cmd_complete_arg), but you do protect 
> them with the
> > 'cmd_lock' semaphore.
> > If already in progress of data exchange transaction, you 
> return EBUSY.
> > I can also protect the 'cb' and 'cb_context' with such a semaphore.
> > In fact, this is an implementation of a queue with max length of 1
> > data exchange transaction.
> >
> 
> You are right. The pn533 driver protects 'cb' and 'cb_context' but it
> doesn't support full concurrency. Probably we will have to improve
> this when the LLCP is implemented.
> For your patch, I think it is enough to just protect the 'cb' 
> and 'cb_context'.
OK, I'll send a patch to protect those arguments.
We'll support full concurrency once LLCP is implemented.

Please note that this series of patches was already merged to wireless-next.
So, I'll base new patches on top of that.

Thanks & BR,
Ilan
