Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:47230 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751874AbdCXQLZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 12:11:25 -0400
Message-ID: <1490371609.21738.12.camel@linux.intel.com> (sfid-20170324_171840_363600_0D73AB28)
Subject: Re: [PATCH v2 5/5] NFC: pn544: Get rid of code duplication in
 ->probe()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Fri, 24 Mar 2017 18:06:49 +0200
In-Reply-To: <201703242337.3VFJCE9V%fengguang.wu@intel.com>
References: <201703242337.3VFJCE9V%fengguang.wu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-03-24 at 23:50 +0800, kbuild test robot wrote:
> Hi Andy,
> 
> [auto build test ERROR on linus/master]
> [also build test ERROR on v4.11-rc3 next-20170324]
> [if your patch is applied to the wrong git tree, please drop us a note
> to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Andy-Shevchenko/NFC-p
> n544-Get-rid-of-platform-data/20170324-232445
> config: i386-randconfig-x078-201712 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/nfc/pn544/i2c.c: In function 'pn544_hci_i2c_probe':
> > > drivers/nfc/pn544/i2c.c:910:3: error: implicit declaration of
> > > function 'nfc_dbg' [-Werror=implicit-function-declaration]
> 
>       nfc_dbg(dev, "Unable to add GPIO mapping table\n");
>       ^~~~~~~

Yes, there is a dependency patch. Since I have heard nothing from NFC
maintainers (subsystem seems abandoned) and taking into consideration
removal of such macro back in 2011 I'll probably replace nfc_* by dev_*
in the driver.

>    Cyclomatic Complexity 5 include/linux/compiler.h:__write_once_size
>    Cyclomatic Complexity 1 include/uapi/linux/swab.h:__swab16p
>    Cyclomatic Complexity 1 include/uapi/linux/swab.h:__swab32p
>    Cyclomatic Complexity 1
> include/uapi/linux/byteorder/little_endian.h:__be32_to_cpup
>    Cyclomatic Complexity 1
> include/uapi/linux/byteorder/little_endian.h:__be16_to_cpup
>    Cyclomatic Complexity 1 include/linux/list.h:INIT_LIST_HEAD
>    Cyclomatic Complexity 1 include/linux/err.h:PTR_ERR
>    Cyclomatic Complexity 1 include/linux/workqueue.h:__init_work
>    Cyclomatic Complexity 1 include/linux/device.h:dev_get_drvdata
>    Cyclomatic Complexity 1 include/linux/device.h:dev_set_drvdata
>    Cyclomatic Complexity 1 include/linux/i2c.h:i2c_get_clientdata
>    Cyclomatic Complexity 1 include/linux/i2c.h:i2c_set_clientdata
>    Cyclomatic Complexity 1 include/linux/i2c.h:i2c_get_functionality
>    Cyclomatic Complexity 1 include/linux/i2c.h:i2c_check_functionality
>    Cyclomatic Complexity 2
> include/linux/acpi.h:acpi_dev_remove_driver_gpios
>    Cyclomatic Complexity 1
> include/linux/unaligned/access_ok.h:get_unaligned_be16
>    Cyclomatic Complexity 1
> include/linux/unaligned/access_ok.h:get_unaligned_be32
>    Cyclomatic Complexity 1
> include/linux/unaligned/access_ok.h:put_unaligned_be16
>    Cyclomatic Complexity 3 include/linux/err.h:IS_ERR_OR_NULL
>    Cyclomatic Complexity 3 include/acpi/acpi_bus.h:is_acpi_device_node
>    Cyclomatic Complexity 2 include/acpi/acpi_bus.h:to_acpi_device_node
>    Cyclomatic Complexity 1 include/linux/err.h:IS_ERR
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_disable
>    Cyclomatic Complexity 2
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_work_complete
>    Cyclomatic Complexity 4
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_remove
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_enable_mode
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_enable
>    Cyclomatic Complexity 1 include/linux/workqueue.h:queue_work
>    Cyclomatic Complexity 1 include/linux/workqueue.h:schedule_work
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_download
>    Cyclomatic Complexity 3 drivers/nfc/pn544/i2c.c:check_crc
>    Cyclomatic Complexity 3
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_check_cmd
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_add_len_crc
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_remove_len_crc
>    Cyclomatic Complexity 6 drivers/nfc/pn544/i2c.c:pn544_hci_i2c_write
>    Cyclomatic Complexity 16
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_read_status
>    Cyclomatic Complexity 1 include/linux/skbuff.h:alloc_skb
>    Cyclomatic Complexity 8 drivers/nfc/pn544/i2c.c:pn544_hci_i2c_read
>    Cyclomatic Complexity 11
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_irq_thread_fn
>    Cyclomatic Complexity 4
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_write_cmd
>    Cyclomatic Complexity 2
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_write_chunk
>    Cyclomatic Complexity 4
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_secure_write_frame_cmd
>    Cyclomatic Complexity 9
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_secure_write_frame
>    Cyclomatic Complexity 23
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_fw_work
>    Cyclomatic Complexity 1 include/linux/device.h:devm_kzalloc
>    Cyclomatic Complexity 6
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_platform_init
>    Cyclomatic Complexity 10
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_probe
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_driver_init
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:pn544_hci_i2c_driver_exit
>    Cyclomatic Complexity 1
> drivers/nfc/pn544/i2c.c:_GLOBAL__sub_I_65535_0_i2c.c
>    cc1: some warnings being treated as errors
> 
> vim +/nfc_dbg +910 drivers/nfc/pn544/i2c.c
> 
>    904	
>    905		phy->i2c_dev = client;
>    906		i2c_set_clientdata(client, phy);
>    907	
>    908		r =
> acpi_dev_add_driver_gpios(ACPI_COMPANION(dev), acpi_pn544_gpios);
>    909		if (r)
>  > 910			nfc_dbg(dev, "Unable to add GPIO mapping
> table\n");
>    911	
>    912		/* Get EN GPIO */
>    913		phy->gpiod_en = devm_gpiod_get(dev, "enable",
> GPIOD_OUT_LOW);
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
> Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
> Corporation

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
