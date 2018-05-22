Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:8126 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751271AbeEVDaY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 23:30:24 -0400
Subject: Re: [PATCH 07/33] iwlwifi: mvm: use match_string() helper
To: Andy Shevchenko <andy.shevchenko@gmail.com>
References: <1526903890-35761-1-git-send-email-xieyisheng1@huawei.com>
 <1526903890-35761-8-git-send-email-xieyisheng1@huawei.com>
 <CAHp75VeFiEMN+q0FPuk4qTVEW_1oovHzVkV_Ydcm22SEMarvUA@mail.gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
From: Yisheng Xie <xieyisheng1@huawei.com>
Message-ID: <63a78572-b7d3-9cc7-9e22-5bd19cad3333@huawei.com> (sfid-20180522_053247_368524_45B95BE6)
Date: Tue, 22 May 2018 11:30:02 +0800
MIME-Version: 1.0
In-Reply-To: <CAHp75VeFiEMN+q0FPuk4qTVEW_1oovHzVkV_Ydcm22SEMarvUA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On 2018/5/22 5:43, Andy Shevchenko wrote:
> On Mon, May 21, 2018 at 2:57 PM, Yisheng Xie <xieyisheng1@huawei.com> wrote:
>> match_string() returns the index of an array for a matching string,
>> which can be used intead of open coded variant.
> 
>>         int ret, bt_force_ant_mode;
>>
>> -       for (bt_force_ant_mode = 0;
>> -            bt_force_ant_mode < ARRAY_SIZE(modes_str);
>> -            bt_force_ant_mode++) {
>> -               if (!strcmp(buf, modes_str[bt_force_ant_mode]))
>> -                       break;
>> -       }
>> -
>> -       if (bt_force_ant_mode >= ARRAY_SIZE(modes_str))
> 
>> +       bt_force_ant_mode = match_string(modes_str,
>> +                                        ARRAY_SIZE(modes_str), buf);
> 
> One line?

hmm, if use ret instead it will no over 80 chars.

> 
>> +       if (bt_force_ant_mode < 0)
>>                 return -EINVAL;
> 
> I would rather use
> 
> ret = match_string();
> if (ret < 0)
>  return ret;
> 
> bt_force_... = ret;
> 
> But it's up tu Loca.

OK, I will change it if Loca agree your opinion.

Thanks
Yisheng
> 
>>
>>         ret = 0;
> 
> 
> 
