Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33142 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdEMK0Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 06:26:25 -0400
Received: by mail-oi0-f66.google.com with SMTP id h4so12284637oib.0
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 03:26:24 -0700 (PDT)
Subject: Re: [PATCH v3 06/10] rtlwifi: btcoex: 21a 2ant: run mechanism if
 status changes or auto adjust is set
To: kbuild test robot <lkp@intel.com>
References: <201705131440.aH3XG7kJ%fengguang.wu@intel.com>
Cc: kbuild-all@01.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Pkshih <pkshih@realtek.com>, Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <bbfc52c1-0633-4145-263a-a8558148dd97@lwfinger.net> (sfid-20170513_122643_565695_9EAFBE9C)
Date: Sat, 13 May 2017 05:26:23 -0500
MIME-Version: 1.0
In-Reply-To: <201705131440.aH3XG7kJ%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/13/2017 01:57 AM, kbuild test robot wrote:
> Hi Yan-Hsuan,
>
> [auto build test ERROR on wireless-drivers-next/master]
> [also build test ERROR on next-20170512]
> [cannot apply to v4.11]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

This patch depends on the previously submitted, but not yet merged patch in 
https://patchwork.kernel.org/patch/9712523/.

Larry

>
> url:    https://github.com/0day-ci/linux/commits/Larry-Finger/rtlwifi-btcoex-21a-2ant-set-tdma-with-rssi-states/20170513-140718
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: alpha-allmodconfig (attached as .config)
> compiler: alpha-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=alpha
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless//realtek/rtlwifi/btcoexist/halbtc8821a2ant.c: In function 'ex_btc8821a2ant_periodical':
>>> drivers/net/wireless//realtek/rtlwifi/btcoexist/halbtc8821a2ant.c:4203:15: error: 'struct btc_coexist' has no member named 'auto_report_2ant'
>      if (btcoexist->auto_report_2ant) {
>                   ^~
>
> vim +4203 drivers/net/wireless//realtek/rtlwifi/btcoexist/halbtc8821a2ant.c
>
>   4197				 glcoex_ver_date_8821a_2ant, glcoex_ver_8821a_2ant,
>   4198				 fw_ver, bt_patch_ver, bt_patch_ver);
>   4199			RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
>   4200				 "[BTCoex], ****************************************************************\n");
>   4201		}
>   4202	
>> 4203		if (btcoexist->auto_report_2ant) {
>   4204			btc8821a2ant_query_bt_info(btcoexist);
>   4205		} else {
>   4206			btc8821a2ant_monitor_bt_ctr(btcoexist);
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
>
