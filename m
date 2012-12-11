Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:39149 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2LKVvf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 16:51:35 -0500
Received: by mail-we0-f174.google.com with SMTP id x10so1875226wey.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 13:51:33 -0800 (PST)
References: <20121211100419.GA7822@earthship.arig>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20121211100419.GA7822@earthship.arig>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <A06A1995-B025-4841-BCD9-9A940DA58620@gmail.com> (sfid-20121211_225147_777307_8C5A81C4)
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
	"<users@rt2x00.serialmonkey.com>" <users@rt2x00.serialmonkey.com>,
	"<juhosg@openwrt.org>" <juhosg@openwrt.org>,
	"<sgruszka@redhat.com>" <sgruszka@redhat.com>,
	"<helmut.schaa@googlemail.com>" <helmut.schaa@googlemail.com>,
	"<john@phrozen.org>" <john@phrozen.org>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3/3] rt2x00: add platform_data mac address
Date: Tue, 11 Dec 2012 22:51:32 +0100
To: Daniel Golle <dgolle@allnet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On 11 dec. 2012, at 11:04, Daniel Golle <dgolle@allnet.de> wrote:

> 
> Signed-off-by: Daniel Golle <dgolle@allnet.de>

Again we need a proper patch description.

And for this patch I have the same question as for the previous patch: why do we need to arrange this via platform data, as opposed to using the standard user space ifconfig facility to set a mac address?

As a second question: why is this only implemented for rt61pci, and not the other PCI / SOC drivers?

---
Gertjan

> 
> diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
> index c67e769..8b82e77 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00.h
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h
> @@ -1294,6 +1294,7 @@ static inline void rt2x00debug_dump_frame(struct rt2x00_dev *rt2x00dev,
>  */
> u32 rt2x00lib_get_bssidx(struct rt2x00_dev *rt2x00dev,
>             struct ieee80211_vif *vif);
> +const u8 *rt2x00lib_get_mac_address(struct rt2x00_dev *rt2x00dev);
> 
> /*
>  * Interrupt context handlers.
> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index b7856bf..f9868d1 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -826,6 +826,18 @@ static void rt2x00lib_rate(struct ieee80211_rate *entry,
>        entry->flags |= IEEE80211_RATE_SHORT_PREAMBLE;
> }
> 
> +const u8 *rt2x00lib_get_mac_address(struct rt2x00_dev *rt2x00dev)
> +{
> +    struct rt2x00_platform_data *pdata;
> +
> +    pdata = rt2x00dev->dev->platform_data;
> +    if (!pdata)
> +        return NULL;
> +
> +    return pdata->mac_address;
> +}
> +EXPORT_SYMBOL_GPL(rt2x00lib_get_mac_address);
> +
> static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
>                    struct hw_mode_spec *spec)
> {
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
> index f95792c..7dbc0ba 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2392,6 +2392,7 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>    u32 reg;
>    u16 word;
>    u8 *mac;
> +    const u8 *pdata_mac;
>    s8 value;
> 
>    rt2x00pci_register_read(rt2x00dev, E2PROM_CSR, &reg);
> @@ -2412,7 +2413,11 @@ static int rt61pci_validate_eeprom(struct rt2x00_dev *rt2x00dev)
>    /*
>     * Start validation of the data that has been read.
>     */
> +    pdata_mac = rt2x00lib_get_mac_address(rt2x00dev);
>    mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
> +    if (pdata_mac)
> +        memcpy(mac, pdata_mac, 6);
> +
>    if (!is_valid_ether_addr(mac)) {
>        eth_random_addr(mac);
>        EEPROM(rt2x00dev, "MAC: %pM\n", mac);
> diff --git a/include/linux/rt2x00_platform.h b/include/linux/rt2x00_platform.h
> index b4c7768..e10377e 100644
> --- a/include/linux/rt2x00_platform.h
> +++ b/include/linux/rt2x00_platform.h
> @@ -14,6 +14,7 @@
> 
> struct rt2x00_platform_data {
>    char *eeprom_file_name;
> +    const u8 *mac_address;
> 
>    int disable_2ghz;
>    int disable_5ghz;
> -- 
> 1.8.0.1
> 
