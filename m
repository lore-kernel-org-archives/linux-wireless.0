Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BA4C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 23:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 399CD2183F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 23:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387638AbfDQXF3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 19:05:29 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:59747 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729079AbfDQXF3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 19:05:29 -0400
Received: from pd9ef12d2.dip0.t-ipconnect.de ([217.239.18.210] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hGtc5-00085l-Rr; Thu, 18 Apr 2019 01:05:10 +0200
Date:   Thu, 18 Apr 2019 01:05:08 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Fenghua Yu <fenghua.yu@intel.com>
cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
Subject: Re: [PATCH v7 17/21] x86/clearcpuid: Support multiple clearcpuid
 options
In-Reply-To: <1555536851-17462-18-git-send-email-fenghua.yu@intel.com>
Message-ID: <alpine.DEB.2.21.1904180055160.3174@nanos.tec.linutronix.de>
References: <1555536851-17462-1-git-send-email-fenghua.yu@intel.com> <1555536851-17462-18-git-send-email-fenghua.yu@intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 17 Apr 2019, Fenghua Yu wrote:
>  int cmdline_find_option_bool(const char *cmdline_ptr, const char *option);
>  int cmdline_find_option(const char *cmdline_ptr, const char *option,
>  			char *buffer, int bufsize);
> +int cmdline_find_option_in_range(const char *cmdline_ptr, int cmdline_size,
> +				 const char *option, char *buffer, int bufsize,
> +				 char **arg_pos);
>  
>  #endif /* _ASM_X86_CMDLINE_H */
> diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
> index 6abd83572b01..88bbba7ee96a 100644
> --- a/arch/x86/kernel/fpu/init.c
> +++ b/arch/x86/kernel/fpu/init.c
> @@ -243,16 +243,31 @@ static void __init fpu__init_system_ctx_switch(void)
>  	WARN_ON_FPU(current->thread.fpu.initialized);
>  }
>  
> +static void __init clear_cpuid(void)
> +{
> +	char arg[32], *argptr, *option_pos, clearcpuid_option[] = "clearcpuid";
> +	int bit, cmdline_size;
> +
> +	/* Find each option in boot_command_line and clear specified cpu cap. */
> +	cmdline_size = COMMAND_LINE_SIZE;
> +	while (cmdline_find_option_in_range(boot_command_line, cmdline_size,
> +					    clearcpuid_option, arg,
> +					    sizeof(arg), &option_pos) >= 0) {
> +		/* Chang command line range for next search. */

Chang?

> +		cmdline_size = option_pos - boot_command_line + 1;
> +		argptr = arg;
> +		if (get_option(&argptr, &bit) &&
> +		    bit >= 0 && bit < NCAPINTS * 32)
> +			setup_clear_cpu_cap(bit);
> +	}
> +}
> +
>  /*
>   * We parse fpu parameters early because fpu__init_system() is executed
>   * before parse_early_param().
>   */
>  static void __init fpu__init_parse_early_param(void)
>  {
> -	char arg[32];
> -	char *argptr = arg;
> -	int bit;
> -
>  	if (cmdline_find_option_bool(boot_command_line, "no387"))
>  		setup_clear_cpu_cap(X86_FEATURE_FPU);
>  
> @@ -271,12 +286,7 @@ static void __init fpu__init_parse_early_param(void)
>  	if (cmdline_find_option_bool(boot_command_line, "noxsaves"))
>  		setup_clear_cpu_cap(X86_FEATURE_XSAVES);
>  
> -	if (cmdline_find_option(boot_command_line, "clearcpuid", arg,
> -				sizeof(arg)) &&
> -	    get_option(&argptr, &bit) &&
> -	    bit >= 0 &&
> -	    bit < NCAPINTS * 32)
> -		setup_clear_cpu_cap(bit);
> +	clear_cpuid();

I have no idea how that clearcpuid evaluation ended up in the FPU code, but
it does not belong here at all as it can turn off arbitrary cpuid bits.

Please move this out first into a more sensible place in kernel/cpu/

>  }
>  
>  /*
> diff --git a/arch/x86/lib/cmdline.c b/arch/x86/lib/cmdline.c
> index 3261abb21ef4..9cf1a0773877 100644
> --- a/arch/x86/lib/cmdline.c
> +++ b/arch/x86/lib/cmdline.c
> @@ -114,13 +114,15 @@ __cmdline_find_option_bool(const char *cmdline, int max_cmdline_size,
>   * @option: option string to look for
>   * @buffer: memory buffer to return the option argument
>   * @bufsize: size of the supplied memory buffer
> + * @option_pos: pointer to the option if found
>   *
>   * Returns the length of the argument (regardless of if it was
>   * truncated to fit in the buffer), or -1 on not found.
>   */
>  static int
>  __cmdline_find_option(const char *cmdline, int max_cmdline_size,
> -		      const char *option, char *buffer, int bufsize)
> +		      const char *option, char *buffer, int bufsize,
> +		      char **arg_pos)


Bah. For a silly per cpu variable you add a separate patch, but here you do
2 things in one go:

  1) Change the parser

  2) Change the call site.

No, you know exactly how this should be done.

>  {
>  	char c;
>  	int pos = 0, len = -1;
> @@ -164,6 +166,9 @@ __cmdline_find_option(const char *cmdline, int max_cmdline_size,
>  				len = 0;
>  				bufptr = buffer;
>  				state = st_bufcpy;
> +				if (arg_pos)
> +					*arg_pos = (char *)cmdline -
> +						   strlen(option) - 1;

https://marc.info/?l=linux-kernel&m=148467980905537&w=2

Thanks,

	tglx
