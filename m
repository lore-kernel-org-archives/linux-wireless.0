Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:12646 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932091AbdDPWpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Apr 2017 18:45:53 -0400
Date: Mon, 17 Apr 2017 00:45:49 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nfc: fix get_unaligned_...() misuses
Message-ID: <20170416224537.GB694@zurbaran.ger.intel.com> (sfid-20170417_004620_230706_3BD7C933)
References: <20170406164847.GU29622@ZenIV.linux.org.uk>
 <20170406165859.GV29622@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170406165859.GV29622@ZenIV.linux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 06, 2017 at 05:58:59PM +0100, Al Viro wrote:
> On Thu, Apr 06, 2017 at 05:48:47PM +0100, Al Viro wrote:
> > * use unaligned.h, not unaligned/access_ok.h
> 
> ... which got misspelled in that patch, sorry...  Fixed variant follows:
> 
> commit b3e79ba1708c9b74781079c9f8617448fce36b51
> Author: Al Viro <viro@zeniv.linux.org.uk>
> Date:   Thu Apr 6 12:42:14 2017 -0400
> 
>     nfc: fix get_unaligned_...() misuses
>     
>     * use unaligned.h, not unaligned/access_ok.h
>     * if a local variable of type uint16_t is unaligned, your compiler is FUBAR
>     * the whole point of get_unaligned_... is to avoid memcpy + ..._to_cpu().
>       Using it *after* memcpy() (into aligned object, no less) is pointless.
>     
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Partly applied to nfc-next. The unaligned/access_ok.h replacements were
already applied.

Cheers,
Samuel.
