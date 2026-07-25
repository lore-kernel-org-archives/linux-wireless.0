Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F64389111
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 03:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784951748; cv=none; b=RFCzkkvDtT4Mf2F0bzvlFwOZvwCMbyHQm751lIzqXgWzVrdvbtyovjuh+XDKDjfmlJbL3wBtbqQVW31UM4C8JvB9xqlqx83QuvYT67SpD7AhXNo9+JM5SK8QRP7uInQK3MqIXc6rm1l3oUgU0+K0O5EaTbM+vD0jf5dF/nrDI6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784951748; c=relaxed/simple;
	bh=a/8RwzmKLG7uwZieP9EWP8WEah6Qds0ZpbVQgqjvNhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTzeCmKRMVXXMOiuYKY4W9eWJYH6ihbB00VFhlFpaglpLKkQlESnNMZGxEE1T8T0X4OxHYeGcjIPa/FIsWgXjAYa58O/Rq3JmLjPwQmGZbJNhXHJr057p15L9wbQy/cq7abgOxPf0vXEV+jfAIDptWe7jAuJIDFEJSxSf9bduQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WR1b41KS; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WR1b41KS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784951746; x=1816487746;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=a/8RwzmKLG7uwZieP9EWP8WEah6Qds0ZpbVQgqjvNhY=;
  b=WR1b41KSnr0Ej6c8pPTLT8UPFV9Vi48gICKz14QZgqDCQn68jJhm4TAg
   A8IWh1KZK/MIl3c+Spb4+/toTVkyQ4YnXNAeg8EkeAFNbLD/ZNGbo1nAb
   amRPjqaQgX1UDUvvYhscXKQcOlCh+6D9g+93Dor6eeCsKbW4tv4y1PvHx
   PiEtQk0JKJ9VHA7Ejn5x+vnP4P77IHbOhUb5mLPjI1XYel3ulV3jf699+
   0BhduKKhYUEJSrX/ticbSMg7mPaBRokaqKl1/wNG6U1Bu8KYy957o8cFz
   2ZfxmWR1QQSN9fPQBuVO0NP+8KiYvVpajCxltSKjMk9mcxG4b1apFchJv
   Q==;
X-CSE-ConnectionGUID: upYymoE0S0KsPf8bwwKwsg==
X-CSE-MsgGUID: UNeoRitcTM6KIWkJOkyWxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11855"; a="96768688"
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="96768688"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2026 20:55:45 -0700
X-CSE-ConnectionGUID: O/Gy6JJMTbGNFEXK9Dd95Q==
X-CSE-MsgGUID: pPPnVE9DSSiy0os5Kk3LLg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,183,1779174000"; 
   d="scan'208";a="256226623"
Received: from igk-lkp-server01.igk.intel.com (HELO 3cba2a188a06) ([10.211.93.152])
  by fmviesa008.fm.intel.com with ESMTP; 24 Jul 2026 20:55:41 -0700
Received: from kbuild by 3cba2a188a06 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wnTUB-00000000162-2zlA;
	Sat, 25 Jul 2026 03:55:39 +0000
Date: Sat, 25 Jul 2026 05:54:43 +0200
From: kernel test robot <lkp@intel.com>
To: JB Tsai <jb.tsai@mediatek.com>, nbd@nbd.name, lorenzo@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-mediatek@lists.infradead.org, Sean.Wang@mediatek.com,
	Quan.Zhou@mediatek.com, Ryder.Lee@mediatek.com,
	litien.chang@mediatek.com, Charlie-cy.Wu@mediatek.com,
	jb.tsai@mediatek.com
Subject: Re: [PATCH] wifi: mt76: connac3: refactor CLC header type validation
 logic
Message-ID: <202607250538.5NE4yF8u-lkp@intel.com>
References: <20260724085124.3156143-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260724085124.3156143-1-jb.tsai@mediatek.com>

Hi JB,

kernel test robot noticed the following build errors:

