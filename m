Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030329AbbDWRAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2015 13:00:21 -0400
Date: Thu, 23 Apr 2015 19:00:18 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	rusty@rustcorp.com.au, akpm@linux-foundation.org, mingo@kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	keescook@chromium.org, casey@schaufler-ca.com,
	cocci@systeme.lip6.fr, Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH v2 3/8] kernel/params.c: generalize bool_enable_only
Message-ID: <20150423170018.GN5622@wotan.suse.de> (sfid-20150423_190027_398011_7F6DFFBF)
References: <1429739711-9415-1-git-send-email-mcgrof@do-not-panic.com>
 <1429739711-9415-4-git-send-email-mcgrof@do-not-panic.com>
 <20150423152249.GK10738@htj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150423152249.GK10738@htj.duckdns.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 23, 2015 at 11:22:49AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Apr 22, 2015 at 02:55:06PM -0700, Luis R. Rodriguez wrote:
> > +int param_set_bool_enable_only(const char *val, const struct kernel_param *kp)
> > +{
> > +	int err = 0;
> > +	bool new_value;
> > +	bool orig_value = *(bool *)kp->arg;
> > +	struct kernel_param dummy_kp = *kp;
> > +
> > +	dummy_kp.arg = &new_value;
> > +
> > +	err = param_set_bool(val, &dummy_kp);
> > +	if (err)
> > +		return err;
> > +
> > +	/* Don't let them unset it once it's set! */
> > +	if (!new_value && orig_value)
> > +		return -EROFS;
> 
> I know that this was moved from another place but as we're making it
> generic now I'm a bit curious about -EROFS.  Wouldn't -EINVAL be a
> more conventional choice here?

Let's see, I tested to see what errors we get:

Userspace:

-EROFS:

mcgrof@ergon ~/devel/test-sig-force-general $ sudo insmod ./hello.ko test_sig_enforce=1
insmod: ERROR: could not insert module ./hello.ko: Read-only file system

-EINVAL:

mcgrof@ergon ~/devel/test-sig-force-general $ sudo insmod ./hello.ko test_sig_enforce=1
insmod: ERROR: could not insert module ./hello.ko: Invalid parameters

Kernel space:

Both of these returns yield this on the kernel ring buffer:

mcgrof@ergon ~/devel/test-sig-force-general $ sudo dmesg -c
[124677.202875] hello: `1' invalid for parameter `test_sig_enforce'

Alternative candidates:

#define EBADRQC         56      /* Invalid request code */ 
#define EOPNOTSUPP      95      /* Operation not supported on transport endpoint */

Perhaps EOPNOTSUPP is best?

  Luis
