Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33455 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729878AbeHOTdH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 15:33:07 -0400
Received: by mail-io0-f196.google.com with SMTP id z20-v6so1506866iol.0
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2018 09:40:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180815082956.u6grueiyshwgqt3a@mwanda>
References: <20180813223910.26276-1-surenb@google.com> <20180814095413.vbjkcjkmytkffyaz@mwanda>
 <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
 <CAJuCfpHSZuabLr6+t_n7UDamJCAP6EPTNEZ6kNqWOhk2mpYADg@mail.gmail.com>
 <CAGXu5jKqcpbpG0Ky4-yXV4d5q10HtGwJtdyPKcrwkJUPhA_Mpg@mail.gmail.com>
 <CAJuCfpEX69Sbd=0i0ismP6q2NsZGUF4gMSCr1G5NdXd3n1NyZA@mail.gmail.com>
 <CAGXu5jJB9wMDJnfsurpxsXm6_0WsWWCaTuWBfy+3aMSE_LL9Rw@mail.gmail.com>
 <CAJuCfpEX+F-EPxQYXNdUg-uT9ecwYYdxBsr9y_69zQ0Fq50GeA@mail.gmail.com>
 <CAJuCfpGSPkB-tk4GHaJeStRph-ibVhUZ119Sfd16xgf9x=qUwQ@mail.gmail.com> <20180815082956.u6grueiyshwgqt3a@mwanda>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Aug 2018 09:40:13 -0700
Message-ID: <CAJuCfpH9n2vVjBF7RoMNng3T=URY1eusKfbVGyq44LWcjwNTPw@mail.gmail.com> (sfid-20180815_184017_807162_E524B819)
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kees Cook <keescook@chromium.org>,
        Security Officers <security@kernel.org>,
        Kevin Deus <kdeus@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 15, 2018 at 1:29 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Aug 14, 2018 at 03:38:14PM -0700, Suren Baghdasaryan wrote:
>> The separate fix for the size of pipes[] array is posted here:
>> https://lkml.org/lkml/2018/8/14/1034
>> Thanks!
>>
>
> That's great!  Let's add some bounds checking to nfc_hci_msg_rx_work()
> and nfc_hci_recv_from_llc() as well and then we can close the chapter on
> these bugs.

Dan, I don't think we need additional checks there. Here are the
relevant parts of the code in nfc_hci_recv_from_llc():

static void nfc_hci_recv_from_llc(struct nfc_hci_dev *hdev, struct sk_buff *skb)
{
...
packet = (struct hcp_packet *)skb->data;
...

/* it's the last fragment. Does it need re-aggregation? */
if (skb_queue_len(&hdev->rx_hcp_frags)) {
    pipe = packet->header & NFC_HCI_FRAGMENT;
    ...
    hcp_skb = nfc_alloc_recv_skb(NFC_HCI_HCP_PACKET_HEADER_LEN +
         msg_len, GFP_KERNEL);
    ...
    *skb_put(hcp_skb, NFC_HCI_HCP_PACKET_HEADER_LEN) = pipe;
    ...
} else {
    packet->header &= NFC_HCI_FRAGMENT;
    hcp_skb = skb;
}

AFAIU in both cases the pipe field in hcp_skb can't exceed 127 after
we applied NFC_HCI_FRAGMENT(0x7f) mask.

>
> regards,
> dan carpenter
>
