Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8045DC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 02:52:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BACB206B2
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 02:52:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BACB206B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbeJJKM1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 06:12:27 -0400
Received: from mga02.intel.com ([134.134.136.20]:40679 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725837AbeJJKM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 06:12:27 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2018 19:52:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,362,1534834800"; 
   d="gz'50?scan'50,208,50";a="269991101"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 09 Oct 2018 19:48:19 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1gA4Xq-000G3m-Io; Wed, 10 Oct 2018 10:48:18 +0800
Date:   Wed, 10 Oct 2018 10:47:18 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>,
        Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Subject: Re: [PATCH v2 1/4] rt2x00: remove unneeded check
Message-ID: <201810101001.ltLh984D%fengguang.wu@intel.com>
References: <1539082867-4264-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1539082867-4264-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Tomislav,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on wireless-drivers-next/master]
[also build test ERROR on v4.19-rc7 next-20181009]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Stanislaw-Gruszka/rt2x00-remove-unneeded-check/20181010-012334
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
config: openrisc-allmodconfig (attached as .config)
compiler: or1k-linux-gcc (GCC) 6.0.0 20160327 (experimental)
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=openrisc 

All errors (new ones prefixed by >>):

   drivers/net/wireless/ralink/rt2x00/rt2800lib.c: In function 'rt2800_config_channel_rf3290':
   drivers/net/wireless/ralink/rt2x00/rt2800lib.c:2881:6: warning: unused variable 'idx' [-Wunused-variable]
     int idx = rf->channel-1;
         ^~~
   drivers/net/wireless/ralink/rt2x00/rt2800lib.c: In function 'rt2800_config_channel_rf53xx':
>> drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3016:20: error: 'idx' undeclared (first use in this function)
            r55_bt_rev[idx]);
                       ^~~
   drivers/net/wireless/ralink/rt2x00/rt2800lib.c:3016:20: note: each undeclared identifier is reported only once for each function it appears in

vim +/idx +3016 drivers/net/wireless/ralink/rt2x00/rt2800lib.c

