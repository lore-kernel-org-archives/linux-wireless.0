Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139C5C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 14:47:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAC9120850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 14:47:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfDLOrZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 10:47:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:32143 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbfDLOrY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 10:47:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Apr 2019 07:47:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,341,1549958400"; 
   d="scan'208";a="315411043"
Received: from hederi-mobl1.ger.corp.intel.com (HELO [10.252.15.159]) ([10.252.15.159])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2019 07:47:16 -0700
Subject: Re: [Intel-gfx] [PATCH 3/4] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
To:     Alastair D'Silva <alastair@au1.ibm.com>, alastair@d-silva.org
Cc:     linux-fbdev@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, Jassi Brar <jassisinghbrar@gmail.com>,
        ath10k@lists.infradead.org, intel-gfx@lists.freedesktop.org,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-fsdevel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karsten Keil <isdn@linux-pingi.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        netdev@vger.kernel.org,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <20190410031720.11067-1-alastair@au1.ibm.com>
 <20190410031720.11067-4-alastair@au1.ibm.com>
From:   Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Organization: Intel Corporation UK Plc
Message-ID: <929244ed-cc7f-b0f3-b5ac-50e798e83188@linux.intel.com>
Date:   Fri, 12 Apr 2019 15:47:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190410031720.11067-4-alastair@au1.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 10/04/2019 04:17, Alastair D'Silva wrote:
> From: Alastair D'Silva <alastair@d-silva.org>
> 
> In order to support additional features in hex_dump_to_buffer, replace
> the ascii bool parameter with flags.
> 
> Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
> ---
>   drivers/gpu/drm/i915/intel_engine_cs.c            |  2 +-
>   drivers/isdn/hardware/mISDN/mISDNisar.c           |  6 ++++--
>   drivers/mailbox/mailbox-test.c                    |  2 +-
>   drivers/net/ethernet/amd/xgbe/xgbe-drv.c          |  2 +-
>   drivers/net/ethernet/synopsys/dwc-xlgmac-common.c |  2 +-
>   drivers/net/wireless/ath/ath10k/debug.c           |  3 ++-
>   drivers/net/wireless/intel/iwlegacy/3945-mac.c    |  2 +-
>   drivers/platform/chrome/wilco_ec/debugfs.c        |  3 ++-
>   drivers/scsi/scsi_logging.c                       |  8 +++-----
>   drivers/staging/fbtft/fbtft-core.c                |  2 +-
>   fs/seq_file.c                                     |  3 ++-
>   include/linux/printk.h                            |  2 +-
>   lib/hexdump.c                                     | 15 ++++++++-------
>   lib/test_hexdump.c                                |  5 +++--
>   14 files changed, 31 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_engine_cs.c b/drivers/gpu/drm/i915/intel_engine_cs.c
> index 49fa43ff02ba..fb133e729f9a 100644
> --- a/drivers/gpu/drm/i915/intel_engine_cs.c
> +++ b/drivers/gpu/drm/i915/intel_engine_cs.c
> @@ -1318,7 +1318,7 @@ static void hexdump(struct drm_printer *m, const void *buf, size_t len)
>   		WARN_ON_ONCE(hex_dump_to_buffer(buf + pos, len - pos,
>   						rowsize, sizeof(u32),
>   						line, sizeof(line),
> -						false) >= sizeof(line));
> +						0) >= sizeof(line));
>   		drm_printf(m, "[%04zx] %s\n", pos, line);
>   
>   		prev = buf + pos;

i915 code here actually does something I think is more interesting than
HEXDUMP_SUPPRESS_0X**. It replaces any N repeating lines with a single star
marker. For example:

    00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    *
    00000040 00000001 00000000 00000018 00000002 00000001 00000000 00000018 00000000
    00000060 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000003
    00000080 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    *
    000000c0 00000002 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    000000e0 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
    *

If or when you end up with this feature in your series you can therefore
replace the whole implementation of hexdump in the above file.

Regards,

Tvrtko
