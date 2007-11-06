Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:33477
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXKFTXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 14:23:10 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC 1 of 6] ssb: Add new SPROM structure while keeping the old
Date: Tue, 6 Nov 2007 20:22:41 +0100
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4730bd03.rGmiNlJ18XBoW/Yb%Larry.Finger@lwfinger.net>
In-Reply-To: <4730bd03.rGmiNlJ18XBoW/Yb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711062022.41248.mb@bu3sch.de> (sfid-20071106_192320_634054_E3B01AEF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06 November 2007 20:14:11 Larry Finger wrote:
> This is patch 1 of 6.
> 
> The SPROM's for various devices utilizing the Sonics Silicon Backplane come
> with various revisions. The Revision 2 SPROM inherited the data layout of 1, and
> Revision 3 inherited the layout of 2. The first instance of Revision 4 has
> now been found in a BCM4328 wireless LAN card. This device does not inherit any
> layout from previous versions. Although it was possible to create a data
> structure that kept all the old layouts, we decided to start fresh, keep only
> those SPROM variables that are used by the drivers that utilize ssb, and to
> do the conversion in such a manner that neither compilation or execution will
> be affected if a bisection lands in the middle of these changes, while keeping
> the patches as small as possible.
> 
> In this patch, the sprom structures are changed while maintaining the old ones.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> Index: wireless-2.6/include/linux/ssb/ssb.h
> ===================================================================
> --- wireless-2.6.orig/include/linux/ssb/ssb.h
> +++ wireless-2.6/include/linux/ssb/ssb.h
> @@ -78,8 +78,32 @@ struct ssb_sprom_r3 {
>  	u32 ofdmgpo;		/* G-PHY OFDM Power Offset */
>  };
>  
> -struct ssb_sprom_r4 {
> -	/* TODO */
> +struct ssb_sprom_data {
> +	u8 il0mac[6];		/* MAC address for 802.11b/g */
> +	u8 et0mac[6];		/* MAC address for Ethernet */
> +	u8 et1mac[6];		/* MAC address for 802.11a */
> +	u8 et0phyaddr:5;	/* MII address for enet0 */
> +	u8 et1phyaddr:5;	/* MII address for enet1 */

While we are at it, please also get rid of these ugly foo:X bitfields.

-- 
Greetings Michael.
