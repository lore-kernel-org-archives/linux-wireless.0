Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48932 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726319AbeHQPKW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 11:10:22 -0400
Date: Fri, 17 Aug 2018 15:06:50 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>,
        Security Officers <security@kernel.org>,
        Kevin Deus <kdeus@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
Message-ID: <20180817120650.6mx6icxif2o52qyx@mwanda> (sfid-20180817_140905_524823_03DF5FD4)
References: <20180814095413.vbjkcjkmytkffyaz@mwanda>
 <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
 <CAJuCfpHSZuabLr6+t_n7UDamJCAP6EPTNEZ6kNqWOhk2mpYADg@mail.gmail.com>
 <CAGXu5jKqcpbpG0Ky4-yXV4d5q10HtGwJtdyPKcrwkJUPhA_Mpg@mail.gmail.com>
 <CAJuCfpEX69Sbd=0i0ismP6q2NsZGUF4gMSCr1G5NdXd3n1NyZA@mail.gmail.com>
 <CAGXu5jJB9wMDJnfsurpxsXm6_0WsWWCaTuWBfy+3aMSE_LL9Rw@mail.gmail.com>
 <CAJuCfpEX+F-EPxQYXNdUg-uT9ecwYYdxBsr9y_69zQ0Fq50GeA@mail.gmail.com>
 <CAJuCfpGSPkB-tk4GHaJeStRph-ibVhUZ119Sfd16xgf9x=qUwQ@mail.gmail.com>
 <20180815082956.u6grueiyshwgqt3a@mwanda>
 <CAJuCfpH9n2vVjBF7RoMNng3T=URY1eusKfbVGyq44LWcjwNTPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJuCfpH9n2vVjBF7RoMNng3T=URY1eusKfbVGyq44LWcjwNTPw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2018 at 09:40:13AM -0700, Suren Baghdasaryan wrote:
> On Wed, Aug 15, 2018 at 1:29 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Tue, Aug 14, 2018 at 03:38:14PM -0700, Suren Baghdasaryan wrote:
> >> The separate fix for the size of pipes[] array is posted here:
> >> https://lkml.org/lkml/2018/8/14/1034
> >> Thanks!
> >>
> >
> > That's great!  Let's add some bounds checking to nfc_hci_msg_rx_work()
> > and nfc_hci_recv_from_llc() as well and then we can close the chapter on
> > these bugs.
> 
> Dan, I don't think we need additional checks there. Here are the
> relevant parts of the code in nfc_hci_recv_from_llc():
>

Sorry, I meant after that at the end of the function:

net/nfc/hci/core.c
   902          /* if this is a response, dispatch immediately to
   903           * unblock waiting cmd context. Otherwise, enqueue to dispatch
   904           * in separate context where handler can also execute command.
   905           */
   906          packet = (struct hcp_packet *)hcp_skb->data;
   907          type = HCP_MSG_GET_TYPE(packet->message.header);
   908          if (type == NFC_HCI_HCP_RESPONSE) {
   909                  pipe = packet->header;
                        ^^^^^^^^^^^^^^^^^^^^^
Pipe can go up to 255.

   910                  instruction = HCP_MSG_GET_CMD(packet->message.header);
   911                  skb_pull(hcp_skb, NFC_HCI_HCP_PACKET_HEADER_LEN +
   912                           NFC_HCI_HCP_MESSAGE_HEADER_LEN);
   913                  nfc_hci_hcp_message_rx(hdev, pipe, type, instruction, hcp_skb);
                                                     ^^^^
Then inside the nfc_hci_hcp_message_rx() function we call
nfc_hci_cmd_received() and nfc_hci_event_received() which use it as an
array index.

   914          } else {
   915                  skb_queue_tail(&hdev->msg_rx_queue, hcp_skb);
   916                  schedule_work(&hdev->msg_rx_work);
   917          }
   918  }

It's the same thing when nfc_hci_hcp_message_rx() is called from
nfc_hci_msg_rx_work():

   138  static void nfc_hci_msg_rx_work(struct work_struct *work)
   139  {
   140          struct nfc_hci_dev *hdev = container_of(work, struct nfc_hci_dev,
   141                                                  msg_rx_work);
   142          struct sk_buff *skb;
   143          struct hcp_message *message;
   144          u8 pipe;
   145          u8 type;
   146          u8 instruction;
   147  
   148          while ((skb = skb_dequeue(&hdev->msg_rx_queue)) != NULL) {
   149                  pipe = skb->data[0];
                        ^^^^^^^^^^^^^^^^^^^
   150                  skb_pull(skb, NFC_HCI_HCP_PACKET_HEADER_LEN);
   151                  message = (struct hcp_message *)skb->data;
   152                  type = HCP_MSG_GET_TYPE(message->header);
   153                  instruction = HCP_MSG_GET_CMD(message->header);
   154                  skb_pull(skb, NFC_HCI_HCP_MESSAGE_HEADER_LEN);
   155  
   156                  nfc_hci_hcp_message_rx(hdev, pipe, type, instruction, skb);
                                                     ^^^^
   157          }
   158  }

regards,
dan carpenter
