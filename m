Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:15148 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933068AbeGFOuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jul 2018 10:50:07 -0400
Date: Fri, 6 Jul 2018 22:48:57 +0800
From: kbuild test robot <lkp@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH v2 12/12] mt76: Kconfig and Makefile for mt76x0 driver
Message-ID: <201807062221.rzDTammd%fengguang.wu@intel.com> (sfid-20180706_165012_786551_1E4637C0)
References: <1530875029-26274-13-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1530875029-26274-13-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

I love your patch! Perhaps something to improve:

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.18-rc3 next-20180706]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Stanislaw-Gruszka/mt76-add-more-states/20180706-200412
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:253:15: sparse: expression using sizeof(void)
>> drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:253:15: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:282:15: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:282:15: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:325:15: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:325:15: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:354:15: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:354:15: sparse: expression using sizeof(void)
>> drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:344:5: sparse: symbol 'mt76x0_burst_read_regs' was not declared. Should it be static?
   drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c:463:13: sparse: expression using sizeof(void)
--
>> drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c:88:27: sparse: Variable length array is used.
--
>> drivers/net/wireless/mediatek/mt76/mt76x0/phy.c:969:34: sparse: expression using sizeof(void)
>> drivers/net/wireless/mediatek/mt76/mt76x0/phy.c:989:6: sparse: symbol 'mt76x0_ant_select' was not declared. Should it be static?
--
>> drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:88:21: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:97:31: sparse: expression using sizeof(void)
>> drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:166:16: sparse: incorrect type in return expression (different base types) @@    expected unsigned short @@    got restricted __leunsigned short @@
   drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:166:16:    expected unsigned short
   drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:166:16:    got restricted __le16 [usertype] <noident>
>> drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:175:23: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] tx_rate @@    got 16 [usertype] tx_rate @@
   drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:175:23:    expected restricted __le16 [usertype] tx_rate
   drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:175:23:    got unsigned short
   drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:438:30: sparse: expression using sizeof(void)
   drivers/net/wireless/mediatek/mt76/mt76x0/mac.c:438:30: sparse: expression using sizeof(void)
--
>> drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:93:26: sparse: incorrect type in assignment (different base types) @@    expected unsigned short [unsigned] [usertype] rate_ctl @@    got  short [unsigned] [usertype] rate_ctl @@
   drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:93:26:    expected unsigned short [unsigned] [usertype] rate_ctl
   drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:93:26:    got restricted __le16 [usertype] tx_rate
>> drivers/net/wireless/mediatek/mt76/mt76x0/tx.c:126:27: sparse: expression using sizeof(void)

Please review and possibly fold the followup patch.

vim +253 drivers/net/wireless/mediatek/mt76/mt76x0/mcu.c

