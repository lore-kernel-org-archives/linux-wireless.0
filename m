Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F12C43219
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 17:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 918262067C
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 17:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o2lHurwP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GCytTo7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbfDYRMc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 13:12:32 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:40564 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfDYRMc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 13:12:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8D18A60736; Thu, 25 Apr 2019 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556212351;
        bh=HnJj9e88ADlqaqLylj8M+aGQ2ydlNkDvqQM4hhj3RnU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=o2lHurwPV05YZUbKtlsrN92iskNrZz5V/VUVo4cLDCFU9N2Yz9jcABTr5hZ7p2pyu
         o7gGYhheYmkjtIyB9wuFGp0OQhMfZ1QjDCp6H1yMAnp19LBZW8T2B1/8AHmcb/WjxM
         K8XhNIdqSwHKRhYaZ+UTgCSZ7lCFrt4Vo4aiO4mA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EE28B60779;
        Thu, 25 Apr 2019 17:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556212349;
        bh=HnJj9e88ADlqaqLylj8M+aGQ2ydlNkDvqQM4hhj3RnU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=GCytTo7zhzglTTJAKr5fommt0q1U9YfmSBLZfv/MAwfDufatBABfk3GYXlsBCOkwh
         AmEVJqaBNjymroa5OwvoMbAMebbhuB2cytaisEKT2W7cOMBGJmOQy61KtvDn5vHQia
         sfsSf69zEANnQQqWnROVnNtSCQ8C8Z8weCQLy+RU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EE28B60779
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v8 03/15] wlcore: simplify/fix/optimize
 reg_ch_conf_pending operations
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1556134382-58814-4-git-send-email-fenghua.yu@intel.com>
References: <1556134382-58814-4-git-send-email-fenghua.yu@intel.com>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Ashok Raj" <ashok.raj@intel.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ravi V Shankar" <ravi.v.shankar@intel.com>,
        "Xiaoyao Li " <xiaoyao.li@intel.com>,
        "Christopherson Sean J" <sean.j.christopherson@intel.com>,
        "Michael Chan" <michael.chan@broadcom.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "x86" <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190425171231.8D18A60736@smtp.codeaurora.org>
Date:   Thu, 25 Apr 2019 17:12:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Paolo Bonzini <pbonzini@redhat.com>
> 
> Bitmaps are defined on unsigned longs, so the usage of u32[2] in the
> wlcore driver is incorrect.  As noted by Peter Zijlstra, casting arrays
> to a bitmap is incorrect for big-endian architectures.
> 
> When looking at it I observed that:
> 
> - operations on reg_ch_conf_pending is always under the wl_lock mutex,
> so set_bit is overkill
> 
> - the only case where reg_ch_conf_pending is accessed a u32 at a time is
> unnecessary too.
> 
> This patch cleans up everything in this area, and changes tmp_ch_bitmap
> to have the proper alignment.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

147b502bda33 wlcore: simplify/fix/optimize reg_ch_conf_pending operations

-- 
https://patchwork.kernel.org/patch/10915635/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

