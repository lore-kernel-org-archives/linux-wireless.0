Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:33905 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbeDFIpD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 04:45:03 -0400
Received: by mail-qk0-f174.google.com with SMTP id g7so372162qkm.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2018 01:45:03 -0700 (PDT)
Subject: Re: [PATCH v2] rsi: remove unecessary PTR_ALIGN()s
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20180406083717.GA21857@mwanda>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AC7338C.3000307@broadcom.com> (sfid-20180406_104509_889665_065CEBF2)
Date: Fri, 6 Apr 2018 10:45:00 +0200
MIME-Version: 1.0
In-Reply-To: <20180406083717.GA21857@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/6/2018 10:37 AM, Dan Carpenter wrote:
> The issue here is that we allocate "data" and then set
> "data = PTR_ALIGN(data, 8);" and then we free the aligned pointer
> instead of the original pointer.
>
> kmalloc() pointers are already ARCH_SLAB_MINALIGN aligned which is 8 or
> more on everything except certain Xtensa variants.  We decided that if
> the Xtensa people ever notice a bug here then we'll tell them the bug is
> on their side.  ;)

I am not sure if it was decided to be a xtensa bug, but just to ignore 
the issue until it would arise. Anyway, not sure if the last sentence is 
useful in the commit message.

Regards,
Arend
