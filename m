Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35468 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab0ILRQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Sep 2010 13:16:37 -0400
Received: by qwh6 with SMTP id 6so2900230qwh.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Sep 2010 10:16:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284221913-22455-10-git-send-email-hauke@hauke-m.de>
References: <1284221913-22455-1-git-send-email-hauke@hauke-m.de> <1284221913-22455-10-git-send-email-hauke@hauke-m.de>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 12 Sep 2010 19:16:16 +0200
Message-ID: <AANLkTim8UUHmm_TNzg0Spm7SXm8OXfDAvhjUK7v9V-F=@mail.gmail.com>
Subject: Re: [PATCH 8/8] compat-wireless: add brcm80211 driver
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	mcgrof@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Umm... do we accept staging drivers in compat-wireless?

On Sat, Sep 11, 2010 at 6:18 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This driver was compile tested on kernel 2.6.29 to 2.6.36.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  Makefile                                     |    1 +
>  config.mk                                    |    4 ++++
>  patches/35-backport-brcm80211-Makefile.patch |   11 +++++++++++
>  scripts/admin-update.sh                      |    1 +
>  4 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 patches/35-backport-brcm80211-Makefile.patch
>
> diff --git a/Makefile b/Makefile
> index b590ca2..61adb0d 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -39,6 +39,7 @@ obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
>
>  ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
>  obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/ath6kl/
> +obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/brcm80211/
>  endif
>
>
> diff --git a/config.mk b/config.mk
> index f2c62ed..b61c318 100644
> --- a/config.mk
> +++ b/config.mk
> @@ -513,6 +513,10 @@ CONFIG_ATH6KL_ENABLE_TARGET_DEBUG_PRINTS=y
>  # CONFIG_ATH6KL_SKIP_ABI_VERSION_CHECK is not set
>  CONFIG_ATH6KL_VIRTUAL_SCATTER_GATHER=y
>  CONFIG_ATH6K_LEGACY=m
> +
> +CONFIG_BRCM80211=m
> +CONFIG_BRCM80211_PCI=y
> +
>  endif #CONFIG_WIRELESS_EXT
>  endif #CONFIG_MMC
>
> diff --git a/patches/35-backport-brcm80211-Makefile.patch b/patches/35-backport-brcm80211-Makefile.patch
> new file mode 100644
> index 0000000..2a94756
> --- /dev/null
> +++ b/patches/35-backport-brcm80211-Makefile.patch
> @@ -0,0 +1,11 @@
> +--- a/drivers/staging/brcm80211/Makefile
> ++++ b/drivers/staging/brcm80211/Makefile
> +@@ -15,7 +15,7 @@
> + # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
> + # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> +
> +-EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -Idrivers/staging/brcm80211/sys -Idrivers/staging/brcm80211/phy -Idrivers/staging/brcm80211/util -Idrivers/staging/brcm80211/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
> ++EXTRA_CFLAGS := -DBCMDBG -DWLC_HIGH -DSTA -DWME -DWL11N -DDBAND -DBCMDMA32 -DBCMNVRAMR -I$(obj)/sys -I$(obj)/phy -I$(obj)/util -I$(obj)/include -Wall -Wstrict-prototypes -Werror -Wmissing-prototypes
> +
> + PCI_CFLAGS := -DWLC_LOW
> +
> diff --git a/scripts/admin-update.sh b/scripts/admin-update.sh
> index e000faf..6ef281d 100755
> --- a/scripts/admin-update.sh
> +++ b/scripts/admin-update.sh
> @@ -212,6 +212,7 @@ DRIVERS="$DRIVERS drivers/net/wireless/orinoco"
>
>  # Staging drivers
>  STAGING_DRIVERS="drivers/staging/ath6kl"
> +STAGING_DRIVERS="$STAGING_DRIVERS drivers/staging/brcm80211"
>
>  # Ethernet drivers
>  DRIVERS="$DRIVERS drivers/net/atl1c"
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
