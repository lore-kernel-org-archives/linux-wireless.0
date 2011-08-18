Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:55790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab1HRQLc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2011 12:11:32 -0400
Subject: Re: [PATCH 3/4] NFC: Basic NFC NCI protocol implementation
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: "Elias, Ilan" <ilane@ti.com>
Cc: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600131E1C33B@dnce02.ent.ti.com>
References: <AC090B9732AB2B4DB7FF476E907FE6600131E1C33B@dnce02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 18:13:20 +0200
Message-ID: <1313684000.3345.21.camel@sortiz-mobl> (sfid-20110818_181135_622196_7C09DDC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

On Tue, 2011-08-16 at 19:36 +0200, Elias, Ilan wrote:
> The NFC Controller Interface (NCI) is a standard communication protocol between an NFC Controller (NFCC) and a Device Host (DH), defined by the NFC Forum.
> 
> Signed-off-by: Ilan Elias <ilane@ti.com>
> ---
>  include/net/nfc/nci.h      |  313 ++++++++++++++++++
>  include/net/nfc/nci_core.h |  177 +++++++++++
>  net/nfc/Kconfig            |    2 +
>  net/nfc/Makefile           |    1 +
>  net/nfc/nci/Kconfig        |   10 +
>  net/nfc/nci/Makefile       |    7 +
>  net/nfc/nci/nci_core.c     |  750 ++++++++++++++++++++++++++++++++++++++++++++
>  net/nfc/nci/nci_data.c     |  252 +++++++++++++++
>  net/nfc/nci/nci_lib.c      |   94 ++++++
>  net/nfc/nci/nci_ntf.c      |  264 ++++++++++++++++
>  net/nfc/nci/nci_rsp.c      |  226 +++++++++++++
>  11 files changed, 2096 insertions(+), 0 deletions(-)
>  create mode 100644 include/net/nfc/nci.h
>  create mode 100644 include/net/nfc/nci_core.h
>  create mode 100644 net/nfc/nci/Kconfig
>  create mode 100644 net/nfc/nci/Makefile
>  create mode 100644 net/nfc/nci/nci_core.c
>  create mode 100644 net/nfc/nci/nci_data.c
>  create mode 100644 net/nfc/nci/nci_lib.c
>  create mode 100644 net/nfc/nci/nci_ntf.c
>  create mode 100644 net/nfc/nci/nci_rsp.c
In general, I prefer the nci/core.c, nci/data.c, etc naming scheme as opposed to the more redundant one you're using here.

> +/* NCI Discovery Types */
> +#define NCI_DISCOVERY_TYPE_POLL_A_PASSIVE              0x00
Identation fix.


> +#define        NCI_DISCOVERY_TYPE_POLL_B_PASSIVE               0x01
> +#define        NCI_DISCOVERY_TYPE_POLL_F_PASSIVE               0x02
> +#define        NCI_DISCOVERY_TYPE_POLL_A_ACTIVE                0x03
> +#define        NCI_DISCOVERY_TYPE_POLL_F_ACTIVE                0x05
> +#define        NCI_DISCOVERY_TYPE_WAKEUP_A_PASSIVE             0x06
> +#define        NCI_DISCOVERY_TYPE_WAKEUP_B_PASSIVE             0x07
> +#define        NCI_DISCOVERY_TYPE_WAKEUP_A_ACTIVE              0x09
> +#define        NCI_DISCOVERY_TYPE_LISTEN_A_PASSIVE             0x80
> +#define        NCI_DISCOVERY_TYPE_LISTEN_B_PASSIVE             0x81
> +#define        NCI_DISCOVERY_TYPE_LISTEN_F_PASSIVE             0x82
> +#define        NCI_DISCOVERY_TYPE_LISTEN_A_ACTIVE              0x83
> +#define        NCI_DISCOVERY_TYPE_LISTEN_F_ACTIVE              0x85

> +#define NCI_MT_DATA_PKT                        0x00
Ditto.

> +#define NCI_MT_CMD_PKT                  0x01
> +#define NCI_MT_RSP_PKT                 0x02
> +#define NCI_MT_NTF_PKT                 0x03

> +/* Reserved for drivers usage */
> +#define NCI_SKB_RESERVE        4
Do we expect all drivers to need at most 4 bytes ?

> +#define nci_req_lock(ndev)             mutex_lock(&ndev->req_lock)
> +#define nci_req_unlock(ndev)           mutex_unlock(&ndev->req_lock)
This kind of abstraction doesn't bring much to the table. I'd prefer to
use the mutex API directly.



> +/* Execute request and wait for completion. */
> +static int __nci_request(struct nci_dev *ndev,
> +       void (*req)(struct nci_dev *ndev, unsigned long opt),
> +       unsigned long opt,
> +       __u32 timeout)
> +{
> +       DECLARE_WAITQUEUE(wait, current);
> +       int rc = 0;
> +
> +       ndev->req_status = NCI_REQ_PEND;
> +
> +       add_wait_queue(&ndev->req_wait_q, &wait);
> +       set_current_state(TASK_INTERRUPTIBLE);
> +
> +       req(ndev, opt);
> +       schedule_timeout(timeout);
> +
> +       remove_wait_queue(&ndev->req_wait_q, &wait);
> +
> +       if (signal_pending(current))
> +               return -EINTR;
> +
> +       switch (ndev->req_status) {
> +       case NCI_REQ_DONE:
> +               rc = nci_to_errno(ndev->req_result);
> +               break;
> +
> +       case NCI_REQ_CANCELED:
> +               rc = -ndev->req_result;
> +               break;
> +
> +       default:
> +               rc = -ETIMEDOUT;
> +               break;
> +       }
> +
> +       ndev->req_status = ndev->req_result = 0;
> +
> +       return rc;
> +}
So here, I wonder: Can't we just use simple completion and the
wait_for_completion_* APIs ? One completion structure per ndev and you
should be fine. Especially since you seem to be serializing (as
expected) the requests below.


> +/* Send NCI command */
> +int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, void *payload)
> +{
> +       struct nci_ctrl_hdr *hdr;
> +       struct sk_buff *skb;
> +
> +       nfc_dbg("entry, opcode 0x%x, plen %d", opcode, plen);
> +
> +       skb = nci_skb_alloc((NCI_CTRL_HDR_SIZE + plen), GFP_KERNEL);
> +       if (!skb) {
> +               nfc_err("no memory for command");
> +               return -ENOMEM;
> +       }
> +
> +       hdr = (struct nci_ctrl_hdr *) skb_put(skb, NCI_CTRL_HDR_SIZE);
> +       hdr->gid = nci_opcode_gid(opcode);
> +       hdr->oid = nci_opcode_oid(opcode);
> +       hdr->plen = plen;
> +
> +       nci_mt_set((__u8 *)hdr, NCI_MT_CMD_PKT);
> +       nci_pbf_set((__u8 *)hdr, NCI_PBF_LAST);
> +
> +       if (plen)
> +               memcpy(skb_put(skb, plen), payload, plen);
> +
> +       skb->dev = (void *) ndev;
> +
> +       skb_queue_tail(&ndev->cmd_q, skb);
> +       tasklet_schedule(&ndev->cmd_task);
> +
> +       return 0;
> +}
So I have 2 comments on this one:

