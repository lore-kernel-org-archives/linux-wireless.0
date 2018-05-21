Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:40487 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751694AbeEUVnX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 17:43:23 -0400
MIME-Version: 1.0
In-Reply-To: <1526903890-35761-8-git-send-email-xieyisheng1@huawei.com>
References: <1526903890-35761-1-git-send-email-xieyisheng1@huawei.com> <1526903890-35761-8-git-send-email-xieyisheng1@huawei.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue, 22 May 2018 00:43:21 +0300
Message-ID: <CAHp75VeFiEMN+q0FPuk4qTVEW_1oovHzVkV_Ydcm22SEMarvUA@mail.gmail.com> (sfid-20180521_234400_585412_A729AE66)
Subject: Re: [PATCH 07/33] iwlwifi: mvm: use match_string() helper
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

On Mon, May 21, 2018 at 2:57 PM, Yisheng Xie <xieyisheng1@huawei.com> wrote:
> match_string() returns the index of an array for a matching string,
> which can be used intead of open coded variant.

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

> +       bt_force_ant_mode = match_string(modes_str,
> +                                        ARRAY_SIZE(modes_str), buf);

One line?

> +       if (bt_force_ant_mode < 0)
>                 return -EINVAL;

I would rather use

ret = match_string();
if (ret < 0)
 return ret;

bt_force_... = ret;

But it's up tu Loca.

>
>         ret = 0;



-- 
With Best Regards,
Andy Shevchenko
