Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:64439 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756922AbZJGSBv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2009 14:01:51 -0400
Received: by fxm27 with SMTP id 27so4862026fxm.17
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2009 11:01:13 -0700 (PDT)
Message-ID: <4ACCD765.7080604@lwfinger.net>
Date: Wed, 07 Oct 2009 13:01:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Albert Herranz <albert_herranz@yahoo.es>
CC: bcm43xx-dev@lists.berlios.de, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] b43: do not stack-allocate pio rx/tx header and tail
 buffers
References: <200910062252.17565.mb@bu3sch.de> <1254866864-18265-1-git-send-email-albert_herranz@yahoo.es> <4ACCC516.7050002@lwfinger.net> <4ACCC893.1010402@yahoo.es>
In-Reply-To: <4ACCC893.1010402@yahoo.es>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Albert Herranz wrote:
> Larry Finger wrote:
>> Albert Herranz wrote:
> 
> b43_new_kidx_api() (defined in xmit.h) needs struct b43_wldev defined because it dereferences it.
> With this patch, struct b43_wl (defined in b43.h) needs struct b43_rxhdr_fw4 and struct b43_txhdr (defined in xmit.h).
> 
> So we have b43_wldev -> b43_rxhdr_fw4, b43_txhdr -> b43_wl (at least).
> 
> Moving the definition of struct b43_wl after the definition of struct b43_wldev and placing the inclusion of xmit.h between them gets rid of the generated dependencies.
> 
> The patch hints too to other possible solution.
> 
>> /*
>> * Include goes here to avoid a dependency problem.
>> * A better fix would be to integrate xmit.h into b43.h.
>> */
>> #include "xmit.h"
> 
> Do you have any other solutions in mind?

No. I missed the hint. At first I thought there was a white-space
problem that caused b43_wl to be replaced. When that was not the case,
I posed my question.

All seems OK.

Larry
