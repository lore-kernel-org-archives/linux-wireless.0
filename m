Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:27204 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751933AbdDAVvJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Apr 2017 17:51:09 -0400
Date: Sat, 1 Apr 2017 23:51:05 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Cuissard <cuissard@marvell.com>
Subject: Re: [PATCH] NFC: nfcmrvl: Include unaligned.h instead of access_ok.h
Message-ID: <20170401215045.GB22034@zurbaran.ger.intel.com> (sfid-20170401_235203_244821_E3DBAD2E)
References: <20161026090012.29747-1-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026090012.29747-1-tklauser@distanz.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tobias,

On Wed, Oct 26, 2016 at 11:00:12AM +0200, Tobias Klauser wrote:
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
> ---
>  drivers/nfc/nfcmrvl/fw_dnld.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied, with Guenter's patches as well.

Cheers,
Samuel.