[auto build test ERROR on wireless-next/main]
[also build test ERROR on wireless/main linus/master v7.2-rc4 next-20260723]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/JB-Tsai/wifi-mt76-connac3-refactor-CLC-header-type-validation-logic/20260724-170015
base:   https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git main
patch link:    https://lore.kernel.org/r/20260724085124.3156143-1-jb.tsai%40mediatek.com
patch subject: [PATCH] wifi: mt76: connac3: refactor CLC header type validation logic
config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260725/202607250538.5NE4yF8u-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260725/202607250538.5NE4yF8u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607250538.5NE4yF8u-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/wireless/mediatek/mt76/mt7925/mcu.c: In function 'mt7925_load_clc':
>> drivers/net/wireless/mediatek/mt76/mt7925/mcu.c:866:68: error: 'MT792x_CLC_REGD' undeclared (first use in this function); did you mean 'MT7925_CLC_CHAN'?
     866 |                 if ((clc->idx == MT792x_CLC_BE_CTRL || clc->idx == MT792x_CLC_REGD) &&
         |                                                                    ^~~~~~~~~~~~~~~
         |                                                                    MT7925_CLC_CHAN
   drivers/net/wireless/mediatek/mt76/mt7925/mcu.c:866:68: note: each undeclared identifier is reported only once for each function it appears in


vim +866 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c

   797	
   798	static int mt7925_load_clc(struct mt792x_dev *dev, const char *fw_name)
   799	{
   800		const struct mt76_connac2_fw_trailer *hdr;
   801		const struct mt76_connac2_fw_region *region;
   802		const struct mt7925_clc *clc;
   803		struct mt76_dev *mdev = &dev->mt76;
   804		struct mt792x_phy *phy = &dev->phy;
   805		const struct firmware *fw;
   806		u8 *clc_base = NULL, hw_encap = 0;
   807		int ret, i, len, offset = 0;
   808	
   809		dev->phy.clc_chan_conf = 0xff;
   810		dev->regd_user = false;
   811		if (!mt7925_regd_clc_supported(dev))
   812			return 0;
   813	
   814		if (mt76_is_mmio(&dev->mt76)) {
   815			ret = mt7925_mcu_read_eeprom(dev, MT_EE_HW_TYPE, &hw_encap);
   816			if (ret)
   817				return ret;
   818			hw_encap = u8_get_bits(hw_encap, MT_EE_HW_TYPE_ENCAP);
   819		}
   820	
   821		ret = request_firmware(&fw, fw_name, mdev->dev);
   822		if (ret)
   823			return ret;
   824	
   825		if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
   826			dev_err(mdev->dev, "Invalid firmware\n");
   827			ret = -EINVAL;
   828			goto out;
   829		}
   830	
   831		hdr = (const void *)(fw->data + fw->size - sizeof(*hdr));
   832		for (i = 0; i < hdr->n_region; i++) {
   833			region = (const void *)((const u8 *)hdr -
   834						(hdr->n_region - i) * sizeof(*region));
   835			len = le32_to_cpu(region->len);
   836	
   837			/* check if we have valid buffer size */
   838			if (offset + len > fw->size) {
   839				dev_err(mdev->dev, "Invalid firmware region\n");
   840				ret = -EINVAL;
   841				goto out;
   842			}
   843	
   844			if ((region->feature_set & FW_FEATURE_NON_DL) &&
   845			    region->type == FW_TYPE_CLC) {
   846				clc_base = (u8 *)(fw->data + offset);
   847				break;
   848			}
   849			offset += len;
   850		}
   851	
   852		if (!clc_base)
   853			goto out;
   854	
   855		for (offset = 0; offset < len; offset += le32_to_cpu(clc->len)) {
   856			clc = (const struct mt7925_clc *)(clc_base + offset);
   857	
   858			if (clc->idx >= ARRAY_SIZE(phy->clc))
   859				break;
   860	
   861			/* do not init buf again if chip reset triggered */
   862			if (phy->clc[clc->idx])
   863				continue;
   864	
   865			/* header content sanity */
 > 866			if ((clc->idx == MT792x_CLC_BE_CTRL || clc->idx == MT792x_CLC_REGD) &&
   867			    u8_get_bits(clc->t2.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
   868				continue;
   869	
   870			if (clc->idx != MT792x_CLC_BE_CTRL && clc->idx != MT792x_CLC_REGD &&
   871			    u8_get_bits(clc->t0.type, MT_EE_HW_TYPE_ENCAP) != hw_encap)
   872				continue;
   873	
   874			phy->clc[clc->idx] = devm_kmemdup(mdev->dev, clc,
   875							  le32_to_cpu(clc->len),
   876							  GFP_KERNEL);
   877	
   878			if (!phy->clc[clc->idx]) {
   879				ret = -ENOMEM;
   880				goto out;
   881			}
   882		}
   883	
   884		ret = mt7925_regd_init(phy);
   885	out:
   886		release_firmware(fw);
   887	
   888		return ret;
   889	}
   890	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
