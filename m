Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49682 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbbEFMJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 08:09:48 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1430873070-7290-3-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-3-git-send-email-mcgrof@do-not-panic.com> <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: dhowells@redhat.com, rusty@rustcorp.com.au, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org,
	akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: Re: [PATCH v1 02/12] kernel: generalize module signing as system data signing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 06 May 2015 13:08:49 +0100
Message-ID: <14325.1430914129@warthog.procyon.org.uk> (sfid-20150506_141005_444556_A1C4F374)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:

> This generalizes the module signing code as helpers, we do
> this as we'll later re-use this same code for firmware and
> other system data signing.

I'm trying to move us to the use of PKCS#7 certificates as module signatures.
See here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7

I would suggest you use this as a base.

Also, I would suggest, if you can manage it, either:

 (1) Keep the signature and the firmware blobs separate on disk for copyright
     and/or licensing purposes.

 (2) Put the firmware blob inside the PKCS#7 message as the embedded data.

David
