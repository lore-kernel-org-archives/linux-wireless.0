Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:54538 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbdKFSfD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 13:35:03 -0500
Date: Mon, 6 Nov 2017 19:34:57 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Simon Shields <simon@lineageos.org>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com
Message-ID: <1925563700.5172.1509993297900@email.1und1.de> (sfid-20171106_193507_566783_D1495A3A)
In-Reply-To: <20171104132421.GA1541@archbox.home>
References: <20171104132421.GA1541@archbox.home>
Subject: Re: [PATCH] brcmfmac: add support for external 32khz clock
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Simon,

> Simon Shields <simon@lineageos.org> hat am 4. November 2017 um 14:24 geschrieben:
> 
> 
> Some boards use an external 32khz clock for low-power
> mode timing. Make sure the clock is powered on while the chipset
> is active.
> 
> Signed-off-by: Simon Shields <simon@lineageos.org>
> ---
>  .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt     |  2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h      |  2 ++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c          |  5 +++++
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c        | 10 ++++++++++
>  4 files changed, 19 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index b2bd4704f859..37add5e29272 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -17,6 +17,8 @@ Optional properties:
>  	When not specified the device will use in-band SDIO interrupts.
>   - interrupt-names : name of the out-of-band interrupt, which must be set
>  	to "host-wake".
> + - clocks : external 32khz clock
> + - clock-names : name of the external 32khz clock, must be "32khz"

sorry for the nitpicking, but according to the datasheet [1] it's 32768 Hz. Apart from that i suggest to use a functional name for the clock like "low_power" or something else, which is more flexible and future-proof.

Btw this binding needs to be a separate patch, which should go to the devicetree guys.

[1] - http://www.cypress.com/file/298706/download

>  
>  Example:
>  
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> index a62f8e70b320..2e7fabae81d3 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
> @@ -51,6 +51,7 @@ extern struct brcmf_mp_global_t brcmf_mp_global;
>   * @roamoff: Firmware roaming off?
>   * @ignore_probe_fail: Ignore probe failure.
>   * @country_codes: If available, pointer to struct for translating country codes
> + * @clk: External 32khz clock, if present.
>   * @bus: Bus specific platform data. Only SDIO at the mmoment.
>   */
>  struct brcmf_mp_device {
> @@ -60,6 +61,7 @@ struct brcmf_mp_device {
>  	bool		roamoff;
>  	bool		ignore_probe_fail;
>  	struct brcmfmac_pd_cc *country_codes;
> +	struct clk *clk;
>  	union {
>  		struct brcmfmac_sdio_pd sdio;
>  	} bus;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index aee6e5937c41..46f42a2c3d2b 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -13,6 +13,7 @@
>   * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
>   * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>   */
> +#include <linux/clk.h>
>  #include <linux/init.h>
>  #include <linux/of.h>
>  #include <linux/of_irq.h>
> @@ -39,6 +40,10 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>  	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
>  		sdio->drive_strength = val;
>  
> +	settings->clk = devm_clk_get(dev, "32khz");
> +	if (IS_ERR(settings->clk))
> +		settings->clk = NULL;

I cannot recommend this, please look at the thread here [2].

Thanks

[2] - https://marc.info/?l=linux-arm-kernel&m=150980353025665&w=2

> +
>  	/* make sure there are interrupts defined in the node */
>  	if (!of_find_property(np, "interrupts", NULL))
>  		return;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 613caca7dc02..f4ceca6dbe74 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -14,6 +14,7 @@
>   * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>   */
>  
> +#include <linux/clk.h>
>  #include <linux/types.h>
>  #include <linux/atomic.h>
>  #include <linux/kernel.h>
> @@ -3853,6 +3854,11 @@ brcmf_sdio_probe_attach(struct brcmf_sdio *bus)
>  		brcmf_err("Failed to get device parameters\n");
>  		goto fail;
>  	}
> +
> +	/* enable external 32khz clock, if present */
> +	if (sdiodev->settings->clk)
> +		clk_prepare_enable(sdiodev->settings->clk);
> +
>  	/* platform specific configuration:
>  	 *   alignments must be at least 4 bytes for ADMA
>  	 */
> @@ -4270,6 +4276,10 @@ void brcmf_sdio_remove(struct brcmf_sdio *bus)
>  			}
>  			brcmf_chip_detach(bus->ci);
>  		}
> +
> +		if (bus->sdiodev->settings->clk)
> +			clk_disable_unprepare(bus->sdiodev->settings->clk);
> +
>  		if (bus->sdiodev->settings)
>  			brcmf_release_module_param(bus->sdiodev->settings);
>  
> -- 
> 2.15.0
>
