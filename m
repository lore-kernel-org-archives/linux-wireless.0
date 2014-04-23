Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43375 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751017AbaDWViS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2014 17:38:18 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id s3NLcHgs030242
	for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2014 14:38:17 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1kemxer3xy-7
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2014 14:38:17 -0700
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Amitkumar Karwar <akarwar@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 23 Apr 2014 14:37:09 -0700
Subject: RE: mwifiex: add firmware dump feature for PCIe
Message-ID: <477F20668A386D41ADCC57781B1F70430F70A2A9EA@SC-VEXCH1.marvell.com> (sfid-20140423_233827_187267_10C6DF1D)
References: <20140423143029.GA28228@mwanda>
In-Reply-To: <20140423143029.GA28228@mwanda>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> Hello Amitkumar Karwar,
> 
> The patch e050c76fcf49: "mwifiex: add firmware dump feature for PCIe"
> from Apr 17, 2014, leads to the following static checker warning:
> 
> 	drivers/net/wireless/mwifiex/pcie.c:2252 mwifiex_pcie_fw_dump_work()
> 	error: we previously assumed 'adapter' could be null (see line 2251)

Thanks for reporting this error.

> 
> drivers/net/wireless/mwifiex/pcie.c
>   2228  /* This function dump firmware memory to file */
>   2229  static void mwifiex_pcie_fw_dump_work(struct work_struct *work)
>   2230  {
>   2231          struct mwifiex_adapter *adapter =
>   2232                          container_of(work, struct mwifiex_adapter, iface_work);
>   2233          unsigned int reg, reg_start, reg_end;
>   2234          u8 *dbg_ptr;
>   2235          struct timeval t;
>   2236          u8 dump_num = 0, idx, i, read_reg, doneflag = 0;
>   2237          enum rdwr_status stat;
>   2238          u32 memory_size;
>   2239          u8 filename[MAX_FULL_NAME_LEN];
>   2240          mm_segment_t fs;
>   2241          loff_t pos;
>   2242          u8 *end_ptr;
>   2243          u8 *name_prefix = "/var/log/fw_dump_";
>   2244          struct memory_type_mapping mem_type_mapping_tbl[] = {
>   2245                  {"ITCM", NULL, NULL, 0xF0},
>   2246                  {"DTCM", NULL, NULL, 0xF1},
>   2247                  {"SQRAM", NULL, NULL, 0xF2},
>   2248                  {"IRAM", NULL, NULL, 0xF3},
>   2249          };
>   2250
>   2251          if (!adapter) {
>                      ^^^^^^^
> Check.
> 
>   2252                  dev_err(adapter->dev, "Could not dump firmwware info\n");
>                                 ^^^^^^^^^^^^
> Dereference.

You are right, adapter is NULL here. I will send a patch to fix it.

> 
>   2253                  return;
>   2254          }
> 
> The main question is why are we writing to /var and /tmp anyway instead
> of putting this in debugfs or sysfs?

AFAIK, the debugfs or sysfs cannot store/hold the files we retrieve from firmware at the scene. We write fw_dump files to rootfs so that the files are stored even if the system reboots due to hung_task timeout. 

Thanks,
Bing
