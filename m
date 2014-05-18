Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51839 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbaERJwR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 May 2014 05:52:17 -0400
Message-ID: <537880A4.1040102@hauke-m.de> (sfid-20140518_115421_214196_57B8074B)
Date: Sun, 18 May 2014 11:43:00 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
CC: b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: sprom: add dev_id field for value overriding standard
 ID
References: <1400365358-19604-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1400365358-19604-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/18/2014 12:22 AM, Rafał Miłecki wrote:
> Some devices may have different features despite sharing the same ID
> (e.g. PCI ID). For example 14e4:4331 is usually a dual band, but this
> can be "limited". Device with "pci/x/y/devid=0x4332" supports 2.4 GHz
> only. Similarly 0x4333 will mean support for 5 GHz only.
> Add entry in SPROM so info described above can be extracted and stored.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

This patch is ok, I missed that when adding BCM4716 support to brcmsmac.
There is also a vendid var which should be used. See this code from
brcmsmac:
http://lxr.free-electrons.com/source/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c?v=3.0#L660

Hauke

> ---
> I managed to find "devid" on every common SPROM rev:
> pci/1/1/sromrev=2
> pci/1/1/devid=0x4318
> 
> pci/1/1/sromrev=4
> pci/1/1/devid=0x4329
> 
> pci/1/1/sromrev=8
> pci/1/1/devid=0x432d
> 
> pci/1/1/sromrev=9
> pci/1/1/devid=0x4332
> 
> pci/1/1/sromrev=11
> pci/1/1/devid=0x43a1
> 
> So it makes the most sense to always try to extract it.
> ---
>  arch/mips/bcm47xx/sprom.c | 1 +
>  include/linux/ssb/ssb.h   | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
> index a8b5408..da4cdb1 100644
> --- a/arch/mips/bcm47xx/sprom.c
> +++ b/arch/mips/bcm47xx/sprom.c
> @@ -168,6 +168,7 @@ static void nvram_read_alpha2(const char *prefix, const char *name,
>  static void bcm47xx_fill_sprom_r1234589(struct ssb_sprom *sprom,
>  					const char *prefix, bool fallback)
>  {
> +	nvram_read_u16(prefix, NULL, "devid", &sprom->dev_id, 0, fallback);
>  	nvram_read_u8(prefix, NULL, "ledbh0", &sprom->gpio0, 0xff, fallback);
>  	nvram_read_u8(prefix, NULL, "ledbh1", &sprom->gpio1, 0xff, fallback);
>  	nvram_read_u8(prefix, NULL, "ledbh2", &sprom->gpio2, 0xff, fallback);
> diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
> index 07ef9b8..4568a5c 100644
> --- a/include/linux/ssb/ssb.h
> +++ b/include/linux/ssb/ssb.h
> @@ -33,6 +33,7 @@ struct ssb_sprom {
>  	u8 et1phyaddr;		/* MII address for enet1 */
>  	u8 et0mdcport;		/* MDIO for enet0 */
>  	u8 et1mdcport;		/* MDIO for enet1 */
> +	u16 dev_id;		/* Device ID overriding e.g. PCI ID */
>  	u16 board_rev;		/* Board revision number from SPROM. */
>  	u16 board_num;		/* Board number from SPROM. */
>  	u16 board_type;		/* Board type from SPROM. */
> 

