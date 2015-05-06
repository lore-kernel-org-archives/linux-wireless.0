Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbbEFQ6I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 12:58:08 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1430873070-7290-6-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-6-git-send-email-mcgrof@do-not-panic.com> <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [RFC v1 05/12] firmware: add firmware signature checking support
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 06 May 2015 17:57:59 +0100
Message-ID: <17829.1430931479@warthog.procyon.org.uk> (sfid-20150506_185831_578501_66F3E3F9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> As with module signing, we do a very simple search for a
> particular string appended to the firmware. There's both a
> config option and a boot parameter which control whether we
> accept or fail with unsigned firmware and firmware that are
> signed with an unknown key.
> 
> If firmware signing is enabled, the kernel will be tainted
> if a firmware is loaded that is unsigned or has a signature
> for which we don't have the key.

I think you need to be careful storing the firmware blobs on disk with
signatures attached for two reasons:

 (1) There may be licensing/copyright issues on these blobs if you alter them.

 (2) Someone might try loading the modified blob without the signature being
     stripped - say someone runs an old kernel or copies the blob to a
     non-Linux system and tries to load it there.

Adding the signature to the blob upon loading might be less problematic, but
it still potentially suffers from (2) above.

If you switch to PKCS#7, you can also embed the blob inside the PKCS#7
message, so essentially the blob is unmodified and can be verified or
extracted by any suitable PKCS#7 tool.  This is more likely to get the
firmware rejected if the kernel isn't expecting it to be signed, I think.

I'm not sure how userspace actually passes the firmware blob to the kernel,
but I do think that if you can, you should pass the signature separately to
the blob.

With kernel modules this doesn't matter since modules are typically tied to a
single kernel version anyway.

David
