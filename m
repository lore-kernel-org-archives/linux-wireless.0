Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab0IJFDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 01:03:10 -0400
Date: Fri, 10 Sep 2010 07:03:26 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 13/14] iwlwifi: cleanup scan initiate check
Message-ID: <20100910050325.GB2398@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <1284040354-31703-14-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDC82@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501280FDC82@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Wey

On Thu, Sep 09, 2010 at 08:46:57AM -0700, Guy, Wey-Yi W wrote:
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -361,7 +361,7 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
> 
>         cancel_delayed_work(&priv->scan_check);
> 
> -       if (!iwl_is_ready(priv)) {
> +       if (!iwl_is_ready_rf(priv)) {
>                 IWL_WARN(priv, "request scan called when driver not ready.\n");
>                 return -EIO;
>         }
> @@ -372,26 +372,11 @@ static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
>                 return -EBUSY;
>         }
> 
> -       if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
> -               IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
> -               return -EIO;
> -       }
> -
>         if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
>                 IWL_DEBUG_HC(priv, "Scan request while abort pending.\n");
>                 return -EBUSY;
>         }
> 
> -       if (iwl_is_rfkill(priv)) {
> -               IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
> -               return -EIO;
> -       }
> -
> -       if (!test_bit(STATUS_READY, &priv->status)) {
> -               IWL_DEBUG_HC(priv, "Scan request while uninitialized.\n");
> -               return -EBUSY;
> -       }
> -
>         IWL_DEBUG_INFO(priv, "Starting %sscan...\n",
>                         internal ? "internal short " : "");
> 
> 
> Same cleanup for 3945?

It's common code, we merge it in patch 2.

Stanislaw
