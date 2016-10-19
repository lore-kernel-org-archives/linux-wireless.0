Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59736 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbcJSQjv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 12:39:51 -0400
Subject: Re: crypto: aesni - add ccm(aes) algorithm implementation
To: linux-wireless@vger.kernel.org
References: <1476895046-16549-1-git-send-email-greearb@candelatech.com>
Cc: Yauhen Kharuzhy <jekhor@gmail.com>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <3e0552f3-b7f5-2ff3-1f63-9001bceb96f0@candelatech.com> (sfid-20161019_183954_933777_CBCC9036)
Date: Wed, 19 Oct 2016 09:39:49 -0700
MIME-Version: 1.0
In-Reply-To: <1476895046-16549-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/2016 09:37 AM, greearb@candelatech.com wrote:
> From: Yauhen Kharuzhy <jekhor@gmail.com>
>
> Add ccm(aes) implementation from linux-wireless mailing list (see
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/126679).
>
> This eliminates FPU context store/restore overhead existing in more
> general ccm_base(ctr(aes-aesni),aes-aesni) case in MAC calculation.
>
> Convert this patch to new AEAD API.
>
> Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

I've been using this patch or something similar for a while and it
significantly helps me with sw-crypt performance.  One version or another
has been around the internet for some time, and I am not the originator
of this code, but would still be happy to see it upstream if someone
can review and bless it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
