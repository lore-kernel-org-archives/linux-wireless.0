Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A5D7C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:53:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8F112081B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:53:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HeoNvMAP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8F112081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbeJXQUF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 12:20:05 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:46452 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbeJXQUF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 12:20:05 -0400
Received: by mail-ot1-f67.google.com with SMTP id u26so2944948otk.13
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 00:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RuWqIevGpTfpMKINA//uj4Ybk9gnpJJK26RSdnlKPiY=;
        b=HeoNvMAPpP77ip/uJuNtn70TSZXt7GtbgeW9OI14krILn2v7hV9VZYmC/cpCJNTvyU
         SFOtWJt3/jEWqwStUet50u6DyNl/CXz3MKsQUo4bq6Y6e8lWmdDvcgKOEoG6eGfIuUH/
         4+xByjWUbndYkfALwboCYnntN1TbR0L+PE4oF3qcct0oevjoDFCmCVNO+H7EWc3RJKTp
         wiwVNnNddm8VzK4kSezSqsrNGVMnrhMCOPnn+548zACV1XFUuAfiVKYyghyBYV8FV06c
         kIvJZrqcpAMbdllEorHV8q7QdC6x5QfA8f+c4k5mPS4b6RekYF3kG6vlFJty825Tmk9A
         n6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RuWqIevGpTfpMKINA//uj4Ybk9gnpJJK26RSdnlKPiY=;
        b=n1cUsBrx64zwmE8euy5p3bPQlwdxx2+EteQiAZmcNEooXaKVF1GQwKTOIw33qmdHy5
         4C3F1S6FAJKyVcDlXIKDPoIN+jO/Ewr2x2mtQdRTzTyTjDxe9h+uSaVuatuwsi2MHG6K
         DzI4fPU0Rt5kWF89awPuOZ0xnP1USwKOH/M+7M+SrSBgY+pDazbqbvgqPMD+jddgzGgK
         HN4blVOZQzHMLAhKiTcMKB2q+DsbTuw0liTl77RJjMRV2fM9DnGz6BSG+0Gk6jMLlhwy
         tScWpDJKyON0BpCLE5txVqTvCsuLl9WKVPc2443iGHoQYbdBuLcR+jFZu6pDL5jAxYgQ
         JnKw==
X-Gm-Message-State: AGRZ1gLIPfwC8NKz8xqvRfCYFcM/TBnn2cNJuj/DHvpsY/jM8WqhsNq7
        dqnLET7UBaDIlkrW19rnKllyRT28fNZ065BcxTovAg==
X-Google-Smtp-Source: AJdET5cwp6PvlEPSoNRSP+XjIDZwInhkbJrC3UVT9dm6E7zIRqk1Uw4TVTxWM2/zIMQfT1+YYopkR+mjO/Nyw6gbMRM=
X-Received: by 2002:a9d:11ab:: with SMTP id v40mr966627otf.194.1540367585394;
 Wed, 24 Oct 2018 00:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20181024070436.4466-1-johannes@sipsolutions.net>
In-Reply-To: <20181024070436.4466-1-johannes@sipsolutions.net>
From:   Kirtika Ruchandani <kirtika@google.com>
Date:   Wed, 24 Oct 2018 00:52:53 -0700
Message-ID: <CAOXD1ie-AVOdS2KZK-emE8aQPgZEDessqYyMXi1RRwm90b+SDw@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: pcie: align licensing to dual GPL/BSD
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        "Berg, Johannes" <johannes.berg@intel.com>, joonwpark81@gmail.com,
        sgruszka@redhat.com, luto@amacapital.net,
        Rajat Jain <rajatja@google.com>,
        Kirtika Ruchandani <kirtika@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 12:05 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> These files have a long history of code changes, but analysing
