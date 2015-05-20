Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36769 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413AbbETUf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 16:35:58 -0400
Received: by igbpi8 with SMTP id pi8so112596011igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 20 May 2015 13:35:54 -0700 (PDT)
From: Kyle McMartin <jkkm@jkkm.org>
Date: Wed, 20 May 2015 16:35:51 -0400
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150520203551.GA13557@foundry.jkkm.org> (sfid-20150520_223605_965928_5BF37011)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150520140426.GB126473@ubuntu-hedt>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2015 at 09:04:26AM -0500, Seth Forshee wrote:
> I raised the question of key revocation when we discussed this on irc,
> but it wasn't answered to my satisfaction. If a key signed by the
> kernel-embedded key is compromised, how can that key be revoked so that
> it is no longer trusted?
> 
> Someone mentioned UEFI blacklists, which I don't know much about, but
> not all systems have UEFI. The only reliable option that comes to mind
> for me is an in-kernel blacklist of keys which should no longer be
> trusted.
> 

I think the solution here is two-fold... first, we'll probably try some
to use a HSM for signing, so there's extremely low risk of compromise.
Secondly, if we annotate the key such that it can only be used for
firmware, a compromise of my key won't allow you to kexec or load kernel
modules.

regards, --Kyle
