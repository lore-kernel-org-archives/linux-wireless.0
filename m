Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42594 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbeDELam (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 07:30:42 -0400
Message-ID: <1522927835.7140.8.camel@sipsolutions.net> (sfid-20180405_133048_123061_16F6A54B)
Subject: Re: [PATCH] rsi: Free the unaligned pointer
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Thu, 05 Apr 2018 13:30:35 +0200
In-Reply-To: <20180405112311.GD4218@mwanda> (sfid-20180405_132330_784628_CEF256B5)
References: <20180405112311.GD4218@mwanda>
         (sfid-20180405_132330_784628_CEF256B5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-04-05 at 14:23 +0300, Dan Carpenter wrote:
> The problem here is that we allocate "data".  Then we do
> "data = PTR_ALIGN(data, 8);" and then we free the aligned pointer and
> not the one we allocated.

That seems pretty pointless, since kmalloc guarantees such alignment for
sure. Better to just remove PTR_ALIGN()?

johannes