> the remaining code leads to having only a few changes that are
> not already owned by Intel, notably from
>  - Andy Lutomirski <luto@amacapital.net>
>  - Joonwoo Park <joonwpark81@gmail.com>
>  - Kirtika Ruchandani <kirtika@chromium.org>
>  - Rajat Jain <rajatja@google.com>
>  - Stanislaw Gruszka <sgruszka@redhat.com>
> remaining in the code today.
>
> Note that
>  - I myself was working for Intel and for any possibly code
>    that might be before my employment there give permission
>  - Wizery employees were working for Intel
>
> More specifically, we identified the following commits that
> (partially may) remain today:
>
> 25c03d8e8c13 Joonwoo Park <joonwpark81@gmail.com>      ("iwlwifi: do not schedule tasklet when rcv unused irq")
> f36d04abe684 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: use dma_alloc_coherent")
> 387f3381f732 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: fix dma mappings and skbs leak")
> 2624e96ce16b Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: fix possible data overwrite in hcmd callback")
> bfe4b80e9f73 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: always check if got h/w access before write")
> d536c32b45d2 Andy Lutomirski <luto@amacapital.net>     ("iwlwifi: pcie: log when waking the NIC for hcmd submission fails")
> a6d24fad00d9 Rajat Jain <rajatja@google.com>           ("iwlwifi: pcie: dump registers when HW becomes inaccessible")
> fb12777ab59b Kirtika Ruchandani <kirtika@chromium.org> ("iwlwifi: Add more call-sites for pcie reg dumper")
> 3a73a30049f2 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: cleanup/fix memory barriers")
> aa5affbacb24 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: dump stack when fail to gain access to the device")
>
> Align the licenses with their permission to clean up and to
> make it all identical.
>
> CC: Joonwoo Park <joonwpark81@gmail.com>
> CC: Stanislaw Gruszka <sgruszka@redhat.com>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Rajat Jain <rajatja@google.com>
> CC: Kirtika Ruchandani <kirtika@chromium.org>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Kirtika Ruchandani <kirtika@chromium.org>

> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I'd appreciate if you (in CC lines) could provide your acked-by here.
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 41 +++++++++++++++--
>  drivers/net/wireless/intel/iwlwifi/iwl-io.h   | 38 ++++++++++++++--
>  .../wireless/intel/iwlwifi/pcie/internal.h    | 44 +++++++++++++++++--
>  drivers/net/wireless/intel/iwlwifi/pcie/rx.c  | 44 +++++++++++++++++--
>  drivers/net/wireless/intel/iwlwifi/pcie/tx.c  | 44 +++++++++++++++++--
>  5 files changed, 192 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
> index 4f10914f6048..ffd1e649bfa0 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
> @@ -1,10 +1,13 @@
>  /******************************************************************************
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
>   *
>   * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
>   * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
>   *
> - * Portions of this file are derived from the ipw3945 project.
> - *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of version 2 of the GNU General Public License as
>   * published by the Free Software Foundation.
> @@ -15,12 +18,44 @@
>   * more details.
>   *
>   * The full GNU General Public License is included in this distribution in the
> - * file called LICENSE.
> + * file called COPYING.
>   *
>   * Contact Information:
>   *  Intel Linux Wireless <linuxwifi@intel.com>
>   * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
>   *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
> + * Copyright(c) 2015 - 2016 Intel Deutschland GmbH
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + *  * Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + *  * Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *  * Neither the name Intel Corporation nor the names of its
> + *    contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
>   *****************************************************************************/
>  #include <linux/delay.h>
>  #include <linux/device.h>
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.h b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
> index 38085850a2d3..61477e58352d 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-io.h
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.h
> @@ -1,8 +1,9 @@
>  /******************************************************************************
>   *
> - * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
>   *
> - * Portions of this file are derived from the ipw3945 project.
> + * GPL LICENSE SUMMARY
>   *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of version 2 of the GNU General Public License as
> @@ -14,14 +15,43 @@
>   * more details.
>   *
>   * The full GNU General Public License is included in this distribution in the
> - * file called LICENSE.
> + * file called COPYING.
>   *
>   * Contact Information:
>   *  Intel Linux Wireless <linuxwifi@intel.com>
>   * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
>   *
> + * BSD LICENSE
> + *
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + *  * Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + *  * Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *  * Neither the name Intel Corporation nor the names of its
> + *    contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
>   *****************************************************************************/
> -
>  #ifndef __iwl_io_h__
>  #define __iwl_io_h__
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> index f9c4c64dee66..6821d09df8db 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
> @@ -1,13 +1,15 @@
>  /******************************************************************************
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
>   *
>   * Copyright(c) 2003 - 2015 Intel Corporation. All rights reserved.
>   * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
>   * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
>   * Copyright(c) 2018 Intel Corporation
>   *
> - * Portions of this file are derived from the ipw3945 project, as well
> - * as portions of the ieee80211 subsystem header files.
> - *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of version 2 of the GNU General Public License as
>   * published by the Free Software Foundation.
> @@ -18,12 +20,46 @@
>   * more details.
>   *
>   * The full GNU General Public License is included in this distribution in the
> - * file called LICENSE.
> + * file called COPYING.
>   *
>   * Contact Information:
>   *  Intel Linux Wireless <linuxwifi@intel.com>
>   * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
>   *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2003 - 2015 Intel Corporation. All rights reserved.
> + * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
> + * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
> + * Copyright(c) 2018 Intel Corporation
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + *  * Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + *  * Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *  * Neither the name Intel Corporation nor the names of its
> + *    contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
>   *****************************************************************************/
>  #ifndef __iwl_trans_int_pcie_h__
>  #define __iwl_trans_int_pcie_h__
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> index e965cc588850..f4ad89aeaa0a 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
> @@ -1,13 +1,15 @@
>  /******************************************************************************
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
>   *
>   * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
>   * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
>   * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
>   * Copyright(c) 2018 Intel Corporation
>   *
> - * Portions of this file are derived from the ipw3945 project, as well
> - * as portions of the ieee80211 subsystem header files.
> - *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of version 2 of the GNU General Public License as
>   * published by the Free Software Foundation.
> @@ -18,12 +20,46 @@
>   * more details.
>   *
>   * The full GNU General Public License is included in this distribution in the
> - * file called LICENSE.
> + * file called COPYING.
>   *
>   * Contact Information:
>   *  Intel Linux Wireless <linuxwifi@intel.com>
>   * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
>   *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
> + * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
> + * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
> + * Copyright(c) 2018 Intel Corporation
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + *  * Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + *  * Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *  * Neither the name Intel Corporation nor the names of its
> + *    contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
>   *****************************************************************************/
>  #include <linux/sched.h>
>  #include <linux/wait.h>
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
> index f227b91098c9..60487d11eaa8 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
> @@ -1,13 +1,15 @@
>  /******************************************************************************
> + *
> + * This file is provided under a dual BSD/GPLv2 license.  When using or
> + * redistributing this file, you may do so under either license.
> + *
> + * GPL LICENSE SUMMARY
>   *
>   * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
>   * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
>   * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
>   * Copyright(c) 2018 Intel Corporation
>   *
> - * Portions of this file are derived from the ipw3945 project, as well
> - * as portions of the ieee80211 subsystem header files.
> - *
>   * This program is free software; you can redistribute it and/or modify it
>   * under the terms of version 2 of the GNU General Public License as
>   * published by the Free Software Foundation.
> @@ -18,12 +20,46 @@
>   * more details.
>   *
>   * The full GNU General Public License is included in this distribution in the
> - * file called LICENSE.
> + * file called COPYING.
>   *
>   * Contact Information:
>   *  Intel Linux Wireless <linuxwifi@intel.com>
>   * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
>   *
> + * BSD LICENSE
> + *
> + * Copyright(c) 2003 - 2014 Intel Corporation. All rights reserved.
> + * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
> + * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
> + * Copyright(c) 2018 Intel Corporation
> + * All rights reserved.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + *  * Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + *  * Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *  * Neither the name Intel Corporation nor the names of its
> + *    contributors may be used to endorse or promote products derived
> + *    from this software without specific prior written permission.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> + * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> + * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> + * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> + * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> + * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> + * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> + * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> + * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> + * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
>   *****************************************************************************/
>  #include <linux/etherdevice.h>
>  #include <linux/ieee80211.h>
> --
> 2.17.2
>
