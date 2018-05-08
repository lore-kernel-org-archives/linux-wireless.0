Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53445 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753627AbeEHAU6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 20:20:58 -0400
Date: Tue, 8 May 2018 00:20:55 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com, Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] firmware: print firmware name on fallback path
Message-ID: <20180508002055.GY27853@wotan.suse.de> (sfid-20180508_022113_250258_651E3A17)
References: <20180423201205.20533-1-andresx7@gmail.com>
 <20180423201205.20533-7-andresx7@gmail.com>
 <20180503234235.GX27853@wotan.suse.de>
 <e79fe68b-7dc5-b65a-e483-287c91d67bc2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e79fe68b-7dc5-b65a-e483-287c91d67bc2@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 04, 2018 at 10:57:26PM -0400, Andres Rodriguez wrote:
> On 2018-05-03 07:42 PM, Luis R. Rodriguez wrote:
> > On Mon, Apr 23, 2018 at 04:12:02PM -0400, Andres Rodriguez wrote:
> > > Previously, one could assume the firmware name from the preceding
> > > message: "Direct firmware load for {name} failed with error %d".
> > > 
> > > However, with the new firmware_request_nowarn() entrypoint, the message
> > > outlined above will not always be printed.
> > 
> > I though the whole point was to not print an error message. What if
> > we want later to disable this error message? This would prove a bit
> > pointless.
> > 
> > Let's discuss the exact semantics desired here. Why would only the
> > fallback be desirable here?
> > 
> > Andres, Kalle?
> > 
> > After we address this I'll address resubmitting this lat patch
> > along with the last one. For now I'll skip it.
> 
> You are correct. I initially thought it would be useful to know that the
> usermode fallback was being triggered. And for that message to be useful we
> would need a fw name.
> 
> But now that you point it out, this behaviour is inconsistent with the
> _nowarn() definition. We shouldn't have a message in the first place.
> 
> So it might be better to instead have:
> 
> if (!(opt_flags & FW_OPT_NO_WARN) )
>     dev_warn(device, "Falling back to user helper\n");
> 
> No need to add the firmware name, cause we either:
>     a) FW_OPT_NO_WARN is set and no messages are printed, or
>     b) FW_OPT_NO_WARN is not set and we get both messages.
> 
> Yay, nay?

I welcome such a new warning but not for any of the reasons stated.

It make sense if FW_OPT_NO_WARN is not set and only because the fallback
mechanism can fail for a slew of different firmware files, and just getting
informed a failure with a fallback occurred does not tell us for which file it
failed for.

I'll add such a patch to my queue and send it off soon prior to your own
new API nowarn call.

  Luis
