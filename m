Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33188 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab2HIUs1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 16:48:27 -0400
Date: Thu, 9 Aug 2012 16:48:10 -0400
From: Pavel Roskin <proski@gnu.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] ath9k: decrypt_error flag issue
Message-ID: <20120809164810.20c89c59@mj> (sfid-20120809_224831_082905_19494044)
In-Reply-To: <CAD2nsn3qwus1fZiGrcTmOiEOqPJHKDhHXmuJd7c=WWK5U=5JNw@mail.gmail.com>
References: <CAA2SeNLv9pE_3_-99Df_s0gF+56O6TFjfDfV-QuVxsOc6_Z5TQ@mail.gmail.com>
	<20120808164813.0011148e@mj>
	<CAA2SeNLHW=wA9nVG5YS5938vO7nZCJxMT8KiJCooPrFkvrv77g@mail.gmail.com>
	<CAD2nsn3qwus1fZiGrcTmOiEOqPJHKDhHXmuJd7c=WWK5U=5JNw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 9 Aug 2012 18:21:59 +0530
Mohammed Shafi <shafi.wireless@gmail.com> wrote:

> > Assume hw reports a decryption error, the flag decrypt_error is set
> > to true in ath9k_rx_accept.
> > Since this flag is initialized to false just out of  ath_rx_tasklet
> > while cycle, all subsequent frames are marked as corrupted until
> > ath_rx_tasklet ends.
> 
> seems to be a nice catch!
> It would be great if we can simulate this situation (ie
> decrypt_error is set to true, and subsequent frames are discarded)
> may be we can try this some time, purposefully setting the
> decrypt_error 'true' for the first instance and see if there is data
> loss/throughput diff because of this.

That simulation might be too much work.  The only affected frames would
be those that are processed in the same tasklet as the frame with
decryption error.  What frame is processed in which tasklet is
timing-dependent.

It's enough to see that the code is wrong as it is.

ath9k_rx_accept() only sets decrypt_error to true and never to false.
It's not my favorite way of handling errors, but it's OK.

ath9k_rx_skb_preprocess() calls ath9k_rx_accept() and never writes or
reads decrypt_error in any other way.

ath_rx_tasklet() calls ath9k_rx_skb_preprocess() in a loop over the
frames to be processed.  Then it calls ath9k_rx_skb_postprocess() and
passes decrypt_error to it.  So we can have a leftover value from
another frame passed there.  In that case, the frame won't me marked as
decrypted.

I think it would be nice to examine all the variables initialized
outside the loop in ath_rx_tasklet().  There may be more catches
waiting to be discovered.

-- 
Regards,
Pavel Roskin
