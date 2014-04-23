Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24515 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836AbaDWOa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 10:30:59 -0400
Date: Wed, 23 Apr 2014 17:30:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: akarwar@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: add firmware dump feature for PCIe
Message-ID: <20140423143029.GA28228@mwanda> (sfid-20140423_163104_823790_DF72B834)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Amitkumar Karwar,

The patch e050c76fcf49: "mwifiex: add firmware dump feature for PCIe"
from Apr 17, 2014, leads to the following static checker warning:

	drivers/net/wireless/mwifiex/pcie.c:2252 mwifiex_pcie_fw_dump_work()
	error: we previously assumed 'adapter' could be null (see line 2251)

drivers/net/wireless/mwifiex/pcie.c
  2228  /* This function dump firmware memory to file */
  2229  static void mwifiex_pcie_fw_dump_work(struct work_struct *work)
  2230  {
  2231          struct mwifiex_adapter *adapter =
  2232                          container_of(work, struct mwifiex_adapter, iface_work);
  2233          unsigned int reg, reg_start, reg_end;
  2234          u8 *dbg_ptr;
  2235          struct timeval t;
  2236          u8 dump_num = 0, idx, i, read_reg, doneflag = 0;
  2237          enum rdwr_status stat;
  2238          u32 memory_size;
  2239          u8 filename[MAX_FULL_NAME_LEN];
  2240          mm_segment_t fs;
  2241          loff_t pos;
  2242          u8 *end_ptr;
  2243          u8 *name_prefix = "/var/log/fw_dump_";
  2244          struct memory_type_mapping mem_type_mapping_tbl[] = {
  2245                  {"ITCM", NULL, NULL, 0xF0},
  2246                  {"DTCM", NULL, NULL, 0xF1},
  2247                  {"SQRAM", NULL, NULL, 0xF2},
  2248                  {"IRAM", NULL, NULL, 0xF3},
  2249          };
  2250  
  2251          if (!adapter) {
                     ^^^^^^^
Check.

  2252                  dev_err(adapter->dev, "Could not dump firmwware info\n");
                                ^^^^^^^^^^^^
Dereference.

  2253                  return;
  2254          }

The main question is why are we writing to /var and /tmp anyway instead
of putting this in debugfs or sysfs?

regards,
dan carpenter

