Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7342 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbcFUQlo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 12:41:44 -0400
Date: Wed, 22 Jun 2016 00:41:04 +0800
From: kbuild test robot <lkp@intel.com>
To: Prasun Maiti <prasunmaiti87@gmail.com>
Cc: kbuild-all@01.org, Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] mwifiex: Reduce endian conversion for REG Host Commands
Message-ID: <201606220027.euqOehrM%fengguang.wu@intel.com> (sfid-20160621_184203_766538_F83AFAC5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1466519967-15555-1-git-send-email-prasunmaiti87@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.7-rc4 next-20160621]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Prasun-Maiti/mwifiex-Reduce-endian-conversion-for-REG-Host-Commands/20160621-224149
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> drivers/net/wireless/marvell/mwifiex/sta_ioctl.c:1339:17: sparse: incompatible types in comparison expression (different base types)
   In file included from include/linux/list.h:8:0,
                    from include/linux/wait.h:6,
                    from drivers/net/wireless/marvell/mwifiex/decl.h:26,
                    from drivers/net/wireless/marvell/mwifiex/sta_ioctl.c:20:
   drivers/net/wireless/marvell/mwifiex/sta_ioctl.c: In function 'mwifiex_eeprom_read':
   include/linux/kernel.h:742:17: warning: comparison of distinct pointer types lacks a cast
     (void) (&_min1 == &_min2);  \
                    ^
   drivers/net/wireless/marvell/mwifiex/sta_ioctl.c:1339:34: note: in expansion of macro 'min'
      memcpy(value, rd_eeprom.value, min(MAX_EEPROM_DATA,
                                     ^~~
--
   include/linux/compiler.h:232:8: sparse: attribute 'no_sanitize_address': unknown attribute
>> drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c:820:25: sparse: incompatible types in comparison expression (different base types)
   In file included from include/linux/list.h:8:0,
                    from include/linux/wait.h:6,
                    from drivers/net/wireless/marvell/mwifiex/decl.h:26,
                    from drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c:20:
   drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c: In function 'mwifiex_ret_reg_access':
   include/linux/kernel.h:742:17: warning: comparison of distinct pointer types lacks a cast
     (void) (&_min1 == &_min2);  \
                    ^
   drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c:821:6: note: in expansion of macro 'min'
         min(MAX_EEPROM_DATA, eeprom->byte_count));
         ^~~

vim +1339 drivers/net/wireless/marvell/mwifiex/sta_ioctl.c

  1323	 */
  1324	int
  1325	mwifiex_eeprom_read(struct mwifiex_private *priv, u16 offset, u16 bytes,
  1326			    u8 *value)
  1327	{
  1328		int ret;
  1329		struct mwifiex_ds_read_eeprom rd_eeprom;
  1330	
  1331		rd_eeprom.offset =  offset;
  1332		rd_eeprom.byte_count = bytes;
  1333	
  1334		/* Send request to firmware */
  1335		ret = mwifiex_send_cmd(priv, HostCmd_CMD_802_11_EEPROM_ACCESS,
  1336				       HostCmd_ACT_GEN_GET, 0, &rd_eeprom, true);
  1337	
  1338		if (!ret)
> 1339			memcpy(value, rd_eeprom.value, min(MAX_EEPROM_DATA,
  1340						rd_eeprom.byte_count));
  1341		return ret;
  1342	}
  1343	
  1344	/*
  1345	 * This function sets a generic IE. In addition to generic IE, it can
  1346	 * also handle WPA, WPA2 and WAPI IEs.
  1347	 */

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
