Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out6.electric.net ([192.162.217.189]:57882 "EHLO
        smtp-out6.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754333AbdC1KBE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:01:04 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: 'Elena Reshetova' <elena.reshetova@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-hams@vger.kernel.org" <linux-hams@vger.kernel.org>,
        "linux-ppp@vger.kernel.org" <linux-ppp@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ganeshgr@chelsio.com" <ganeshgr@chelsio.com>,
        "nbd@openwrt.org" <nbd@openwrt.org>,
        "blogic@openwrt.org" <blogic@openwrt.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "yishaih@mellanox.com" <yishaih@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "matanb@mellanox.com" <matanb@mellanox.com>,
        "leonro@mellanox.com" <leonro@mellanox.com>,
        "ajk@comnets.uni-bremen.de" <ajk@comnets.uni-bremen.de>,
        "paulus@samba.org" <paulus@samba.org>, "j@w1.fi" <j@w1.fi>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        "David Windsor" <dwindsor@gmail.com>
Subject: RE: [PATCH 06/16] drivers, net, mlx5: convert mlx5_cq.refcount from
 atomic_t to refcount_t
Date: Tue, 28 Mar 2017 09:33:21 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6DCFFBE8AF@AcuExch.aculab.com> (sfid-20170328_120403_239368_FE463905)
References: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
 <1490691403-4016-7-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1490691403-4016-7-git-send-email-elena.reshetova@intel.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Elena Reshetova
> Sent: 28 March 2017 09:57
> 
> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.

I can't help feeling that you ought to find a scheme
that will detect extra decrements and extra increments
before the counter wraps 32 bits.

If an extra reference is requested every 100us it takes 4.8 days
for the counter to increment back to zero.
Simple tests aren't doing to find that - but it can easily happen
on a system that is running for several years.

	David
