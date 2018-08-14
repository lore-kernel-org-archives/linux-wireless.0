Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:35244 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbeHNXO5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 19:14:57 -0400
Received: by mail-it0-f65.google.com with SMTP id 139-v6so21869241itf.0
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 13:26:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
References: <20180813223910.26276-1-surenb@google.com> <20180814095413.vbjkcjkmytkffyaz@mwanda>
 <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 14 Aug 2018 13:26:04 -0700
Message-ID: <CAJuCfpHSZuabLr6+t_n7UDamJCAP6EPTNEZ6kNqWOhk2mpYADg@mail.gmail.com> (sfid-20180814_222617_976297_E57262D4)
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: security@kernel.org, Kevin Deus <kdeus@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 9:57 AM, Suren Baghdasaryan <surenb@google.com> wrote:
> On Tue, Aug 14, 2018 at 2:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>> Thanks.  This is great.  I'm so glad these are finally getting fixed.
>>
>> Do we need to fix nfc_hci_msg_rx_work() and nfc_hci_recv_from_llc() as
>> well?  In nfc_hci_recv_from_llc() we allow pipe to be NFC_HCI_FRAGMENT
>> (0x7f) so that's one element beyond the end of the array and the
>> NFC_HCI_HCP_RESPONSE isn't checked.
>>
>> Also nci_hci_msg_rx_work() and nci_hci_data_received_cb() use
>> NCI_HCP_MSG_GET_PIPE() so those could be off by one.
>
> Good point. From hci.h:
>
> /*
>  * According to specification 102 622 chapter 4.4 Pipes,
>  * the pipe identifier is 7 bits long.
>  */
> #define NFC_HCI_MAX_PIPES 127
>
> And then:
>
> struct nfc_hci_dev {
>   ...
>   struct nfc_hci_pipe pipes[NFC_HCI_MAX_PIPES];
>   ...
> }
>
> I think the correct fix would be to change it to:
>
>   struct nfc_hci_pipe pipes[NFC_HCI_MAX_PIPES + 1];
>
> What do you think?
>

Just to be clear, this would fix the problem Dan described in his
reply and it should be implemented in a separate patch. The original
fix is still valid.

>>
>> regards,
>> dan carpenter
>>
