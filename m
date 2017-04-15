Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:62254 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdDOHv7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Apr 2017 03:51:59 -0400
To: linux-wireless@vger.kernel.org,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Christophe Ricard <christophe.ricard@gmail.com>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Robert Dolca <robert.dolca@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: NFC-FDP: Completion of error handling around
 fdp_nci_i2c_read_device_properties()
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <235c865e-b66f-9fb7-2f8e-93c62cacb988@users.sourceforge.net> (sfid-20170415_095307_037322_FE2F7BF4)
Date: Sat, 15 Apr 2017 09:51:38 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have noticed that the function “fdp_nci_i2c_read_device_properties” does not
contain a null pointer check after a call of the function “devm_kmalloc”.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/nfc/fdp/i2c.c?h=v4.10#n234

How do you think about to add a corresponding check and adjust the function
return type there?

Regards,
Markus
