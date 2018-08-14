Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:55190 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728450AbeHOBIb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 21:08:31 -0400
Received: by mail-it0-f66.google.com with SMTP id s7-v6so20658327itb.4
        for <linux-wireless@vger.kernel.org>; Tue, 14 Aug 2018 15:19:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJB9wMDJnfsurpxsXm6_0WsWWCaTuWBfy+3aMSE_LL9Rw@mail.gmail.com>
References: <20180813223910.26276-1-surenb@google.com> <20180814095413.vbjkcjkmytkffyaz@mwanda>
 <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
 <CAJuCfpHSZuabLr6+t_n7UDamJCAP6EPTNEZ6kNqWOhk2mpYADg@mail.gmail.com>
 <CAGXu5jKqcpbpG0Ky4-yXV4d5q10HtGwJtdyPKcrwkJUPhA_Mpg@mail.gmail.com>
 <CAJuCfpEX69Sbd=0i0ismP6q2NsZGUF4gMSCr1G5NdXd3n1NyZA@mail.gmail.com> <CAGXu5jJB9wMDJnfsurpxsXm6_0WsWWCaTuWBfy+3aMSE_LL9Rw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 14 Aug 2018 15:19:14 -0700
Message-ID: <CAJuCfpEX+F-EPxQYXNdUg-uT9ecwYYdxBsr9y_69zQ0Fq50GeA@mail.gmail.com> (sfid-20180815_001933_895938_03898E53)
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

On Tue, Aug 14, 2018 at 2:49 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Aug 14, 2018 at 1:55 PM, Suren Baghdasaryan <surenb@google.com> wrote:
>> On Tue, Aug 14, 2018 at 1:33 PM, Kees Cook <keescook@chromium.org> wrote:
>>> On Tue, Aug 14, 2018 at 1:26 PM, Suren Baghdasaryan <surenb@google.com> wrote:
>>>> On Tue, Aug 14, 2018 at 9:57 AM, Suren Baghdasaryan <surenb@google.com> wrote:
>>>>> On Tue, Aug 14, 2018 at 2:54 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>>>>>> Thanks.  This is great.  I'm so glad these are finally getting fixed.
>>>>>>
>>>>>> Do we need to fix nfc_hci_msg_rx_work() and nfc_hci_recv_from_llc() as
>>>>>> well?  In nfc_hci_recv_from_llc() we allow pipe to be NFC_HCI_FRAGMENT
>>>>>> (0x7f) so that's one element beyond the end of the array and the
>>>>>> NFC_HCI_HCP_RESPONSE isn't checked.
>>>>>>
>>>>>> Also nci_hci_msg_rx_work() and nci_hci_data_received_cb() use
>>>>>> NCI_HCP_MSG_GET_PIPE() so those could be off by one.
>>>>>
>>>>> Good point. From hci.h:
>>>>>
>>>>> /*
>>>>>  * According to specification 102 622 chapter 4.4 Pipes,
>>>>>  * the pipe identifier is 7 bits long.
>>>>>  */
>>>>> #define NFC_HCI_MAX_PIPES 127
>>>>>
>>>>> And then:
>>>>>
>>>>> struct nfc_hci_dev {
>>>>>   ...
>>>>>   struct nfc_hci_pipe pipes[NFC_HCI_MAX_PIPES];
>>>>>   ...
>>>>> }
>>>>>
>>>>> I think the correct fix would be to change it to:
>>>>>
>>>>>   struct nfc_hci_pipe pipes[NFC_HCI_MAX_PIPES + 1];
>>>>>
>>>>> What do you think?
>>>>>

Actually, after looking more closely, NFC_HCI_MAX_PIPES is always used
as the number of supported pipes and not as the max pipe ID, so the
right fix would be:

-#define NFC_HCI_MAX_PIPES 127
+#define NFC_HCI_MAX_PIPES 128

I would prefer to rename it into NFC_HCI_PIPE_COUNT but don't want to
introduce unnecessary churn for one-line change, so will keep the
name. Will post a separate fix for this shortly.

>>>>
>>>> Just to be clear, this would fix the problem Dan described in his
>>>> reply and it should be implemented in a separate patch. The original
>>>> fix is still valid.
>>>
>>> I think you could merge the fixes into a single patch.
>>
>> Couple reasons I would prefer to keep them separate:
>> - I feel that descriptions for these two issues should be different
>> and it's easier if we don't mix them up
>> - This one is already merged into Android kernels, so would be easier
>> to introduce the second fix separately
>> - I would like to give credit to people who noticed the problem (in
>> this case those are different people)
>>
>> However if more people think we should fix both issues in the same
>> patch I'll happily do that.
>> Thanks!
>
> If it's already landed separately somewhere else, then yeah, 2 patches
> sounds good. No objection either way from me!
>
> -Kees
>
> --
> Kees Cook
> Pixel Security
