Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:39257
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbXB1Rgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 12:36:53 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH 8/28] rt2x00: optimize mac/bssid writing
Date: Wed, 28 Feb 2007 18:36:07 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.11726.IvDoorn@gmail.com>
In-Reply-To: <200702281507.11726.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281836.07850.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 15:07, Ivo van Doorn wrote:
> Handling the mac and bssid configuration can be done much easier
> by writing the passed data directly into the register instead
> of moving it to a local variable first.
> 
> Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> 
> ---
> 
> diff --git a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> index 27e151d..b6bf9f3 100644
> --- a/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/mac80211/rt2x00/rt2400pci.c
> @@ -319,14 +319,11 @@ static inline void rt2400pci_close_debugfs(struct rt2x00_dev *rt2x00dev){}
>   */
>  static void rt2400pci_config_bssid(struct rt2x00_dev *rt2x00dev, u8 *bssid)
>  {
> -	u32 reg[2] = { 0, 0 };
> -
>  	/*
>  	 * The BSSID is passed to us as an array of bytes,
>  	 * that array is little endian, so no need for byte ordering.
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  	 */
> -	memcpy(&reg, bssid, ETH_ALEN);
> -	rt2x00_register_multiwrite(rt2x00dev, CSR5, &reg[0], sizeof(reg));
> +	rt2x00_register_multiwrite(rt2x00dev, CSR5, (u32*)bssid, ETH_ALEN);
                                                    ^^^^^^

This doesn't break on BE machines?

[Snipped the rest of the patch. Same comment applies there, too]

-- 
Greetings Michael.
