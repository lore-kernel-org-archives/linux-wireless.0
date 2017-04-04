Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43121 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753177AbdDDKJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 06:09:34 -0400
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        David Windsor <dwindsor@gmail.com>
Subject: RE: [PATCH 16/16] drivers, net, intersil: convert
 request_context.refcount from atomic_t to refcount_t
Date: Tue, 4 Apr 2017 10:07:55 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C8741B@IRSMSX102.ger.corp.intel.com> (sfid-20170404_121208_796186_E16CE845)
References: <1490691403-4016-1-git-send-email-elena.reshetova@intel.com>
        <1490691403-4016-17-git-send-email-elena.reshetova@intel.com>
 <87zifxn2gb.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zifxn2gb.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Elena Reshetova <elena.reshetova@intel.com> writes:
>=20
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> >
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: David Windsor <dwindsor@gmail.com>
> > ---
> >  drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 15 ++++++++-----=
--
> >  1 file changed, 8 insertions(+), 7 deletions(-)
>=20
> The prefix should be "orinoco_usb:", I'll fix that.

Thanks for both! Will you take the patches in?

Best Regards,
Elena.

>=20
> --
> Kalle Valo
