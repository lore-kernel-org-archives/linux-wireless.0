Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33407 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbcCLArJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2016 19:47:09 -0500
Received: by mail-qg0-f41.google.com with SMTP id t4so112544006qge.0
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2016 16:47:08 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Mar 2016 17:47:08 -0700
Message-ID: <CAAA5faFc9+cBzpXe8Uo89fUmzXgBmLRK5XLh0pFUvRHJD+6PHQ@mail.gmail.com> (sfid-20160312_014713_669691_37EA2A57)
Subject: splx->package.count
From: Reinoud Koornstra <reinoudkoornstra@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Everybody,

The message Unsupported splx structure annoyed me so I started looking.
My instrumentation shows this:

Mar 11 00:24:32  kernel: [    7.263415] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
splx->type is 0x04
Mar 11 00:24:32  kernel: [    7.263416] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
splx->package.count is 4
Mar 11 00:24:32  kernel: [    7.263417] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
splx->package.elements[0].type is 0x01
Mar 11 00:24:32  kernel: [    7.263418] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
splx->package.elements[0].integer.value is 0

Ok, so:

splx->type is ACPI_TYPE_PACKAGE
splx->package.count is 4
splx->package.elements[0].type is ACPI_TYPE_INTEGER
splx->package.elements[0].integer.value is 0

Looking at the code:

if (splx->type != ACPI_TYPE_PACKAGE ||
           splx->package.count != 2 ||
           splx->package.elements[0].type != ACPI_TYPE_INTEGER ||
           splx->package.elements[0].integer.value != 0)

Meaning, the package.count isn't 2, why does it need to be 2?
[
[    7.495340] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
limits->type is 0x04
[    7.495341] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
limits->package.count is 3
[    7.495342] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
limits->package.elements[0].type is 0x01
[    7.495342] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit:
limits->package.elements[1].type is 0x01
So limits->type is ACPI_TYPE_PACKAGE
limits->package.count is 3 (not ok) Why does this need to be < 2?
package.elements[0].type is ACPI_TYPE_INTEGER
limits->package.elements[1].type is ACPI_TYPE_INTEGER

[    7.495343] iwlwifi 0000:04:00.0:
drivers/net/wireless/iwlwifi/pcie/drv.c, splx_get_pwr_limit: WiFi
power is not limited, domain_type->integer.value is 0

Ok, so the last check also doesn't pass.
In any case, this isn't something I'm worried about, I'm just
wondering why the counts are so specific.
Thanks,

Reinoud.
