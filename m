Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977AbYBZPnV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 10:43:21 -0500
Subject: Re: [PATCH] libertas: Remove unused exports
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	rolandd@cisco.com
In-Reply-To: <200802261526.57001.hs4233@mail.mn-solutions.de>
References: <200802261526.57001.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 10:40:01 -0500
Message-Id: <1204040401.30146.41.camel@localhost.localdomain> (sfid-20080226_154327_478998_6255C700)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-26 at 15:26 +0100, Holger Schurig wrote:
> From: Roland Dreier <rdreier@cisco.com>
> 
> The libertas driver exports a number of symbols with no in-tree users;
> remove these unused exports.  lbs_reset_device() is completely unused, with
> no callers at all, so remove the function completely.
> 
> A couple of these unused exported symbols are static, which causes the
> following build error on ia64 with gcc 4.2.3:
> 
>     drivers/net/wireless/libertas/main.c:1375: error: __ksymtab_lbs_remove_mesh causes a section type conflict
>     drivers/net/wireless/libertas/main.c:1354: error: __ksymtab_lbs_add_mesh causes a section type conflict
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> Acked-by: Holger Schurig <hs4233@mail.mn-solutions.de>

I acked it on netdev too while forwarding to linux-wireless yesterday.
For completeness:

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> 
> Index: wireless-2.6/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/cmd.c	2008-02-26 11:53:55.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/cmd.c	2008-02-26 11:54:29.000000000 +0100
> @@ -1066,7 +1066,6 @@ int lbs_mesh_access(struct lbs_private *
>  	lbs_deb_leave(LBS_DEB_CMD);
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(lbs_mesh_access);
>  
>  int lbs_mesh_config(struct lbs_private *priv, uint16_t enable, uint16_t chan)
>  {
> @@ -1571,7 +1570,6 @@ done:
>  	lbs_deb_leave_args(LBS_DEB_HOST, "ret %d", ret);
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(lbs_prepare_and_send_command);
>  
>  /**
>   *  @brief This function allocates the command buffer and link
> Index: wireless-2.6/drivers/net/wireless/libertas/decl.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/decl.h	2008-02-26 11:54:33.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/decl.h	2008-02-26 11:54:44.000000000 +0100
> @@ -69,7 +69,6 @@ struct lbs_private *lbs_add_card(void *c
>  int lbs_remove_card(struct lbs_private *priv);
>  int lbs_start_card(struct lbs_private *priv);
>  int lbs_stop_card(struct lbs_private *priv);
> -int lbs_reset_device(struct lbs_private *priv);
>  void lbs_host_to_card_done(struct lbs_private *priv);
>  
>  int lbs_update_channel(struct lbs_private *priv);
> Index: wireless-2.6/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/main.c	2008-02-26 11:54:54.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/main.c	2008-02-26 11:55:28.000000000 +0100
> @@ -1366,8 +1366,6 @@ done:
>  	lbs_deb_leave_args(LBS_DEB_MESH, "ret %d", ret);
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(lbs_add_mesh);
> -
>  
>  static void lbs_remove_mesh(struct lbs_private *priv)
>  {
> @@ -1387,7 +1385,6 @@ static void lbs_remove_mesh(struct lbs_p
>  	free_netdev(mesh_dev);
>  	lbs_deb_leave(LBS_DEB_MESH);
>  }
> -EXPORT_SYMBOL_GPL(lbs_remove_mesh);
>  
>  /**
>   *  @brief This function finds the CFP in
> @@ -1473,20 +1470,6 @@ void lbs_interrupt(struct lbs_private *p
>  }
>  EXPORT_SYMBOL_GPL(lbs_interrupt);
>  
> -int lbs_reset_device(struct lbs_private *priv)
> -{
> -	int ret;
> -
> -	lbs_deb_enter(LBS_DEB_MAIN);
> -	ret = lbs_prepare_and_send_command(priv, CMD_802_11_RESET,
> -				    CMD_ACT_HALT, 0, 0, NULL);
> -	msleep_interruptible(10);
> -
> -	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(lbs_reset_device);
> -
>  static int __init lbs_init_module(void)
>  {
>  	lbs_deb_enter(LBS_DEB_MAIN);