9b00fd07 Stanislaw Gruszka 2018-07-06  242  
9b00fd07 Stanislaw Gruszka 2018-07-06  243  int mt76x0_write_reg_pairs(struct mt76x0_dev *dev, u32 base,
9b00fd07 Stanislaw Gruszka 2018-07-06  244  			   const struct mt76_reg_pair *data, int n)
9b00fd07 Stanislaw Gruszka 2018-07-06  245  {
9b00fd07 Stanislaw Gruszka 2018-07-06  246  	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 8;
9b00fd07 Stanislaw Gruszka 2018-07-06  247  	struct sk_buff *skb;
9b00fd07 Stanislaw Gruszka 2018-07-06  248  	int cnt, i, ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  249  
9b00fd07 Stanislaw Gruszka 2018-07-06  250  	if (!n)
9b00fd07 Stanislaw Gruszka 2018-07-06  251  		return 0;
9b00fd07 Stanislaw Gruszka 2018-07-06  252  
9b00fd07 Stanislaw Gruszka 2018-07-06 @253  	cnt = min(max_vals_per_cmd, n);
9b00fd07 Stanislaw Gruszka 2018-07-06  254  
9b00fd07 Stanislaw Gruszka 2018-07-06  255  	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
9b00fd07 Stanislaw Gruszka 2018-07-06  256  	if (!skb)
9b00fd07 Stanislaw Gruszka 2018-07-06  257  		return -ENOMEM;
9b00fd07 Stanislaw Gruszka 2018-07-06  258  	skb_reserve(skb, MT_DMA_HDR_LEN);
9b00fd07 Stanislaw Gruszka 2018-07-06  259  
9b00fd07 Stanislaw Gruszka 2018-07-06  260  	for (i = 0; i < cnt; i++) {
9b00fd07 Stanislaw Gruszka 2018-07-06  261  		skb_put_le32(skb, base + data[i].reg);
9b00fd07 Stanislaw Gruszka 2018-07-06  262  		skb_put_le32(skb, data[i].value);
9b00fd07 Stanislaw Gruszka 2018-07-06  263  	}
9b00fd07 Stanislaw Gruszka 2018-07-06  264  
9b00fd07 Stanislaw Gruszka 2018-07-06  265  	ret = mt76x0_mcu_msg_send(dev, skb, CMD_RANDOM_WRITE, cnt == n);
9b00fd07 Stanislaw Gruszka 2018-07-06  266  	if (ret)
9b00fd07 Stanislaw Gruszka 2018-07-06  267  		return ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  268  
9b00fd07 Stanislaw Gruszka 2018-07-06  269  	return mt76x0_write_reg_pairs(dev, base, data + cnt, n - cnt);
9b00fd07 Stanislaw Gruszka 2018-07-06  270  }
9b00fd07 Stanislaw Gruszka 2018-07-06  271  
9b00fd07 Stanislaw Gruszka 2018-07-06  272  int mt76x0_read_reg_pairs(struct mt76x0_dev *dev, u32 base,
9b00fd07 Stanislaw Gruszka 2018-07-06  273  			  struct mt76_reg_pair *data, int n)
9b00fd07 Stanislaw Gruszka 2018-07-06  274  {
9b00fd07 Stanislaw Gruszka 2018-07-06  275  	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 8;
9b00fd07 Stanislaw Gruszka 2018-07-06  276  	struct sk_buff *skb;
9b00fd07 Stanislaw Gruszka 2018-07-06  277  	int cnt, i, ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  278  
9b00fd07 Stanislaw Gruszka 2018-07-06  279  	if (!n)
9b00fd07 Stanislaw Gruszka 2018-07-06  280  		return 0;
9b00fd07 Stanislaw Gruszka 2018-07-06  281  
9b00fd07 Stanislaw Gruszka 2018-07-06  282  	cnt = min(max_vals_per_cmd, n);
9b00fd07 Stanislaw Gruszka 2018-07-06  283  	if (cnt != n)
9b00fd07 Stanislaw Gruszka 2018-07-06  284  		return -EINVAL;
9b00fd07 Stanislaw Gruszka 2018-07-06  285  
9b00fd07 Stanislaw Gruszka 2018-07-06  286  	skb = alloc_skb(cnt * 8 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
9b00fd07 Stanislaw Gruszka 2018-07-06  287  	if (!skb)
9b00fd07 Stanislaw Gruszka 2018-07-06  288  		return -ENOMEM;
9b00fd07 Stanislaw Gruszka 2018-07-06  289  	skb_reserve(skb, MT_DMA_HDR_LEN);
9b00fd07 Stanislaw Gruszka 2018-07-06  290  
9b00fd07 Stanislaw Gruszka 2018-07-06  291  	for (i = 0; i < cnt; i++) {
9b00fd07 Stanislaw Gruszka 2018-07-06  292  		skb_put_le32(skb, base + data[i].reg);
9b00fd07 Stanislaw Gruszka 2018-07-06  293  		skb_put_le32(skb, data[i].value);
9b00fd07 Stanislaw Gruszka 2018-07-06  294  	}
9b00fd07 Stanislaw Gruszka 2018-07-06  295  
9b00fd07 Stanislaw Gruszka 2018-07-06  296  	mutex_lock(&dev->mcu.mutex);
9b00fd07 Stanislaw Gruszka 2018-07-06  297  
9b00fd07 Stanislaw Gruszka 2018-07-06  298  	dev->mcu.reg_pairs = data;
9b00fd07 Stanislaw Gruszka 2018-07-06  299  	dev->mcu.reg_pairs_len = n;
9b00fd07 Stanislaw Gruszka 2018-07-06  300  	dev->mcu.reg_base = base;
9b00fd07 Stanislaw Gruszka 2018-07-06  301  	dev->mcu.burst_read = false;
9b00fd07 Stanislaw Gruszka 2018-07-06  302  
9b00fd07 Stanislaw Gruszka 2018-07-06  303  	ret = __mt76x0_mcu_msg_send(dev, skb, CMD_RANDOM_READ, true);
9b00fd07 Stanislaw Gruszka 2018-07-06  304  
9b00fd07 Stanislaw Gruszka 2018-07-06  305  	dev->mcu.reg_pairs = NULL;
9b00fd07 Stanislaw Gruszka 2018-07-06  306  
9b00fd07 Stanislaw Gruszka 2018-07-06  307  	mutex_unlock(&dev->mcu.mutex);
9b00fd07 Stanislaw Gruszka 2018-07-06  308  
9b00fd07 Stanislaw Gruszka 2018-07-06  309  	consume_skb(skb);
9b00fd07 Stanislaw Gruszka 2018-07-06  310  
9b00fd07 Stanislaw Gruszka 2018-07-06  311  	return ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  312  
9b00fd07 Stanislaw Gruszka 2018-07-06  313  }
9b00fd07 Stanislaw Gruszka 2018-07-06  314  
9b00fd07 Stanislaw Gruszka 2018-07-06  315  int mt76x0_burst_write_regs(struct mt76x0_dev *dev, u32 offset,
9b00fd07 Stanislaw Gruszka 2018-07-06  316  			     const u32 *data, int n)
9b00fd07 Stanislaw Gruszka 2018-07-06  317  {
9b00fd07 Stanislaw Gruszka 2018-07-06  318  	const int max_regs_per_cmd = INBAND_PACKET_MAX_LEN / 4 - 1;
9b00fd07 Stanislaw Gruszka 2018-07-06  319  	struct sk_buff *skb;
9b00fd07 Stanislaw Gruszka 2018-07-06  320  	int cnt, i, ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  321  
9b00fd07 Stanislaw Gruszka 2018-07-06  322  	if (!n)
9b00fd07 Stanislaw Gruszka 2018-07-06  323  		return 0;
9b00fd07 Stanislaw Gruszka 2018-07-06  324  
9b00fd07 Stanislaw Gruszka 2018-07-06  325  	cnt = min(max_regs_per_cmd, n);
9b00fd07 Stanislaw Gruszka 2018-07-06  326  
9b00fd07 Stanislaw Gruszka 2018-07-06  327  	skb = alloc_skb(cnt * 4 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
9b00fd07 Stanislaw Gruszka 2018-07-06  328  	if (!skb)
9b00fd07 Stanislaw Gruszka 2018-07-06  329  		return -ENOMEM;
9b00fd07 Stanislaw Gruszka 2018-07-06  330  	skb_reserve(skb, MT_DMA_HDR_LEN);
9b00fd07 Stanislaw Gruszka 2018-07-06  331  
9b00fd07 Stanislaw Gruszka 2018-07-06  332  	skb_put_le32(skb, MT_MCU_MEMMAP_WLAN + offset);
9b00fd07 Stanislaw Gruszka 2018-07-06  333  	for (i = 0; i < cnt; i++)
9b00fd07 Stanislaw Gruszka 2018-07-06  334  		skb_put_le32(skb, data[i]);
9b00fd07 Stanislaw Gruszka 2018-07-06  335  
9b00fd07 Stanislaw Gruszka 2018-07-06  336  	ret = mt76x0_mcu_msg_send(dev, skb, CMD_BURST_WRITE, cnt == n);
9b00fd07 Stanislaw Gruszka 2018-07-06  337  	if (ret)
9b00fd07 Stanislaw Gruszka 2018-07-06  338  		return ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  339  
9b00fd07 Stanislaw Gruszka 2018-07-06  340  	return mt76x0_burst_write_regs(dev, offset + cnt * 4,
9b00fd07 Stanislaw Gruszka 2018-07-06  341  					data + cnt, n - cnt);
9b00fd07 Stanislaw Gruszka 2018-07-06  342  }
9b00fd07 Stanislaw Gruszka 2018-07-06  343  
9b00fd07 Stanislaw Gruszka 2018-07-06 @344  int mt76x0_burst_read_regs(struct mt76x0_dev *dev, u32 base,
9b00fd07 Stanislaw Gruszka 2018-07-06  345  			   struct mt76_reg_pair *data, int n)
9b00fd07 Stanislaw Gruszka 2018-07-06  346  {
9b00fd07 Stanislaw Gruszka 2018-07-06  347  	const int max_vals_per_cmd = INBAND_PACKET_MAX_LEN / 4 - 1;
9b00fd07 Stanislaw Gruszka 2018-07-06  348  	struct sk_buff *skb;
9b00fd07 Stanislaw Gruszka 2018-07-06  349  	int cnt, ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  350  
9b00fd07 Stanislaw Gruszka 2018-07-06  351  	if (!n)
9b00fd07 Stanislaw Gruszka 2018-07-06  352  		return 0;
9b00fd07 Stanislaw Gruszka 2018-07-06  353  
9b00fd07 Stanislaw Gruszka 2018-07-06  354  	cnt = min(max_vals_per_cmd, n);
9b00fd07 Stanislaw Gruszka 2018-07-06  355  	if (cnt != n)
9b00fd07 Stanislaw Gruszka 2018-07-06  356  		return -EINVAL;
9b00fd07 Stanislaw Gruszka 2018-07-06  357  
9b00fd07 Stanislaw Gruszka 2018-07-06  358  	skb = alloc_skb(cnt * 4 + MT_DMA_HDR_LEN + 4, GFP_KERNEL);
9b00fd07 Stanislaw Gruszka 2018-07-06  359  	if (!skb)
9b00fd07 Stanislaw Gruszka 2018-07-06  360  		return -ENOMEM;
9b00fd07 Stanislaw Gruszka 2018-07-06  361  	skb_reserve(skb, MT_DMA_HDR_LEN);
9b00fd07 Stanislaw Gruszka 2018-07-06  362  
9b00fd07 Stanislaw Gruszka 2018-07-06  363  	skb_put_le32(skb, base + data[0].reg);
9b00fd07 Stanislaw Gruszka 2018-07-06  364  	skb_put_le32(skb, n);
9b00fd07 Stanislaw Gruszka 2018-07-06  365  
9b00fd07 Stanislaw Gruszka 2018-07-06  366  	mutex_lock(&dev->mcu.mutex);
9b00fd07 Stanislaw Gruszka 2018-07-06  367  
9b00fd07 Stanislaw Gruszka 2018-07-06  368  	dev->mcu.reg_pairs = data;
9b00fd07 Stanislaw Gruszka 2018-07-06  369  	dev->mcu.reg_pairs_len = n;
9b00fd07 Stanislaw Gruszka 2018-07-06  370  	dev->mcu.reg_base = base;
9b00fd07 Stanislaw Gruszka 2018-07-06  371  	dev->mcu.burst_read = true;
9b00fd07 Stanislaw Gruszka 2018-07-06  372  
9b00fd07 Stanislaw Gruszka 2018-07-06  373  	ret = __mt76x0_mcu_msg_send(dev, skb, CMD_BURST_READ, true);
9b00fd07 Stanislaw Gruszka 2018-07-06  374  
9b00fd07 Stanislaw Gruszka 2018-07-06  375  	dev->mcu.reg_pairs = NULL;
9b00fd07 Stanislaw Gruszka 2018-07-06  376  
9b00fd07 Stanislaw Gruszka 2018-07-06  377  	mutex_unlock(&dev->mcu.mutex);
9b00fd07 Stanislaw Gruszka 2018-07-06  378  
9b00fd07 Stanislaw Gruszka 2018-07-06  379  	consume_skb(skb);
9b00fd07 Stanislaw Gruszka 2018-07-06  380  
9b00fd07 Stanislaw Gruszka 2018-07-06  381  	return ret;
9b00fd07 Stanislaw Gruszka 2018-07-06  382  }
9b00fd07 Stanislaw Gruszka 2018-07-06  383  

:::::: The code at line 253 was first introduced by commit
:::::: 9b00fd07b938453189c6be7d366c71bc7528f7ce mt76x0: mcu files

:::::: TO: Stanislaw Gruszka <sgruszka@redhat.com>
:::::: CC: 0day robot <lkp@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
