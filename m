Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0088.outbound.protection.outlook.com ([104.47.40.88]:4827
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752935AbdFVIZY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 04:25:24 -0400
Date: Thu, 22 Jun 2017 11:24:58 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Colin King <colin.king@canonical.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Bindu Therthala <btherthala@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][net-next] qtnfmac: fix uninitialized return code in ret
Message-ID: <20170622082434.nvwja6onp46vwjce@bars> (sfid-20170622_102637_868034_8C9933B4)
References: <20170621132530.11937-1-colin.king@canonical.com>
 <20170622051041.6vclukrzlq4zbdhm@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170622051041.6vclukrzlq4zbdhm@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Not related to your patch but qtnf_map_bar() should be changed not to
> return NULL.  When functions return both NULL and error pointers the
> NULL is supposed to be a special type of success return.  Here it is
> just a fail return where we forgot to set the error code to
> ERR_PTR(-ENOMEM).

Thanks for reporting! FWIW it is not a bug, all the checks of pci maps
are in place. Though having both ERR_PTR and NULL in return indeed
looks confusing. We will add a fix in the upcoming cleanup series.

Regards,
Sergey
