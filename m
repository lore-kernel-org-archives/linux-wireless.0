Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYI2VAU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 17:00:20 -0400
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control
	via SIOCSIWTXPOW.
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Anna Neal <anna@cozybit.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <20080926162643.GB3483@tuxdriver.com>
References: <48dc2080.14be600a.433d.fffffde3@mx.google.com>
	 <20080926162643.GB3483@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 29 Sep 2008 16:59:37 -0400
Message-Id: <1222721977.27930.45.camel@localhost.localdomain> (sfid-20080929_230027_319406_874F3163)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-09-26 at 12:26 -0400, John W. Linville wrote:
> On Thu, Sep 25, 2008 at 04:19:31PM -0700, Anna Neal wrote:
> > iwconfig txpower can now be used to set tx power to fixed or auto. If set to
> > auto the default firmware settings are used.
> > 
> > The command CMD_802_11_PA_CFG is only sent to older firmware, as Dan Williams
> > noted the command was no longer supported in firmware V9+.
> > 
> > Signed-off-by: Anna Neal <anna@cozybit.com>
> > Signed-off-by: Javier Cardona <javier@cozybit.com>
> 
> I had already committed an earlier version.  I believe I have
> incorporated all the changes in "libertas: Improvements on automatic tx
> power control via SIOCSIWTXPOW (fixups)" -- please feel free to verify.

A few missing bits, sorry for the confusion.  Merge fixups against
current wireless-testing below.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index aee19fa..a912fb6 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -1949,7 +1949,7 @@ int lbs_set_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
 	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
 	cmd.action = cpu_to_le16(CMD_ACT_SET);
 	cmd.enable = !!enable;
-	cmd.usesnr = !!enable;
+	cmd.usesnr = !!usesnr;
 	cmd.P0 = p0;
 	cmd.P1 = p1;
 	cmd.P2 = p2;
diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
index d21bb4e..076a636 100644
--- a/drivers/net/wireless/libertas/defs.h
+++ b/drivers/net/wireless/libertas/defs.h
@@ -189,16 +189,6 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
 #define MRVDRV_CMD_UPLD_RDY		0x0008
 #define MRVDRV_CARDEVENT		0x0010
 
-
-/* Automatic TX control default levels */
-#define POW_ADAPT_DEFAULT_P0 13
-#define POW_ADAPT_DEFAULT_P1 15
-#define POW_ADAPT_DEFAULT_P2 18
-#define TPC_DEFAULT_P0 5
-#define TPC_DEFAULT_P1 10
-#define TPC_DEFAULT_P2 13
-
-
 /* Automatic TX control default levels */
 #define POW_ADAPT_DEFAULT_P0 13
 #define POW_ADAPT_DEFAULT_P1 15

