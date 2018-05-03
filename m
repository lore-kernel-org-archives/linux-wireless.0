Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59734 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751139AbeECXfS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 May 2018 19:35:18 -0400
Date: Thu, 3 May 2018 23:35:16 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com, christian.koenig@amd.com,
        kvalo@codeaurora.org, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        hdegoede@redhat.com, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 2/9] firmware: wrap FW_OPT_* into an enum
Message-ID: <20180503233516.GS27853@wotan.suse.de> (sfid-20180504_013532_311789_17AC0391)
References: <20180423201205.20533-1-andresx7@gmail.com>
 <20180423201205.20533-3-andresx7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180423201205.20533-3-andresx7@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 23, 2018 at 04:11:58PM -0400, Andres Rodriguez wrote:
> This should let us associate enum kdoc to these values.
> 
> v2: use BIT() macro

No need to keep the changelog of series here, best to put them below as
I note.
> 
> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
> ---

Here is good to add changelog for series.

Anyway this patch can be merged with your next patch. I'll do
this myself and take it in my queue.

  Luis

>  drivers/base/firmware_loader/fallback.c | 12 ++++++------
>  drivers/base/firmware_loader/fallback.h |  6 ++++--
>  drivers/base/firmware_loader/firmware.h | 18 ++++++++++--------
>  drivers/base/firmware_loader/main.c     |  6 +++---
>  4 files changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
> index da97fc26119c..ecc49a619298 100644
> --- a/drivers/base/firmware_loader/fallback.c
> +++ b/drivers/base/firmware_loader/fallback.c
> @@ -511,7 +511,7 @@ static const struct attribute_group *fw_dev_attr_groups[] = {
>  
>  static struct fw_sysfs *
>  fw_create_instance(struct firmware *firmware, const char *fw_name,
> -		   struct device *device, unsigned int opt_flags)
> +		   struct device *device, enum fw_opt opt_flags)
>  {
>  	struct fw_sysfs *fw_sysfs;
>  	struct device *f_dev;
> @@ -544,7 +544,7 @@ fw_create_instance(struct firmware *firmware, const char *fw_name,
>   * In charge of constructing a sysfs fallback interface for firmware loading.
>   **/
>  static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs,
> -				  unsigned int opt_flags, long timeout)
> +				  enum fw_opt opt_flags, long timeout)
>  {
>  	int retval = 0;
>  	struct device *f_dev = &fw_sysfs->dev;
> @@ -598,7 +598,7 @@ static int fw_load_sysfs_fallback(struct fw_sysfs *fw_sysfs,
>  
>  static int fw_load_from_user_helper(struct firmware *firmware,
>  				    const char *name, struct device *device,
> -				    unsigned int opt_flags)
> +				    enum fw_opt opt_flags)
>  {
>  	struct fw_sysfs *fw_sysfs;
>  	long timeout;
> @@ -639,7 +639,7 @@ static int fw_load_from_user_helper(struct firmware *firmware,
>  	return ret;
>  }
>  
> -static bool fw_force_sysfs_fallback(unsigned int opt_flags)
> +static bool fw_force_sysfs_fallback(enum fw_opt opt_flags)
>  {
>  	if (fw_fallback_config.force_sysfs_fallback)
>  		return true;
> @@ -648,7 +648,7 @@ static bool fw_force_sysfs_fallback(unsigned int opt_flags)
>  	return true;
>  }
>  
> -static bool fw_run_sysfs_fallback(unsigned int opt_flags)
> +static bool fw_run_sysfs_fallback(enum fw_opt opt_flags)
>  {
>  	if (fw_fallback_config.ignore_sysfs_fallback) {
>  		pr_info_once("Ignoring firmware sysfs fallback due to sysctl knob\n");
> @@ -663,7 +663,7 @@ static bool fw_run_sysfs_fallback(unsigned int opt_flags)
>  
>  int fw_sysfs_fallback(struct firmware *fw, const char *name,
>  		      struct device *device,
> -		      unsigned int opt_flags,
> +		      enum fw_opt opt_flags,
>  		      int ret)
>  {
>  	if (!fw_run_sysfs_fallback(opt_flags))
> diff --git a/drivers/base/firmware_loader/fallback.h b/drivers/base/firmware_loader/fallback.h
> index f8255670a663..a3b73a09db6c 100644
> --- a/drivers/base/firmware_loader/fallback.h
> +++ b/drivers/base/firmware_loader/fallback.h
> @@ -5,6 +5,8 @@
>  #include <linux/firmware.h>
>  #include <linux/device.h>
>  
> +#include "firmware.h"
> +
>  /**
>   * struct firmware_fallback_config - firmware fallback configuration settings
>   *
> @@ -31,7 +33,7 @@ struct firmware_fallback_config {
>  #ifdef CONFIG_FW_LOADER_USER_HELPER
>  int fw_sysfs_fallback(struct firmware *fw, const char *name,
>  		      struct device *device,
> -		      unsigned int opt_flags,
> +		      enum fw_opt opt_flags,
>  		      int ret);
>  void kill_pending_fw_fallback_reqs(bool only_kill_custom);
>  
> @@ -43,7 +45,7 @@ void unregister_sysfs_loader(void);
>  #else /* CONFIG_FW_LOADER_USER_HELPER */
>  static inline int fw_sysfs_fallback(struct firmware *fw, const char *name,
>  				    struct device *device,
> -				    unsigned int opt_flags,
> +				    enum fw_opt opt_flags,
>  				    int ret)
>  {
>  	/* Keep carrying over the same error */
> diff --git a/drivers/base/firmware_loader/firmware.h b/drivers/base/firmware_loader/firmware.h
> index d11d37db370b..b252bfa82295 100644
> --- a/drivers/base/firmware_loader/firmware.h
> +++ b/drivers/base/firmware_loader/firmware.h
> @@ -2,6 +2,7 @@
>  #ifndef __FIRMWARE_LOADER_H
>  #define __FIRMWARE_LOADER_H
>  
> +#include <linux/bitops.h>
>  #include <linux/firmware.h>
>  #include <linux/types.h>
>  #include <linux/kref.h>
> @@ -10,13 +11,14 @@
>  
>  #include <generated/utsrelease.h>
>  
> -/* firmware behavior options */
> -#define FW_OPT_UEVENT			(1U << 0)
> -#define FW_OPT_NOWAIT			(1U << 1)
> -#define FW_OPT_USERHELPER		(1U << 2)
> -#define FW_OPT_NO_WARN			(1U << 3)
> -#define FW_OPT_NOCACHE			(1U << 4)
> -#define FW_OPT_NOFALLBACK		(1U << 5)
> +enum fw_opt {
> +	FW_OPT_UEVENT =         BIT(0),
> +	FW_OPT_NOWAIT =         BIT(1),
> +	FW_OPT_USERHELPER =     BIT(2),
> +	FW_OPT_NO_WARN =        BIT(3),
> +	FW_OPT_NOCACHE =        BIT(4),
> +	FW_OPT_NOFALLBACK =     BIT(5),
> +};
>  
>  enum fw_status {
>  	FW_STATUS_UNKNOWN,
> @@ -110,6 +112,6 @@ static inline void fw_state_done(struct fw_priv *fw_priv)
>  }
>  
>  int assign_fw(struct firmware *fw, struct device *device,
> -	      unsigned int opt_flags);
> +	      enum fw_opt opt_flags);
>  
>  #endif /* __FIRMWARE_LOADER_H */
> diff --git a/drivers/base/firmware_loader/main.c b/drivers/base/firmware_loader/main.c
> index 5812148694b6..5baadad3012d 100644
> --- a/drivers/base/firmware_loader/main.c
> +++ b/drivers/base/firmware_loader/main.c
> @@ -443,7 +443,7 @@ static int fw_add_devm_name(struct device *dev, const char *name)
>  #endif
>  
>  int assign_fw(struct firmware *fw, struct device *device,
> -	      unsigned int opt_flags)
> +	      enum fw_opt opt_flags)
>  {
>  	struct fw_priv *fw_priv = fw->priv;
>  	int ret;
> @@ -558,7 +558,7 @@ static void fw_abort_batch_reqs(struct firmware *fw)
>  static int
>  _firmware_request(const struct firmware **firmware_p, const char *name,
>  		  struct device *device, void *buf, size_t size,
> -		  unsigned int opt_flags)
> +		  enum fw_opt opt_flags)
>  {
>  	struct firmware *fw = NULL;
>  	int ret;
> @@ -734,7 +734,7 @@ struct firmware_work {
>  	struct device *device;
>  	void *context;
>  	void (*cont)(const struct firmware *fw, void *context);
> -	unsigned int opt_flags;
> +	enum fw_opt opt_flags;
>  };
>  
>  static void firmware_request_work_func(struct work_struct *work)
> -- 
> 2.14.1
> 
> 

-- 
Do not panic
