Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbYCZOYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 10:24:25 -0400
Subject: Re: [PATCH] libertas: reduce debug output
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803261004.45032.hs4233@mail.mn-solutions.de>
References: <200803261004.45032.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 10:23:16 -0400
Message-Id: <1206541396.30998.13.camel@localhost.localdomain> (sfid-20080326_142429_975645_05FD41F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 10:04 +0100, Holger Schurig wrote:
> This patch tries to make dmesg logs between different runs easier
> to compare by
> 
> * removing the jiffies (use CONFIG_PRINTK_TIME if you need
>   timing)
> * remove the line numbers, they change with each applied patch
> 
> It also changes the deprecated __FUNCTION__ to __func__ to make
> checkpatch.pl happy.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> ----
> 
> To debug and test changes, I quite often do something like this:
> 
> <empty /var/log/syslog>
> <modprobe>
> <use lbsdebug to set desired debug output>
> (sleep 1; ifup eth1;) &
> tail -f /var/log/syslog # | grep libertas | cut -d: -f4- | cut -c2-
> 
> The output from those runs are now much better comparable
> with "diff".
> 
> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-19 14:34:25.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-19 14:34:40.000000000 +0100
> @@ -1203,8 +1203,8 @@ static void lbs_submit_command(struct lb
>  	    command == CMD_802_11_AUTHENTICATE)
>  		timeo = 10 * HZ;
>  
> -	lbs_deb_cmd("DNLD_CMD: command 0x%04x, seq %d, size %d, jiffies %lu\n",
> -		     command, le16_to_cpu(cmd->seqnum), cmdsize, jiffies);
> +	lbs_deb_cmd("DNLD_CMD: command 0x%04x, seq %d, size %d\n",
> +		     command, le16_to_cpu(cmd->seqnum), cmdsize);
>  	lbs_deb_hex(LBS_DEB_CMD, "DNLD_CMD", (void *) cmdnode->cmdbuf, cmdsize);
>  
>  	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmd, cmdsize);
> Index: wireless-testing/drivers/net/wireless/libertas/cmdresp.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 14:34:43.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmdresp.c	2008-03-19 14:34:49.000000000 +0100
> @@ -420,8 +420,8 @@ int lbs_process_rx_command(struct lbs_pr
>  	respcmd = le16_to_cpu(resp->command);
>  	result = le16_to_cpu(resp->result);
>  
> -	lbs_deb_cmd("CMD_RESP: response 0x%04x, seq %d, size %d, jiffies %lu\n",
> -		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len, jiffies);
> +	lbs_deb_cmd("CMD_RESP: response 0x%04x, seq %d, size %d\n",
> +		     respcmd, le16_to_cpu(resp->seqnum), priv->upld_len);
>  	lbs_deb_hex(LBS_DEB_CMD, "CMD_RESP", (void *) resp, priv->upld_len);
>  
>  	if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
> Index: wireless-testing/drivers/net/wireless/libertas/defs.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/defs.h	2008-03-19 14:34:56.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/defs.h	2008-03-19 14:39:22.000000000 +0100
> @@ -53,14 +53,14 @@ do { if ((lbs_debug & (grp)) == (grp)) \
>  #endif
>  
>  #define lbs_deb_enter(grp) \
> -  LBS_DEB_LL(grp | LBS_DEB_ENTER, " enter", "%s():%d\n", __FUNCTION__, __LINE__);
> +  LBS_DEB_LL(grp | LBS_DEB_ENTER, " enter", "%s()\n", __func__);
>  #define lbs_deb_enter_args(grp, fmt, args...) \
> -  LBS_DEB_LL(grp | LBS_DEB_ENTER, " enter", "%s(" fmt "):%d\n", __FUNCTION__, ## args, __LINE__);
> +  LBS_DEB_LL(grp | LBS_DEB_ENTER, " enter", "%s(" fmt ")\n", __func__, ## args);
>  #define lbs_deb_leave(grp) \
> -  LBS_DEB_LL(grp | LBS_DEB_LEAVE, " leave", "%s():%d\n", __FUNCTION__, __LINE__);
> +  LBS_DEB_LL(grp | LBS_DEB_LEAVE, " leave", "%s()\n", __func__);
>  #define lbs_deb_leave_args(grp, fmt, args...) \
> -  LBS_DEB_LL(grp | LBS_DEB_LEAVE, " leave", "%s():%d, " fmt "\n", \
> -  __FUNCTION__, __LINE__, ##args);
> +  LBS_DEB_LL(grp | LBS_DEB_LEAVE, " leave", "%s(), " fmt "\n", \
> +  __func__, ##args);
>  #define lbs_deb_main(fmt, args...)      LBS_DEB_LL(LBS_DEB_MAIN, " main", fmt, ##args)
>  #define lbs_deb_net(fmt, args...)       LBS_DEB_LL(LBS_DEB_NET, " net", fmt, ##args)
>  #define lbs_deb_mesh(fmt, args...)      LBS_DEB_LL(LBS_DEB_MESH, " mesh", fmt, ##args)

