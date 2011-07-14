Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4003 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab1GNHd6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 03:33:58 -0400
Subject: Re: [PATCH 01/24] ath6kl: add bmi.c
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	gregkh@suse.de
In-Reply-To: <4E1E90AB.6030707@qca.qualcomm.com>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
	 <20110713013300.8517.98566.stgit@localhost6.localdomain6>
	 <1310531333.1143.25.camel@Joe-Laptop>  <4E1D4479.8090201@qca.qualcomm.com>
	 <1310559554.1662.6.camel@Joe-Laptop>  <4E1E90AB.6030707@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jul 2011 00:33:57 -0700
Message-ID: <1310628837.7582.12.camel@Joe-Laptop> (sfid-20110714_093401_974214_2EEFD017)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-07-14 at 09:46 +0300, Kalle Valo wrote:
> On 07/13/2011 03:19 PM, Joe Perches wrote:
> > Add this patch to checkpatch?
> > I'll submit it to Andrew Morton later.
> Awesome! I had no idea checkpatch supports this. Just tested this with
> ath6kl and I don't get long line warnings with long log messages.

Note that this doesn't let you have arbitrarily
long lines just because it's a printk or any other
logging function.  Only the format portion of the
printk may exceed 80 columns.

Any additional arguments for the printk must not
start after or exceed 80 columns.

For instance below, the first ath6kl_info is fine,
the second one is not.

$ cat t.c
static int dump_obj(void)
{
	ath6kl_info("%s: 12345678901234567890123456789012345678901234567890123456789012345678901234567890\n",
		    "some long string");
	ath6kl_info("%s: 12345678901234567890123456789012345678901234567890123456789012345678901234567890\n", "some long string");
}

$ ./scripts/checkpatch.pl -f t.c
WARNING: line over 80 characters
#5: FILE: t.c:5:
+	ath6kl_info("%s: 12345678901234567890123456789012345678901234567890123456789012345678901234567890", "some long string");

total: 0 errors, 1 warnings, 6 lines checked

t.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.


