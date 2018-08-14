Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:52181 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbeHNXoX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 19:44:23 -0400
Received: by mail-it0-f67.google.com with SMTP id e14-v6so20336441itf.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 13:55:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKqcpbpG0Ky4-yXV4d5q10HtGwJtdyPKcrwkJUPhA_Mpg@mail.gmail.com>
References: <20180813223910.26276-1-surenb@google.com> <20180814095413.vbjkcjkmytkffyaz@mwanda>
 <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
 <CAJuCfpHSZuabLr6+t_n7UDamJCAP6EPTNEZ6kNqWOhk2mpYADg@mail.gmail.com> <CAGXu5jKqcpbpG0Ky4-yXV4d5q10HtGwJtdyPKcrwkJUPhA_Mpg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 14 Aug 2018 13:55:23 -0700
Message-ID: <CAJuCfpEX69Sbd=0i0ismP6q2NsZGUF4gMSCr1G5NdXd3n1NyZA@mail.gmail.com> (sfid-20180814_225537_469562_5BB6CE84)
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
To: Kees Cook <keescook@chromium.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
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

On Tue, Aug 14, 2018 at 1:33 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Aug 14, 2018 at 1:26 PM, Suren Baghdasaryan <surenb@google.com> wrote:
>> On Tue, Aug 14, 2018 at 9:57 AM, Suren Baghdasaryan <surenb@google.com> wrote:
>>> On Tue, Aug 14, 2018 at 2:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>>> Thanks.  This is great.  I'm so glad these are finally getting fixed.
>>>>
>>>> Do we need to fix nfc_hci_msg_rx_work() and nfc_hci_recv_from_llc() as
>>>> well?  In nfc_hci_recv_from_llc() we allow pipe to be NFC_HCI_FRAGMENT
>>>> (0x7f) so that's one element beyond the end of the array and the
>>>> NFC_HCI_HCP_RESPONSE isn't checked.
>>>>
>>>> Also nci_hci_msg_rx_work() and nci_hci_data_received_cb() use
>>>> NCI_HCP_MSG_GET_PIPE() so those could be off by one.
>>>
>>> Good point. From hci.h:
>>>
>>> /*
>>>  * According to specification 102 622 chapter 4.4 Pipes,
>>>  * the pipe identifier is 7 bits long.
>>>  */
>>> #define NFC_HCI_MAX_PIPES 127
>>>
>>> And then:
>>>
>>> struct nfc_hci_dev {
>>>   ...
>>>   struct nfc_hci_pipe pipes[NFC_HCI_MAX_PIPES];
>>>   ...
>>> }
>>>
>>> I think the correct fix would be to change it to:
>>>
>>>   struct nfc_hci_pipe pipes[NFC_HCI_MAX_PIPES + 1];
>>>
>>> What do you think?
>>>
>>
>> Just to be clear, this would fix the problem Dan described in his
>> reply and it should be implemented in a separate patch. The original
>> fix is still valid.
>
> I think you could merge the fixes into a single patch.

Couple reasons I would prefer to keep them separate:
- I feel that descriptions for these two issues should be different
and it's easier if we don't mix them up
- This one is already merged into Android kernels, so would be easier
to introduce the second fix separately
- I would like to give credit to people who noticed the problem (in
this case those are different people)

However if more people think we should fix both issues in the same
patch I'll happily do that.
Thanks!

>
> -Kees
>
> --
> Kees Cook
> Pixel Security
