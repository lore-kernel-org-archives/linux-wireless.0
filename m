Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F386531353C
	for <linux-wireless@vger.kernel.org>; Fri,  3 Jul 2026 19:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783106233; cv=none; b=t4MHGPgqnjgP/WaULPmUyi6PVZTeLuYooWGna/wIVypgcSwSqOmWkb4wsyV5ncf+zJtSnr5kDMrwUoVgX/ZWAChP79itTYo3Wi1eQTVYs54IyFhYXnW5Yh+O4yDR7j1FABLXhwD3yQOlXU1M5PjMhKJAmvNzC4kptk79oeSuZ0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783106233; c=relaxed/simple;
	bh=HZpn+LzEdQiChdKODgOInSWhyjcSHx3vU/HlqLbVzLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iBsFf8Eu2Rqn4OUhC5+M9VVxoYUCp+Poq0MxCN70oWGloExgWdde8mK+zPZHOiv/HBv+Vo6Paf3HjcyTHpOIPL0RseHz/qyRu3xMf39vZlFhp24hD3lwznd9hjKyoflLxBLVWFbjLmK9V5Tq27A2EUAh4N+Ab5FB5QSiJcwQUIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=V3DGhrzc; arc=none smtp.client-ip=212.77.101.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="V3DGhrzc"
Received: (wp-smtpd smtp.wp.pl 41919 invoked from network); 3 Jul 2026 21:17:00 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1783106220; bh=XltZ51lcaAfXjjwWeqNJ33cCCEX8OwFtiK+K0f9hfQQ=;
          h=From:To:Cc:Subject;
          b=V3DGhrzcdsLXxL0EOgDAp2f5Qp5PNoyasIfQ3sPOwGx6ZkUWKSLhIPzJQTzEVmaqn
           A4fQEZ++w0u/FYAbrXu2wZ5HO0qhMxmV6PREAQR2516U4rPsKmqAeI+sZOmd73Btlf
           mhCXMZV/BzZFkOeAOkTzElSREf3kJ+34j8CNt8GTBUGXBDDRB0fySbHKhdpsFEoStm
           O3ixzsajAyG1+ePcPBDuXGC2ahKkU4jGlVQEZoUayHnrmIM5WFuysVHFp9Jka5NEM+
           XllAwUFQdD5FyKtW1J1Y/3VglpGSigcJQUSrCVZ6GFYCOpOeA3qQBB0e8gthy2PbDh
           B0358EvJQm8IA==
Received: from 77-236-11-179.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.179])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <clabbe@baylibre.com>; 3 Jul 2026 21:17:00 +0200
Date: Fri, 3 Jul 2026 21:17:00 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Corentin Labbe <clabbe@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net: wireless: ralink: RT2X00: init EEPROM properly
Message-ID: <20260703191700.GA8093@wp.pl>
References: <20260703134932.3786771-1-clabbe@baylibre.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703134932.3786771-1-clabbe@baylibre.com>
X-WP-MailID: c6c60aed9b5d4a4ec0f4138872622716
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YTOR]                               

Hi,

On Fri, Jul 03, 2026 at 01:49:32PM +0000, Corentin Labbe wrote:
> I have an hostapd setup with a
> 01:00.0 Network controller: Ralink corp. RT2790 Wireless 802.11n 1T/2R PCIe
> 
> The setup work fine on 6.18.26-gentoo
> It breaks on 6.18.33-gentoo (and still broken on 6.18.37)
> 
> I found an hint in dmesg:
> On 6.18.26-gentoo I see:
> May 31 15:48:45 trash01 kernel: ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0003 detected
> On 6.18.33-gentoo I see:
> May 31 15:22:57 trash01 kernel: ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 0006 detected
> 
> The RF chipset seems badly detected.
> 
> The problem was the EEPROM which was badly initialized.

Good catch. Some new fields were added to struct eeprom_93cx6, but
the rt2x00 driver was not updated to initalize those.

> Probably the origin was in some PCI change but unfortunately I couldn't play
> to bisect/reboot often the board with this card to do it.
> 
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: stable@vger.kernel.org

> ---
>  drivers/net/wireless/ralink/rt2x00/rt2400pci.c | 2 +-
>  drivers/net/wireless/ralink/rt2x00/rt2500pci.c | 2 +-
>  drivers/net/wireless/ralink/rt2x00/rt2800pci.c | 2 +-
>  drivers/net/wireless/ralink/rt2x00/rt61pci.c   | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> index 42e21e9f303b..15073b856adf 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2400pci.c
> @@ -1429,7 +1429,7 @@ static irqreturn_t rt2400pci_interrupt(int irq, void *dev_instance)
>   */
>  static int rt2400pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct eeprom_93cx6 eeprom;
> +	struct eeprom_93cx6 eeprom = {};
>  	u32 reg;
>  	u16 word;
>  	u8 *mac;
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> index 36ddc5a69fa4..3536a0f31117 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2500pci.c
> @@ -1555,7 +1555,7 @@ static irqreturn_t rt2500pci_interrupt(int irq, void *dev_instance)
>   */
>  static int rt2500pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct eeprom_93cx6 eeprom;
> +	struct eeprom_93cx6 eeprom = {};
>  	u32 reg;
>  	u16 word;
>  	u8 *mac;
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
> index 14c45aba836f..853fd31d1362 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800pci.c
> @@ -108,7 +108,7 @@ static void rt2800pci_eepromregister_write(struct eeprom_93cx6 *eeprom)
>  
>  static int rt2800pci_read_eeprom_pci(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct eeprom_93cx6 eeprom;
> +	struct eeprom_93cx6 eeprom = {};
>  	u32 reg;
>  
>  	reg = rt2x00mmio_register_read(rt2x00dev, E2PROM_CSR);
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt61pci.c b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> index d1cd5694e3c7..5dca2afb4b96 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt61pci.c
> @@ -2298,7 +2298,7 @@ static irqreturn_t rt61pci_interrupt(int irq, void *dev_instance)
>   */
>  static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>  {
> -	struct eeprom_93cx6 eeprom;
> +	struct eeprom_93cx6 eeprom = {};
>  	u32 reg;
>  	u16 word;
>  	u8 *mac;
> -- 
> 2.53.0
> 
