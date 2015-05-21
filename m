Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60610 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756470AbbEUWud (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 18:50:33 -0400
Date: Fri, 22 May 2015 00:50:30 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150521225030.GK23057@wotan.suse.de> (sfid-20150522_005050_803284_6CB85B03)
References: <20150519200232.GM23057@wotan.suse.de>
 <20150520140426.GB126473@ubuntu-hedt>
 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2015 at 05:24:46PM +0100, One Thousand Gnomes wrote:
> On Wed, 20 May 2015 09:04:26 -0500
> Seth Forshee <seth.forshee@canonical.com> wrote:
> 
> > On Tue, May 19, 2015 at 10:02:32PM +0200, Luis R. Rodriguez wrote:
> > > This begs the question on how we'd manage keys for firmware signing on
> > > linux-firmare. Since the keys are x509 keys we need a CA. Based on some initial
> > > discussions it would seem we'd need the Linux Foundation to create a key, this
> > > would be embedded in the kernel and that key would be used to sign Kyle's key.
> > > Kyle would in turn use his key for signing linux-firmware files. David, Kyle,
> > > did I summarize this correctly ?
> > 
> > I raised the question of key revocation when we discussed this on irc,
> > but it wasn't answered to my satisfaction. If a key signed by the
> > kernel-embedded key is compromised, how can that key be revoked so that
> > it is no longer trusted?
> > 
> > Someone mentioned UEFI blacklists, which I don't know much about, but
> > not all systems have UEFI. The only reliable option that comes to mind
> > for me is an in-kernel blacklist of keys which should no longer be
> > trusted.
> 
> More to the point why do you want to sign firmware files ?

This would add support to firmware loading the same dog and pony show as used
by the module and kexec code, sharing as much dog and pony as is possible. This
also allows us to phase 802.11's dog and pony show which is sitting on the side all
on it own and implicates distros to do more work.

 Luis
