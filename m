Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:8282 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbYGQLZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 07:25:49 -0400
Subject: Re: [PATCH net-next 2/2] iwlwifi: small compile warnings without
	CONFIG_IWLWIFI_DEBUG
From: "Denis V. Lunev" <den@openvz.org>
To: Tomas Winkler <tomasw@gmail.com>
Cc: davem@davemloft.net, yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <1ba2fa240807170408w13837d67hcfd1be50fdb07738@mail.gmail.com>
References: <1216286365-11703-1-git-send-email-den@openvz.org>
	 <1216286365-11703-2-git-send-email-den@openvz.org>
	 <1ba2fa240807170408w13837d67hcfd1be50fdb07738@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 15:26:27 +0400
Message-Id: <1216293987.7034.5.camel@iris.sw.ru> (sfid-20080717_132552_931150_3070882D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-07-17 at 14:08 +0300, Tomas Winkler wrote:
> On Thu, Jul 17, 2008 at 12:19 PM, Denis V. Lunev <den@openvz.org> wrote:
> > CC [M]  drivers/net/wireless/iwlwifi/iwl-4965-rs.o
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_clear':
> > drivers/net/wireless/iwlwifi/iwl-4965-rs.c:2405: warning: unused variable 'priv'
> > CC [M]  drivers/net/wireless/iwlwifi/iwl-scan.o
> > drivers/net/wireless/iwlwifi/iwl-scan.c: In function 'iwl_rx_scan_complete_notif':
> > drivers/net/wireless/iwlwifi/iwl-scan.c:274: warning: unused variable 'scan_notif'
> >
> > Signed-off-by: Denis V. Lunev <den@openvz.org>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-4965-rs.c |    2 ++
> >  drivers/net/wireless/iwlwifi/iwl-scan.c    |    2 ++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> > index 3ccb84a..7549834 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
> > @@ -2402,7 +2402,9 @@ static void rs_free(void *priv_rate)
> >
> >  static void rs_clear(void *priv_rate)
> >  {
> > +#ifdef CONFIG_IWLWIFI_DEBUG
> >        struct iwl_priv *priv = (struct iwl_priv *) priv_rate;
> > +#endif
> >
> >        IWL_DEBUG_RATE("enter\n");
> 
> move #endif after debug print

Are you proposing to do this?
static void rs_clear(void *priv_rate)
{
#ifdef CONFIG_IWLWIFI_DEBUG
        struct iwl_priv *priv = (struct iwl_priv *) priv_rate;

        IWL_DEBUG_RATE("enter\n");

        /* TODO - add rate scale state reset */

        IWL_DEBUG_RATE("leave\n");
#endif
}
this seems wrong to me, as there are pending actions inside.

It looks like you do not have warning as previously these calls are
static inlines. So, my patch seems better for the place.

If you agree with this, I'll resend the patch with
iwl_rx_scan_results_notif modified.

Regards,
	Den

