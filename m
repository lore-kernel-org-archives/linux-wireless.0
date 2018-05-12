Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60845 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbeELJGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 05:06:21 -0400
Date: Sat, 12 May 2018 09:06:19 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Andres Rodriguez <andresx7@gmail.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, hdegoede@redhat.com,
        Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] firmware: print firmware name on fallback path
Message-ID: <20180512090619.GL27853@wotan.suse.de> (sfid-20180512_110635_857619_A1547467)
References: <20180423201205.20533-1-andresx7@gmail.com>
 <20180423201205.20533-7-andresx7@gmail.com>
 <20180503234235.GX27853@wotan.suse.de>
 <8736yxb8rb.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8736yxb8rb.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 12, 2018 at 11:03:52AM +0300, Kalle Valo wrote:
> (sorry for the delay, this got buried in my inbox)
> 
> "Luis R. Rodriguez" <mcgrof@kernel.org> writes:
> 
> > On Mon, Apr 23, 2018 at 04:12:02PM -0400, Andres Rodriguez wrote:
> >> Previously, one could assume the firmware name from the preceding
> >> message: "Direct firmware load for {name} failed with error %d".
> >> 
> >> However, with the new firmware_request_nowarn() entrypoint, the message
> >> outlined above will not always be printed.
> >
> > I though the whole point was to not print an error message. What if
> > we want later to disable this error message? This would prove a bit
> > pointless.
> >
> > Let's discuss the exact semantics desired here. Why would only the
> > fallback be desirable here?
> >
> > Andres, Kalle?
> 
> So from ath10k point of view we do not want to have any messages printed
> when calling firmware_request_nowarn(). The warnings get users really
> confused when ath10k is checking if an optional firmware file is
> available or not.

I figured, that is the intended functionality now.

  Luis
