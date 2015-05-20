Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f170.google.com ([209.85.214.170]:33578 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbbETOEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 10:04:46 -0400
Received: by obblk2 with SMTP id lk2so37432827obb.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 07:04:45 -0700 (PDT)
Date: Wed, 20 May 2015 09:04:26 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150520140426.GB126473@ubuntu-hedt> (sfid-20150520_160451_689420_2756D055)
References: <20150519200232.GM23057@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150519200232.GM23057@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 10:02:32PM +0200, Luis R. Rodriguez wrote:
> This begs the question on how we'd manage keys for firmware signing on
> linux-firmare. Since the keys are x509 keys we need a CA. Based on some initial
> discussions it would seem we'd need the Linux Foundation to create a key, this
> would be embedded in the kernel and that key would be used to sign Kyle's key.
> Kyle would in turn use his key for signing linux-firmware files. David, Kyle,
> did I summarize this correctly ?

I raised the question of key revocation when we discussed this on irc,
but it wasn't answered to my satisfaction. If a key signed by the
kernel-embedded key is compromised, how can that key be revoked so that
it is no longer trusted?

Someone mentioned UEFI blacklists, which I don't know much about, but
not all systems have UEFI. The only reliable option that comes to mind
for me is an in-kernel blacklist of keys which should no longer be
trusted.

Seth
