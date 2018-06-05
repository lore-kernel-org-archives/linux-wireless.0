Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:37438 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751775AbeFENTV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 09:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <1527765086-19873-7-git-send-email-xieyisheng1@huawei.com>
References: <1527765086-19873-1-git-send-email-xieyisheng1@huawei.com> <1527765086-19873-7-git-send-email-xieyisheng1@huawei.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 5 Jun 2018 16:19:20 +0300
Message-ID: <CAHp75VfDznN0p5pAvVGaR-ntQmpi9kmXyMLhyXT-4XPaFMSV1g@mail.gmail.com> (sfid-20180605_151943_173044_23AA5379)
Subject: Re: [PATCH v2 06/21] iwlwifi: mvm: use match_string() helper
To: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 31, 2018 at 2:11 PM, Yisheng Xie <xieyisheng1@huawei.com> wrote:
> match_string() returns the index of an array for a matching string,
> which can be used instead of open coded variant.
>

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Yisheng Xie <xieyisheng1@huawei.com>
> ---
> v2:
>  - let ret get return value of match_string  - per Andy
>
>  drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> index 0e6401c..d7ac511 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> @@ -671,16 +671,11 @@ static ssize_t iwl_dbgfs_bt_cmd_read(struct file *file, char __user *user_buf,
>         };
>         int ret, bt_force_ant_mode;
>
> -       for (bt_force_ant_mode = 0;
> -            bt_force_ant_mode < ARRAY_SIZE(modes_str);
> -            bt_force_ant_mode++) {
> -               if (!strcmp(buf, modes_str[bt_force_ant_mode]))
> -                       break;
> -       }
> -
> -       if (bt_force_ant_mode >= ARRAY_SIZE(modes_str))
> -               return -EINVAL;
> +       ret = match_string(modes_str, ARRAY_SIZE(modes_str), buf);
> +       if (ret < 0)
> +               return ret;
>
> +       bt_force_ant_mode = ret;
>         ret = 0;
>         mutex_lock(&mvm->mutex);
>         if (mvm->bt_force_ant_mode == bt_force_ant_mode)
> --
> 1.7.12.4
>



-- 
With Best Regards,
Andy Shevchenko