0c9e5fb91 drivers/net/wireless/rt2x00/rt2800lib.c        Stanislaw Gruszka 2013-03-16  2875  
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2876  static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2877  					 struct ieee80211_conf *conf,
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2878  					 struct rf_channel *rf,
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2879  					 struct channel_info *info)
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2880  {
64cc6975c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Tomislav Požega   2018-10-09 @2881  	int idx = rf->channel-1;
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2882  	u8 rfcsr;
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2883  
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2884  	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2885  	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
16d571bb0 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Arnd Bergmann     2017-05-17  2886  	rfcsr = rt2800_rfcsr_read(rt2x00dev, 11);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2887  	rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf2);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2888  	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2889  
16d571bb0 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Arnd Bergmann     2017-05-17  2890  	rfcsr = rt2800_rfcsr_read(rt2x00dev, 49);
7573cb5b4 drivers/net/wireless/rt2x00/rt2800lib.c        Stanislaw Gruszka 2012-07-09  2891  	if (info->default_power1 > POWER_BOUND)
7573cb5b4 drivers/net/wireless/rt2x00/rt2800lib.c        Stanislaw Gruszka 2012-07-09  2892  		rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2893  	else
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2894  		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2895  	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2896  
884525411 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Stanislaw Gruszka 2016-12-19  2897  	rt2800_freq_cal_mode1(rt2x00dev);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2898  
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2899  	if (rf->channel <= 14) {
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2900  		if (rf->channel == 6)
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2901  			rt2800_bbp_write(rt2x00dev, 68, 0x0c);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2902  		else
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2903  			rt2800_bbp_write(rt2x00dev, 68, 0x0b);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2904  
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2905  		if (rf->channel >= 1 && rf->channel <= 6)
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2906  			rt2800_bbp_write(rt2x00dev, 59, 0x0f);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2907  		else if (rf->channel >= 7 && rf->channel <= 11)
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2908  			rt2800_bbp_write(rt2x00dev, 59, 0x0e);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2909  		else if (rf->channel >= 12 && rf->channel <= 14)
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2910  			rt2800_bbp_write(rt2x00dev, 59, 0x0d);
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2911  	}
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2912  }
a89534eda drivers/net/wireless/rt2x00/rt2800lib.c        Woody Hung        2012-06-13  2913  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2914  static void rt2800_config_channel_rf3322(struct rt2x00_dev *rt2x00dev,
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2915  					 struct ieee80211_conf *conf,
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2916  					 struct rf_channel *rf,
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2917  					 struct channel_info *info)
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2918  {
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2919  	u8 rfcsr;
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2920  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2921  	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2922  	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2923  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2924  	rt2800_rfcsr_write(rt2x00dev, 11, 0x42);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2925  	rt2800_rfcsr_write(rt2x00dev, 12, 0x1c);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2926  	rt2800_rfcsr_write(rt2x00dev, 13, 0x00);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2927  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2928  	if (info->default_power1 > POWER_BOUND)
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2929  		rt2800_rfcsr_write(rt2x00dev, 47, POWER_BOUND);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2930  	else
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2931  		rt2800_rfcsr_write(rt2x00dev, 47, info->default_power1);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2932  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2933  	if (info->default_power2 > POWER_BOUND)
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2934  		rt2800_rfcsr_write(rt2x00dev, 48, POWER_BOUND);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2935  	else
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2936  		rt2800_rfcsr_write(rt2x00dev, 48, info->default_power2);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2937  
884525411 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Stanislaw Gruszka 2016-12-19  2938  	rt2800_freq_cal_mode1(rt2x00dev);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2939  
16d571bb0 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Arnd Bergmann     2017-05-17  2940  	rfcsr = rt2800_rfcsr_read(rt2x00dev, 1);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2941  	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2942  	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2943  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2944  	if ( rt2x00dev->default_ant.tx_chain_num == 2 )
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2945  		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2946  	else
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2947  		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2948  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2949  	if ( rt2x00dev->default_ant.rx_chain_num == 2 )
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2950  		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2951  	else
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2952  		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2953  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2954  	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2955  	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2956  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2957  	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2958  
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2959  	rt2800_rfcsr_write(rt2x00dev, 31, 80);
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2960  }
038399515 drivers/net/wireless/rt2x00/rt2800lib.c        Daniel Golle      2012-09-09  2961  
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2962  static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2963  					 struct ieee80211_conf *conf,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2964  					 struct rf_channel *rf,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2965  					 struct channel_info *info)
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2966  {
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2967  	u8 rfcsr;
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2968  
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2969  	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2970  	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3);
16d571bb0 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Arnd Bergmann     2017-05-17  2971  	rfcsr = rt2800_rfcsr_read(rt2x00dev, 11);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2972  	rt2x00_set_field8(&rfcsr, RFCSR11_R, rf->rf2);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2973  	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2974  
16d571bb0 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Arnd Bergmann     2017-05-17  2975  	rfcsr = rt2800_rfcsr_read(rt2x00dev, 49);
7573cb5b4 drivers/net/wireless/rt2x00/rt2800lib.c        Stanislaw Gruszka 2012-07-09  2976  	if (info->default_power1 > POWER_BOUND)
7573cb5b4 drivers/net/wireless/rt2x00/rt2800lib.c        Stanislaw Gruszka 2012-07-09  2977  		rt2x00_set_field8(&rfcsr, RFCSR49_TX, POWER_BOUND);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2978  	else
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2979  		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2980  	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2981  
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2982  	if (rt2x00_rt(rt2x00dev, RT5392)) {
16d571bb0 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Arnd Bergmann     2017-05-17  2983  		rfcsr = rt2800_rfcsr_read(rt2x00dev, 50);
6264995f8 drivers/net/wireless/rt2x00/rt2800lib.c        Felipe Pena       2013-10-18  2984  		if (info->default_power2 > POWER_BOUND)
7573cb5b4 drivers/net/wireless/rt2x00/rt2800lib.c        Stanislaw Gruszka 2012-07-09  2985  			rt2x00_set_field8(&rfcsr, RFCSR50_TX, POWER_BOUND);
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2986  		else
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2987  			rt2x00_set_field8(&rfcsr, RFCSR50_TX,
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2988  					  info->default_power2);
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2989  		rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2990  	}
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2991  
16d571bb0 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Arnd Bergmann     2017-05-17  2992  	rfcsr = rt2800_rfcsr_read(rt2x00dev, 1);
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2993  	if (rt2x00_rt(rt2x00dev, RT5392)) {
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2994  		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2995  		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
cff3d1f09 drivers/net/wireless/rt2x00/rt2800lib.c        Zero.Lin          2012-05-29  2996  	}
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2997  	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2998  	rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  2999  	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3000  	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3001  	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3002  
884525411 drivers/net/wireless/ralink/rt2x00/rt2800lib.c Stanislaw Gruszka 2016-12-19  3003  	rt2800_freq_cal_mode1(rt2x00dev);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3004  
c429dfef7 drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2013-10-11  3005  	if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3006  		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3007  			/* r55/r59 value array of channel 1~14 */
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3008  			static const char r55_bt_rev[] = {0x83, 0x83,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3009  				0x83, 0x73, 0x73, 0x63, 0x53, 0x53,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3010  				0x53, 0x43, 0x43, 0x43, 0x43, 0x43};
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3011  			static const char r59_bt_rev[] = {0x0e, 0x0e,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3012  				0x0e, 0x0e, 0x0e, 0x0b, 0x0a, 0x09,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3013  				0x07, 0x07, 0x07, 0x07, 0x07, 0x07};
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3014  
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3015  			rt2800_rfcsr_write(rt2x00dev, 55,
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03 @3016  					   r55_bt_rev[idx]);
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3017  			rt2800_rfcsr_write(rt2x00dev, 59,
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3018  					   r59_bt_rev[idx]);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3019  		} else {
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3020  			static const char r59_bt[] = {0x8b, 0x8b, 0x8b,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3021  				0x8b, 0x8b, 0x8b, 0x8b, 0x8a, 0x89,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3022  				0x88, 0x88, 0x86, 0x85, 0x84};
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3023  
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3024  			rt2800_rfcsr_write(rt2x00dev, 59, r59_bt[idx]);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3025  		}
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3026  	} else {
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3027  		if (rt2x00_rt_rev_gte(rt2x00dev, RT5390, REV_RT5390F)) {
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3028  			static const char r55_nonbt_rev[] = {0x23, 0x23,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3029  				0x23, 0x23, 0x13, 0x13, 0x03, 0x03,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3030  				0x03, 0x03, 0x03, 0x03, 0x03, 0x03};
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3031  			static const char r59_nonbt_rev[] = {0x07, 0x07,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3032  				0x07, 0x07, 0x07, 0x07, 0x07, 0x07,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3033  				0x07, 0x07, 0x06, 0x05, 0x04, 0x04};
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3034  
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3035  			rt2800_rfcsr_write(rt2x00dev, 55,
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3036  					   r55_nonbt_rev[idx]);
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3037  			rt2800_rfcsr_write(rt2x00dev, 59,
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3038  					   r59_nonbt_rev[idx]);
2ed718844 drivers/net/wireless/rt2x00/rt2800lib.c        John Li           2012-02-17  3039  		} else if (rt2x00_rt(rt2x00dev, RT5390) ||
41977e86c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Roman Yeryomin    2017-03-21  3040  			   rt2x00_rt(rt2x00dev, RT5392) ||
41977e86c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Roman Yeryomin    2017-03-21  3041  			   rt2x00_rt(rt2x00dev, RT6352)) {
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3042  			static const char r59_non_bt[] = {0x8f, 0x8f,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3043  				0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3044  				0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3045  
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3046  			rt2800_rfcsr_write(rt2x00dev, 59,
adde5882b drivers/net/wireless/rt2x00/rt2800lib.c        Gabor Juhos       2011-03-03  3047  					   r59_non_bt[idx]);
98e71f44c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Serge Vasilugin   2017-01-20  3048  		} else if (rt2x00_rt(rt2x00dev, RT5350)) {
98e71f44c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Serge Vasilugin   2017-01-20  3049  			static const char r59_non_bt[] = {0x0b, 0x0b,
98e71f44c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Serge Vasilugin   2017-01-20  3050  				0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
98e71f44c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Serge Vasilugin   2017-01-20  3051  				0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};
98e71f44c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Serge Vasilugin   2017-01-20  3052  
98e71f44c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Serge Vasilugin   2017-01-20  3053  			rt2800_rfcsr_write(rt2x00dev, 59,
98e71f44c drivers/net/wireless/ralink/rt2x00/rt2800lib.c Serge Vasilugin   2017-01-20  3054  					   r59_non_bt[idx]);
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3055  		}
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3056  	}
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3057  }
60687ba71 drivers/net/wireless/rt2x00/rt2800lib.c        RA-Shiang Tu      2011-02-20  3058  

:::::: The code at line 3016 was first introduced by commit
:::::: adde5882bc6c21de7ee80ee15dfd58c7e9a472ac rt2x00: fix whitespace damage in the rt2800 specific code

:::::: TO: Gabor Juhos <juhosg@openwrt.org>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--2fHTh5uZTiUOsy+g
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
tYl594//AyOWE4Sj2gIA

--2fHTh5uZTiUOsy+g--