1) Do we have a compelling reason for deferring the command queue
handling ? In which case can you queue a command while the previous one
is not completed yet ?
2) If we do, we certainly don't want a tasklet for that. Using a tasklet
puts some additional constraints on what we can call for it, the
tradeoff being a supposedly lower latency. I don't think we need it,
workqueues (for cmd, tx and rx) would be just fine.




> +/* Send NCI data */
> +int nci_send_data(struct nci_dev *ndev, __u8 conn_id, struct sk_buff *skb)
> +{
> +       int rc = 0;
> +
> +       nfc_dbg("entry, conn_id 0x%x, plen %d", conn_id, skb->len);
> +
> +       /* check if the packet need to be fragmented */
> +       if (skb->len <= ndev->max_pkt_payload_size) {
> +               /* no need to fragment packet */
> +
> +               /* reserve header space for nci and driver */
> +               if (skb_cow_head(skb, (NCI_DATA_HDR_SIZE + NCI_SKB_RESERVE))) {
I think this kind of reallocations could be avoided with a couple
patches that I will post soon. We could basically tell the NFC core in
advance which head room we need.
See
http://git.kernel.org/?p=linux/kernel/git/sameo/nfc-2.6.git;a=commit;h=ba108daaec65f5d02daaf9084fa5f8f2375d0d92

Cheers,
Samuel.

