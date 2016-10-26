Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sym2.noone.org ([178.63.92.236]:57176 "EHLO sym2.noone.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752363AbcJZJOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 05:14:31 -0400
Date: Wed, 26 Oct 2016 11:03:47 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Cuissard <cuissard@marvell.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] NFC: nfcmrvl: Include unaligned.h instead of access_ok.h
Message-ID: <20161026090347.GA27488@distanz.ch> (sfid-20161026_111434_902933_35AE642B)
References: <20161026090012.29747-1-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026090012.29747-1-tklauser@distanz.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-10-26 at 11:00:12 +0200, Tobias Klauser <tklauser@distanz.ch> wrote:
> Including linux/unaligned/access_ok.h causes the allmodconfig build on
> ia64 (and maybe others) to fail with the following warnings:
> 
> include/linux/unaligned/access_ok.h:7:19: error: redefinition of 'get_unaligned_le16'
> include/linux/unaligned/access_ok.h:12:19: error: redefinition of 'get_unaligned_le32'
> include/linux/unaligned/access_ok.h:17:19: error: redefinition of 'get_unaligned_le64'
> include/linux/unaligned/access_ok.h:22:19: error: redefinition of 'get_unaligned_be16'
> include/linux/unaligned/access_ok.h:27:19: error: redefinition of 'get_unaligned_be32'
> include/linux/unaligned/access_ok.h:32:19: error: redefinition of 'get_unaligned_be64'
> include/linux/unaligned/access_ok.h:37:20: error: redefinition of 'put_unaligned_le16'
> include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_le32'
> include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_le64'
> include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_be16'
> include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_be32'
> include/linux/unaligned/access_ok.h:42:20: error: redefinition of 'put_unaligned_be64'
> 
> Fix these by including asm/unaligned.h instead and leave it up to the
> architecture to decide how to implement unaligned accesses.
> 
> Fixes: 3194c6870158 ("NFC: nfcmrvl: add firmware download support")
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Link: https://lkml.org/lkml/2016/10/22/247
> Cc: Vincent Cuissard <cuissard@marvell.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

There are two other instances of the same issue in the NFC subsystem,
namely in drivers/nfc/nxp-nci/firmware.c and drivers/nfc/nxp-nci/i2c.c

Guenter Roeck already sent a patch for these on 2015-08-01. It would be
nice if it could be applied as well.

[1] https://patchwork.kernel.org/patch/6922341/

Thanks
