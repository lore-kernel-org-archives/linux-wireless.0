Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f48.google.com ([209.85.192.48]:36307 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbbDWPWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 11:22:53 -0400
Date: Thu, 23 Apr 2015 11:22:49 -0400
From: Tejun Heo <tj@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: rusty@rustcorp.com.au, akpm@linux-foundation.org, mingo@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, "Luis R. Rodriguez" <mcgrof@suse.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 3/8] kernel/params.c: generalize bool_enable_only
Message-ID: <20150423152249.GK10738@htj.duckdns.org> (sfid-20150423_172314_709475_80B31CCD)
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
 <1429739711-9415-4-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1429739711-9415-4-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wed, Apr 22, 2015 at 02:55:06PM -0700, Luis R. Rodriguez wrote:
> +int param_set_bool_enable_only(const char *val, const struct kernel_param *kp)
> +{
> +	int err = 0;
> +	bool new_value;
> +	bool orig_value = *(bool *)kp->arg;
> +	struct kernel_param dummy_kp = *kp;
> +
> +	dummy_kp.arg = &new_value;
> +
> +	err = param_set_bool(val, &dummy_kp);
> +	if (err)
> +		return err;
> +
> +	/* Don't let them unset it once it's set! */
> +	if (!new_value && orig_value)
> +		return -EROFS;

I know that this was moved from another place but as we're making it
generic now I'm a bit curious about -EROFS.  Wouldn't -EINVAL be a
more conventional choice here?

Thanks.

-- 
tejun
