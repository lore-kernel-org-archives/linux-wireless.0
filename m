Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f173.google.com ([209.85.216.173]:36896 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3GLOnh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jul 2013 10:43:37 -0400
Received: by mail-qc0-f173.google.com with SMTP id l10so5035816qcy.18
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jul 2013 07:43:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951035636368@SC-VEXCH1.marvell.com>
References: <CAMLZHHSFEoOJ3W+nyJUqzGTKy=8TEB6mSibrXN6ze1xzGHv35Q@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951035636368@SC-VEXCH1.marvell.com>
Date: Fri, 12 Jul 2013 08:43:35 -0600
Message-ID: <CAMLZHHTE-AQ3ou+rNtqKGQdQ5UuvnABye22kjPGFeEkezP4dTw@mail.gmail.com> (sfid-20130712_164340_407799_71C63BFE)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 12, 2013 at 7:14 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Daniel,
>
>> Hmm. Now that I heard back from you and Bing, that interrupts at this
>> point are totally unexpected, I would prefer to see the interrupt
>> handler being disabled at the appropriate time, I think we can do
>> better than my original patch. Let me see if I can find some time
>> today/tomorrow to explore a better approach.
>
>>What about this one?
>
> The patch looks fine to me.
> Some comments
> 1) Unused HOST_INT_DISABLE macro can be removed now.
> 2) if_ops.disable_int() should be called before if_ops.unregister_dev() even in driver load failure code path. Otherwise we will miss to release sdio irq in this case.
> (You can consider applying attached changes on top of your patch for (1) and (2))
>
> 3) Previously we used to have error handling for sdio_claim_irq(). Now we should check return status of if_ops.enable_int(). As I have couple of other patches to handle driver load failure paths correctly, I will take care of this separately.
>
> 4) I will create separate patch to avoid forward declaration of mwifiex_sdio_interrupt() by moving some code.

Thanks for looking at it, all your comments make sense. In your diff
that you provided, I don't understand why you had to modify the
mwifiex_add_card error path to disable the interrupt though. If there
were any failures the interrupt handler will already have been
disabled by your fixes to the mwifiex_fw_dpc() error handling path,
right?

Daniel
