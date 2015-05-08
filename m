Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106AbbEHTXI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 15:23:08 -0400
Date: Fri, 8 May 2015 21:23:04 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: ming.lei@canonical.com, gregkh@linuxfoundation.org
Cc: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, keescook@chromium.org,
	casey@schaufler-ca.com, tiwai@suse.de, mjg59@srcf.ucam.org,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	jlee@suse.com,
	"linux-kernel@vger.kernel.org Luis R. Rodriguez"
	<mcgrof@do-not-panic.com>
Subject: Re: [PATCH v1 04/12] firmware: fix possible use after free on name
 on asynchronous request
Message-ID: <20150508192304.GD20018@wotan.suse.de> (sfid-20150508_212313_178233_C6259469)
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
 <1430873070-7290-5-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1430873070-7290-5-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 05, 2015 at 05:44:22PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> Asynchronous firmware loading copies the pointer to the
> name passed as an argument only to be scheduled later and
> used. This behaviour works well for synchronous calling
> but in asynchronous mode there's a chance the caller could
> immediately free the passed string after making the
> asynchronous call. This could trigger a use after free
> having the kernel look on disk for arbitrary file names.

<-- snip -->

> Unfortunatley in the worst and most common case however you
> can typically crash your system with a page fault by trying to
> free something which you cannot, and/or a NULL pointer
> dereference [1].

I've found a few more bugs in this code that should be
stable fixes. Since the fixes are all related there is
an alternative approach to the problem here which would
require us to just deal with PATH_MAX a few times in code
for firmware requests. Although that does increase the
allocation required by a few KB I think the simplicity
is worth it. So if this patch has not yet been applied
I will send out a new series of fixes addressing name
issues through an alternative approach and implementation
preferences so please yield applying this yet, if it has
already been applied / submitted upstream let me know.

  Luis
