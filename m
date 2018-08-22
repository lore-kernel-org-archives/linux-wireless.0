Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57190 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728500AbeHVQ5b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 12:57:31 -0400
Date: Wed, 22 Aug 2018 15:32:28 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] rt2x00: use simple_read_from_buffer()
Message-ID: <20180822133227.GA2019@redhat.com> (sfid-20180822_153238_006281_2C19A803)
References: <20180822104126.2logh4tqxkmiomqy@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180822104126.2logh4tqxkmiomqy@kili.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 22, 2018 at 01:41:26PM +0300, Dan Carpenter wrote:
> The problem with this copy_to_user() calls is that they don't ensure
> that "size" is less than the "length" which the user provided.
> 
> Obviously, this is debugfs and "size" is normally going to be very small
> so it probably doesn't matter, but this is the correct thing to do.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
