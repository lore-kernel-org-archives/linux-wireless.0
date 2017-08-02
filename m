Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:38275 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751161AbdHBVnW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 17:43:22 -0400
Received: by mail-wr0-f177.google.com with SMTP id f21so1408971wrf.5
        for <linux-wireless@vger.kernel.org>; Wed, 02 Aug 2017 14:43:22 -0700 (PDT)
Subject: Re: [PATCH v2 9/9] wil6210: make debugfs compilation optional
To: Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Gidon Studinski <QCA_gidons@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
References: <1501707649-9665-1-git-send-email-qca_merez@qca.qualcomm.com>
 <1501707649-9665-10-git-send-email-qca_merez@qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <07dd021a-ee9a-182c-704f-f7c48a8e299e@broadcom.com> (sfid-20170802_234327_486367_DA8C9A6B)
Date: Wed, 2 Aug 2017 23:43:19 +0200
MIME-Version: 1.0
In-Reply-To: <1501707649-9665-10-git-send-email-qca_merez@qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02-08-17 23:00, Maya Erez wrote:
> From: Gidon Studinski <qca_gidons@qca.qualcomm.com>
> 
> Since debugfs is a kernel configuration option, enable the driver to
> compile without debugfs.
> 
> Signed-off-by: Gidon Studinski <qca_gidons@qca.qualcomm.com>
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/wil6210/debugfs.c | 14 ++++++++++----
>  drivers/net/wireless/ath/wil6210/main.c    |  1 +
>  drivers/net/wireless/ath/wil6210/txrx.c    |  6 +++---
>  drivers/net/wireless/ath/wil6210/wil6210.h |  2 +-
>  4 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
> index d4e8865..5e803e2 100644
> --- a/drivers/net/wireless/ath/wil6210/debugfs.c
> +++ b/drivers/net/wireless/ath/wil6210/debugfs.c
> @@ -14,6 +14,10 @@
>   * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>   */
>  
> +#include "wil6210.h"
> +
> +#ifdef CONFIG_DEBUG_FS
> +

[...]

> +#else /* !CONFIG_DEBUG_FS */
> +int wil6210_debugfs_init(struct wil6210_priv *wil) { return 0; }
> +void wil6210_debugfs_remove(struct wil6210_priv *wil) {}
> +#endif

I think it would be better to have these stubs defined in the header
file, ie. in wil6210.h. That way you can conditionally compile this
source file through Makefile as below keeping debugfs.c clean.

Regards,
Arend

diff --git a/drivers/net/wireless/ath/wil6210/Makefile
b/drivers/net/wireless/ath/wil6210/Makefile
index 4ae21da..0f98904c 100644
--- a/drivers/net/wireless/ath/wil6210/Makefile
+++ b/drivers/net/wireless/ath/wil6210/Makefile
@@ -4,7 +4,7 @@ wil6210-y := main.o
 wil6210-y += netdev.o
 wil6210-y += cfg80211.o
 wil6210-y += pcie_bus.o
-wil6210-y += debugfs.o
+wil6210-$(CONFIG_DEBUG_FS) += debugfs.o
 wil6210-y += wmi.o
 wil6210-y += interrupt.o
 wil6210-y += txrx.o
