Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:28350 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751757AbeFIJwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Jun 2018 05:52:02 -0400
Date: Sat, 9 Jun 2018 11:51:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Dmitry Shmidt <dimitrysh@google.com>,
        Todd Kjos <tkjos@google.com>,
        Android Kernel Team <kernel-team@android.com>,
        Stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3 1/4] NFC: st21nfca: Fix out of bounds kernel access
 when handling ATR_REQ
Message-ID: <20180609095146.GA25115@caravaggio.jf.intel.com> (sfid-20180609_115220_619331_F7B5EE66)
References: <1525372736-25094-1-git-send-email-amit.pundir@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525372736-25094-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Fri, May 04, 2018 at 12:08:53AM +0530, Amit Pundir wrote:
> From: Suren Baghdasaryan <surenb@google.com>
> 
> Out of bounds kernel accesses in st21nfca's NFC HCI layer
> might happen when handling ATR_REQ events if user-specified
> atr_req->length is bigger than the buffer size. In
> that case memcpy() inside st21nfca_tm_send_atr_res() will
> read extra bytes resulting in OOB read from the kernel heap.
> 
> cc: Stable <stable@vger.kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
> v3..v1:
> Resend. No changes.
> 
>  drivers/nfc/st21nfca/dep.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
All 4 patches applied to nfc-next, thanks.

Cheers,
Samuel.
