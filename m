Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42510 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbZATSTG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 13:19:06 -0500
Subject: Re: [PATCHv2] iwlagn: fix hw-rfkill while the interface is down
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"mabbaswireless@gmail.com" <mabbaswireless@gmail.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"samuel@sortiz.org" <samuel@sortiz.org>
In-Reply-To: <200901191310.08654.helmut.schaa@gmail.com>
References: <200901191310.08654.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 10:21:05 -0800
Message-Id: <1232475665.11197.77.camel@rc-desk> (sfid-20090120_191913_396171_1982A73C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-19 at 04:10 -0800, Helmut Schaa wrote:
> Currently iwlagn is not able to report hw-killswitch events while the
> interface is down. This has implications on user space tools (like
> NetworkManager) relying on rfkill notifications to bring the interface
> up once the wireless gets enabled through a hw killswitch.
> 
> Thus, enable the device already in iwl_pci_probe instead of iwl_up
> and enable interrups while the interface is down in order to get
> notified about killswitch state changes. The firmware loading is still
> done in iwl_up.
> 
> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> ---
> 

<...>


> +               if (!test_bit(STATUS_ALIVE, &priv->status)) {

Is this test necessary? If the intention is to get rfkill state updates
when interface is down (and ucode is thus not loaded, and STATUS_ALIVE
thus not set) then this test is not necessary.

> +                       if (hw_rf_kill)
> +                               set_bit(STATUS_RF_KILL_HW, &priv->status);
> +                       else
> +                               clear_bit(STATUS_RF_KILL_HW, &priv->status);
> +                       queue_work(priv->workqueue, &priv->rf_kill);
>                 }
> 
>                 handled |= CSR_INT_BIT_RF_KILL;
> @@ -2158,7 +2161,8 @@ static void iwl_bg_rf_kill(struct work_struct *work)
>                 IWL_DEBUG(IWL_DL_RF_KILL,
>                           "HW and/or SW RF Kill no longer active, restarting "
>                           "device\n");
> -               if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> +               if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
> +                    test_bit(STATUS_ALIVE, &priv->status))

This ties in with the question above. Above the work is scheduled when
STATUS_ALIVE is not set ... having this test here encourages me to think
that the above test for STATUS_ALIVE is not necessary.

The rest of the patch looks good.

Thank you very much

Reinette



