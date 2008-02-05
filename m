Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:21110 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932416AbYBEXgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 18:36:54 -0500
Received: by wa-out-1112.google.com with SMTP id v27so146771wah.23
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2008 15:36:53 -0800 (PST)
Message-ID: <1ba2fa240802051536y2aac90f1g1e9d3495df9b8bb@mail.gmail.com> (sfid-20080205_233711_290076_42B66341)
Date: Wed, 6 Feb 2008 01:36:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/1] mac80211: fix mis-match in {test,set}_bit qdisc_pool
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <20080205205453.GJ4252@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020756782190-git-send-email-tomas.winkler@intel.com>
	 <20080205205453.GJ4252@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 5, 2008 10:54 PM, John W. Linville <linville@tuxdriver.com> wrote:
> On Sun, Feb 03, 2008 at 11:54:38PM +0200, Tomas Winkler wrote:
> > From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> >
> > This patch fixes a mis-match in {test,set}_bit for qdisc_pool created by
> > the move to an array of bits.
> >
> > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>
>   CC [M]  net/mac80211/wme.o
> net/mac80211/wme.c: In function 'wme_qdiscop_enqueue':
> net/mac80211/wme.c:161: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> net/mac80211/wme.c:161: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> net/mac80211/wme.c:194: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> net/mac80211/wme.c:194: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> net/mac80211/wme.c: In function 'wme_qdiscop_dequeue':
> net/mac80211/wme.c:275: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> net/mac80211/wme.c:275: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> net/mac80211/wme.c: In function 'wme_qdiscop_init':
> net/mac80211/wme.c:399: warning: passing argument 2 of 'set_bit' makes pointer from integer without a cast
> net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_add':
> net/mac80211/wme.c:660: warning: passing argument 2 of 'test_and_set_bit' makes pointer from integer without a cast
> net/mac80211/wme.c:673: error: subscripted value is neither array nor pointer
> net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_remove':
> net/mac80211/wme.c:693: warning: passing argument 2 of 'clear_bit' makes pointer from integer without a cast
> make[1]: *** [net/mac80211/wme.o] Error 1
> make: *** [net/mac80211/] Error 2
>
> Am I missing something?

This patch should fix warning that was caused Ron's patch

'adjustable number of bits for qdisc pool'

Thanks
Tomas

> John
> --
> John W. Linville
> linville@tuxdriver.com
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
