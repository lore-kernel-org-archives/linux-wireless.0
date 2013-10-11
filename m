Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47189 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab3JKHTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 03:19:48 -0400
Received: by mail-vc0-f179.google.com with SMTP id ht10so2487714vcb.38
        for <linux-wireless@vger.kernel.org>; Fri, 11 Oct 2013 00:19:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131011014733.GD11191@localhost>
References: <525720d0.6xVLGLwuRrqxqOBI%fengguang.wu@intel.com>
	<20131011014733.GD11191@localhost>
Date: Fri, 11 Oct 2013 08:19:47 +0100
Message-ID: <CAFSJ42aa_-DTHDxkRDM+0bm9052ree__K54CRm749SeQPDHwRw@mail.gmail.com> (sfid-20131011_091951_879185_187DCB17)
Subject: Re: [wireless-next:master 82/98] drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24:
 sparse: incorrect type in assignment (different base types)
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: kbuild-all@01.org, "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hm.. weird. I was sure that i fixed all sparse warnings before
contribution. My sparse does not show this warning. Let me try to
reproduce this error and come back to you. Thanx for you feedback.

On Fri, Oct 11, 2013 at 2:47 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>
> Hi Eugene,
>
> FYI, there are new sparse warnings show up in
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
> head:   e25aa82a89db9e3b09d02b5481aa375c7712a10d
> commit: 8e84c25821698bdef73c0329fb2022a4673b7adc [82/98] wcn36xx: mac80211 driver for Qualcomm WCN3660/WCN3680 hardware
> reproduce: make C=1 CF=-D__CHECK_ENDIAN__
>
>>> drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24: sparse: incorrect type in assignment (different base types)
>    drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24:    expected unsigned int [unsigned] [usertype] <noident>
>    drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24:    got restricted __be32 [usertype] <noident>
>>> drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24: sparse: incorrect type in assignment (different base types)
>    drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24:    expected unsigned int [unsigned] [usertype] <noident>
>    drivers/net/wireless/ath/wcn36xx/wcn36xx.h:88:24:    got restricted __be32 [usertype] <noident>
>
> vim +88 drivers/net/wireless/ath/wcn36xx/wcn36xx.h
>
> 8e84c258 Eugene Krasnikov 2013-10-08  72                print_hex_dump(KERN_DEBUG, pr_fmt(prefix_str),  \
> 8e84c258 Eugene Krasnikov 2013-10-08  73                               DUMP_PREFIX_OFFSET, 32, 1,       \
> 8e84c258 Eugene Krasnikov 2013-10-08  74                               buf, len, false);                \
> 8e84c258 Eugene Krasnikov 2013-10-08  75  } while (0)
> 8e84c258 Eugene Krasnikov 2013-10-08  76
> 8e84c258 Eugene Krasnikov 2013-10-08  77  #define WCN36XX_HW_CHANNEL(__wcn) (__wcn->hw->conf.chandef.chan->hw_value)
> 8e84c258 Eugene Krasnikov 2013-10-08  78  #define WCN36XX_BAND(__wcn) (__wcn->hw->conf.chandef.chan->band)
> 8e84c258 Eugene Krasnikov 2013-10-08  79  #define WCN36XX_CENTER_FREQ(__wcn) (__wcn->hw->conf.chandef.chan->center_freq)
> 8e84c258 Eugene Krasnikov 2013-10-08  80  #define WCN36XX_LISTEN_INTERVAL(__wcn) (__wcn->hw->conf.listen_interval)
> 8e84c258 Eugene Krasnikov 2013-10-08  81  #define WCN36XX_FLAGS(__wcn) (__wcn->hw->flags)
> 8e84c258 Eugene Krasnikov 2013-10-08  82  #define WCN36XX_MAX_POWER(__wcn) (__wcn->hw->conf.chandef.chan->max_power)
> 8e84c258 Eugene Krasnikov 2013-10-08  83
> 8e84c258 Eugene Krasnikov 2013-10-08  84  static inline void buff_to_be(u32 *buf, size_t len)
> 8e84c258 Eugene Krasnikov 2013-10-08  85  {
> 8e84c258 Eugene Krasnikov 2013-10-08  86        int i;
> 8e84c258 Eugene Krasnikov 2013-10-08  87        for (i = 0; i < len; i++)
> 8e84c258 Eugene Krasnikov 2013-10-08 @88                buf[i] = cpu_to_be32(buf[i]);
> 8e84c258 Eugene Krasnikov 2013-10-08  89  }
> 8e84c258 Eugene Krasnikov 2013-10-08  90
> 8e84c258 Eugene Krasnikov 2013-10-08  91  struct nv_data {
> 8e84c258 Eugene Krasnikov 2013-10-08  92        int     is_valid;
> 8e84c258 Eugene Krasnikov 2013-10-08  93        u8      table;
> 8e84c258 Eugene Krasnikov 2013-10-08  94  };
> 8e84c258 Eugene Krasnikov 2013-10-08  95
> 8e84c258 Eugene Krasnikov 2013-10-08  96  /* Interface for platform control path
>
> ---
> 0-DAY kernel build testing backend              Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation



-- 
Best regards,
Eugene
