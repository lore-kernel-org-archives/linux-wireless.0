Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:34661 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752036AbeECKVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 06:21:34 -0400
Message-ID: <1525342889.21176.636.camel@linux.intel.com> (sfid-20180503_122205_153521_35E1A8D2)
Subject: Re: [PATCH v2 0/3] Few NFC fixes from android-4.14 tree
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Amit Pundir <amit.pundir@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>
Date: Thu, 03 May 2018 13:21:29 +0300
In-Reply-To: <1525283288-7027-1-git-send-email-amit.pundir@linaro.org>
References: <1525283288-7027-1-git-send-email-amit.pundir@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-02 at 23:18 +0530, Amit Pundir wrote:
> Hi,
> 
> Submitting v2 of NFC fixes I picked up from android-4.14 tree[1]
> for review and comments.
> 
> Again like to point out that I have not feature tested these patches
> at all. Only made small cosmetic changes to the original patches
> (removed Android-only tag and internal bug ID) and build tested for
> arm, before posting them here for review.
> 
> Really appreciate any comments or feedback on how to take it forward.
> 
> Changes since v1:
> * Dropped "NFC: st21nfca: Fix memory OOB and leak issues in
> connectivity
>   events handler" patch for now. I'm yet to verify if the additional
>   aid_len and params_len checks for buffer size are really required,
> and
>   I didn't want to hold up this patch series for one patch alone.
> * Dropped redundant __func__ use dev_dbg() in "NFC: fdp: Fix possible
>   buffer overflow in WCS4000 NFC driver" patch.
> 
> Also drivers/nfc/fdp/ is full of __func__ parameter usage in
> dev_dbg(),
> so submitting a new patch separately to clean that up.
> 

After addressing one comment, FWIW,

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

> Regards,
> Amit Pundir
> [1] https://android.googlesource.com/kernel/common/+log/android-4.14
> 
> Suren Baghdasaryan (3):
>   NFC: st21nfca: Fix out of bounds kernel access when handling ATR_REQ
>   NFC: Fix possible memory corruption when handling SHDLC I-Frame
>     commands
>   NFC: fdp: Fix possible buffer overflow in WCS4000 NFC driver
> 
>  drivers/nfc/fdp/fdp.c      | 22 +++++++++++-----------
>  drivers/nfc/fdp/i2c.c      | 29 ++++++++++++++++++-----------
>  drivers/nfc/st21nfca/dep.c |  3 ++-
>  net/nfc/hci/core.c         | 10 ++++++++++
>  4 files changed, 41 insertions(+), 23 deletions(-)
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
