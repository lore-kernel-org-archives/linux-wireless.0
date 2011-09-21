Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:42911 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1IUIkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 04:40:45 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 21 Sep 2011 10:40:20 +0200
Subject: RE: [PATCH v2 3/4] NFC: basic NCI protocol implementation
Message-ID: <AC090B9732AB2B4DB7FF476E907FE66001323E269F@dnce02.ent.ti.com> (sfid-20110921_104049_624571_1E9BF601)
References: <AC090B9732AB2B4DB7FF476E907FE660013226A26C@dnce02.ent.ti.com>
 <CAK3JMAadvUag85SfjOhYN+yqW0con9RBo7PQ1_V1uYce_BXgKQ@mail.gmail.com>
In-Reply-To: <CAK3JMAadvUag85SfjOhYN+yqW0con9RBo7PQ1_V1uYce_BXgKQ@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro,

> > +static void nci_init_complete_req(struct nci_dev *ndev, 
> unsigned long opt)
> > +{
> > +       struct nci_rf_disc_map_cmd cmd;
> > +       struct nci_core_conn_create_cmd conn_cmd;
> > +       int i;
> > +
> > +       /* create static rf connection */
> > +       conn_cmd.target_handle = 0;
> > +       conn_cmd.num_target_specific_params = 0;
> > +       nci_send_cmd(ndev, NCI_OP_CORE_CONN_CREATE_CMD, 2, 
> &conn_cmd);
> > +
> > +       /* set rf mapping configurations */
> > +       cmd.num_mapping_configs = 0;
> > +
> > +       /* by default mapping is set to NCI_RF_INTERFACE_FRAME */
> > +       for (i = 0; i < ndev->num_supported_rf_interfaces; i++) {
> > +               if (ndev->supported_rf_interfaces[i] ==
> > +                       NCI_RF_INTERFACE_ISO_DEP) {
> > +                       cmd.mapping_configs[cmd.num_mapping_configs]
> > +                       .rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
> > +                       cmd.mapping_configs[cmd.num_mapping_configs]
> > +                       .mode = NCI_DISC_MAP_MODE_BOTH;
> > +                       cmd.mapping_configs[cmd.num_mapping_configs]
> > +                       .rf_interface_type = 
> NCI_RF_INTERFACE_ISO_DEP;
> > +                       cmd.num_mapping_configs++;
> > +               } else if (ndev->supported_rf_interfaces[i] ==
> > +                       NCI_RF_INTERFACE_NFC_DEP) {
> > +                       cmd.mapping_configs[cmd.num_mapping_configs]
> > +                       .rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
> > +                       cmd.mapping_configs[cmd.num_mapping_configs]
> > +                       .mode = NCI_DISC_MAP_MODE_BOTH;
> > +                       cmd.mapping_configs[cmd.num_mapping_configs]
> > +                       .rf_interface_type = 
> NCI_RF_INTERFACE_NFC_DEP;
> > +                       cmd.num_mapping_configs++;
> > +               }
> 
> I think you should improve the readability in this 'if'.
OK, I'll try to improve this 'if'.

> > +
> > +static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
> > +{
> > +       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
> > +       int rc;
> > +
> > +       nfc_dbg("entry");
> > +
> > +       if (test_bit(NCI_DISCOVERY, &ndev->flags)) {
> > +               nfc_err("unable to start poll, since poll 
> is already active");
> > +               return -EBUSY;
> > +       }
> > +
> > +       if (test_bit(NCI_POLL_ACTIVE, &ndev->flags)) {
> > +               nfc_dbg("target already active, first 
> deactivate...");
> > +
> > +               rc = nci_request(ndev, nci_rf_deactivate_req, 0,
> > +                       
> msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
> > +               if (rc)
> > +                       return -EBUSY;
> > +       }
> 
> I don't think it is a good idea to implicitly deactivate a target. I
> think you should just return EBUSY.
The problem here is related to the NCI definition.

The NCI defines that if only 1 target is discovered (the common case), 
it's automatically activated by the controller (i.e. in state POLL_ACTIVE).
On the other hand, if more than 1 target is discovered, the controller 
sends RF_DISCOVER_NTF for each target, and the host need to select 
one (this case is much less common and I didn't implemented it yet).

So, we're talking about the first case: once we start polling, and 
discover only 1 target, it's automatically activated.
Now, if we call start_poll again, we have to deactivate the target before 
starting the poll again (as dictated by the NCI spec).
I think this is the simplest solution to this issue: implicitly deactivate 
the target before starting to poll.

Another alternative is to always deactivate the target after it was 
automatically activated, and when activate_target is called, we'll have to 
poll again and hope that the same target will be activated again...
I think this solution is much less preferred, since it's much more 
complicated and contradictes the NCI idea.

Please advise.

> 
> 
> 
> > +static int nci_data_exchange(struct nfc_dev *nfc_dev, 
> __u32 target_idx,
> > +                                               struct sk_buff *skb,
> > +                                               
> data_exchange_cb_t cb,
> > +                                               void *cb_context)
> > +{
> > +       struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
> > +
> > +       nfc_dbg("entry, target_idx %d, len %d", target_idx, 
> skb->len);
> > +
> > +       if (!ndev->target_active_prot) {
> > +               nfc_err("unable to exchange data, no active 
> target");
> > +               return -EINVAL;
> > +       }
> > +
> > +       /* store cb and context to be used on receiving data */
> > +       ndev->data_exchange_cb = cb;
> > +       ndev->data_exchange_cb_context = cb_context;
> 
> This is wrong. The data exchange can be called again before completing
> the previous call. So, you shouldn't store the cb and cb_context in
> the device.
You're correct, of course.
I see in your pn533 implementation that you also store the arguments 
(in the field pn533.cmd_complete_arg), but you do protect them with the 
'cmd_lock' semaphore.
If already in progress of data exchange transaction, you return EBUSY.
I can also protect the 'cb' and 'cb_context' with such a semaphore.
In fact, this is an implementation of a queue with max length of 1 
data exchange transaction.

Please advise.

Thanks & BR,
Ilan



