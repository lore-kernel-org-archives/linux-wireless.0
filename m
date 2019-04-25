Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30351C282E1
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 06:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F28FD217D7
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 06:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556173889;
	bh=wHRXN5XEZCV0yKXXFctP1aLZqAPPzegTUGTtpGvu3IU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2BOosrIxOyKi70OXpWIr8drZkPqinmtReEsEEGxVxXnk/5YOqK2D8J7s4WA/h/Dfw
	 1LGMcfke5bar6v1nSkGlluY6gmtRF/QBaDduqNd78/O18BpLMV1FEcY2BkYoDZk7h4
	 DXFQeE4RQyIJ/Enarj1rRH/98ObUAzqsm18DlChs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729606AbfDYGbW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 02:31:22 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40703 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfDYGbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 02:31:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so28575911wre.7;
        Wed, 24 Apr 2019 23:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nkV8EKpA5YNJLAoU8Dqidj432hCPaA90eLlXB6QVb1E=;
        b=KgJ3uI1n9SBz4stP5z6Js3knEMvrOfq6LYbMgolbQ1HeC3Bp+76DRsuh5KgU7DaFKG
         Etu2mAeu/OLBFYK64QbXt+rXWx1aKBPRMU1VDOwI/1BG+sPEfHxXdB5Hik9UZKUEDMsM
         L+xowW1PMCIYvz3W4SR15XjKABFeDcGjmorCwpLd10IK5X3VO6M3Jo03FzEX7KPB7dhT
         AbCCbva+Sp9+Pf8zbzlQjJXwUdtgpBoxgn26VQvIzmLulVhnJso/l8LMOMYBTD7nyDwC
         tr8NJsLZ2v2rEn43NH6HjlmWGsY9iqY6tSohupEsK6QKtRp6u65JY9ue23p9ZCIuYxzY
         JkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nkV8EKpA5YNJLAoU8Dqidj432hCPaA90eLlXB6QVb1E=;
        b=apVeHQyLd1xBge5nm8y6TYsjvs8/QBBVgf+L1t4ybQHyRTwn9tVpz4xT68YSO6Eyd2
         zTDnHabE65hIdqJDq9SygrdVzB/d7C8TD4NsD8q4qFX67t42ikT3LU15ZTPlYKJKjg0F
         MBmXIfTqKUEnus8TbfUjH01e2tld45Vf/qMLN6ije6QiL49oCT1l8YPIyt6vnfvrfO7h
         S00kTcuAeCTcK5Qq3lXnjSbZaDe+R9hppNft3In9IMHI+AyPblqhMqXyptOprWCa+Mc6
         vb/gUrkFVN9GbsXAJ1B4W5MNwX+HXCNtJuTeF9hftyKi1UhTwWUV87PrN4BqpH/+7Z8F
         rSAA==
X-Gm-Message-State: APjAAAWN2OGFYP85WXH+SRBUmySrH1uDVjfzxRY8OwI/HFD+Iwer0S1H
        lRs01w7N/o+gxqtbcWpXBjU=
X-Google-Smtp-Source: APXvYqw0ahPLji+D1kmmCplVReoZg3Pv/dg7a9eF+tYrBEeQmujFjwicRtO3g/lE7Kj7dwxppvg36A==
X-Received: by 2002:adf:b60a:: with SMTP id f10mr23463310wre.116.1556173878697;
        Wed, 24 Apr 2019 23:31:18 -0700 (PDT)
Received: from gmail.com (2E8B0CD5.catv.pool.telekom.hu. [46.139.12.213])
        by smtp.gmail.com with ESMTPSA id s9sm4181953wrm.22.2019.04.24.23.31.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Apr 2019 23:31:17 -0700 (PDT)
Date:   Thu, 25 Apr 2019 08:31:15 +0200
From:   Ingo Molnar <mingo@kernel.org>
To:     Fenghua Yu <fenghua.yu@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 15/15] x86/split_lock: Add a sysfs interface to
 enable/disable split lock detection during run time
Message-ID: <20190425063115.GD40105@gmail.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-16-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1556134382-58814-16-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> To workaround or debug a split lock issue, the administrator may need to
> disable or enable split lock detection during run time without rebooting
> the system.
> 
> The interface /sys/device/system/cpu/split_lock_detect is added to allow
> the administrator to disable or enable split lock detection and show
> current split lock detection setting.
> 
> Writing [yY1] or [oO][nN] to the file enables split lock detection and
> writing [nN0] or [oO][fF] disables split lock detection. Split lock
> detection is enabled or disabled on all CPUs.
> 
> Reading the file returns current global split lock detection setting:
> 0: disabled
> 1: enabled
> 
> Add an ABI document entry for /sys/devices/system/cpu/split_lock_detect.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
> Not sure if the justification for the sysfs knob is valid. If not, this
> patch could be removed from this patch set.
> 
>  .../ABI/testing/sysfs-devices-system-cpu      | 22 ++++++++
>  arch/x86/kernel/cpu/intel.c                   | 52 ++++++++++++++++++-
>  2 files changed, 72 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
> index 9605dbd4b5b5..aad7b1698065 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -67,6 +67,28 @@ Description:	Discover NUMA node a CPU belongs to
>  		/sys/devices/system/cpu/cpu42/node2 -> ../../node/node2
>  
>  
> +What:		/sys/devices/system/cpu/split_lock_detect
> +Date:		March 2019
> +Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
> +Description:	(RW) Control split lock detection on Intel Tremont and
> +		future CPUs
> +
> +		Reads return split lock detection status:
> +			0: disabled
> +			1: enabled
> +
> +		Writes enable or disable split lock detection:
> +			The first character is one of 'Nn0' or [oO][fF] for off
> +			disables the feature.
> +			The first character is one of 'Yy1' or [oO][nN] for on
> +			enables the feature.
> +
> +		Please note the interface only shows or controls global setting.
> +		During run time, split lock detection on one CPU may be
> +		disabled if split lock operation in kernel code happens on
> +		the CPU. The interface doesn't show or control split lock
> +		detection on individual CPU.

I.e. implementation and possible actual state are out of sync. Why?

Also, if it's a global flag, why waste memory on putting a sysfs knob 
into every CPU's sysfs file?

Finally, why is a debugging facility in sysfs, why not a debugfs knob? 
Using a sysctl would solve the percpu vs. global confusion as well ...

> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -35,6 +35,7 @@
>  DEFINE_PER_CPU(u64, msr_test_ctl_cache);
>  EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
>  
> +static DEFINE_MUTEX(split_lock_detect_mutex);
>  static bool split_lock_detect_enable;

'enable' is a verb in plain form - which we use for function names.

For variable names that denotes current state we typically use past 
tense, i.e. 'enabled'.

(The only case where we'd us the split_lock_detect_enable name for a flag 
if it's a flag to trigger some sort of enabling action - which this 
isn't.)

Please review the whole series for various naming mishaps.

> +	mutex_lock(&split_lock_detect_mutex);
> +
> +	split_lock_detect_enable = val;
> +
> +	/* Update the split lock detection setting in MSR on all online CPUs. */
> +	on_each_cpu(split_lock_update_msr, NULL, 1);
> +
> +	if (split_lock_detect_enable)
> +		pr_info("enabled\n");
> +	else
> +		pr_info("disabled\n");
> +
> +	mutex_unlock(&split_lock_detect_mutex);

Instead of a mutex, please just use the global atomic debug flag which 
controls the warning printout. By using that flag both for the WARN()ing 
and for controlling MSR state all the races are solved and the code is 
simplified.


Thanks,

	Ingo
