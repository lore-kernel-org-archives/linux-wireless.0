Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbbESQbT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 12:31:19 -0400
Date: Tue, 19 May 2015 18:31:16 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Howells <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ming.lei@canonical.com, rusty@rustcorp.com.au,
	torvalds@linux-foundation.org, seth.forshee@canonical.com,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
	jlee@suse.com, tiwai@suse.de, casey@schaufler-ca.com,
	keescook@chromium.org, mjg59@srcf.ucam.org,
	akpm@linux-foundation.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [RFC v3 2/2] firmware: add firmware signature checking support
Message-ID: <20150519163116.GE23057@wotan.suse.de> (sfid-20150519_183135_430497_53C35145)
References: <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
 <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
 <9412.1432029764@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9412.1432029764@warthog.procyon.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2015 at 11:02:44AM +0100, David Howells wrote:
> Luis R. Rodriguez <mcgrof@do-not-panic.com> wrote:
> 
> > +The kernel firmware signing facility enables to cryptographically sign
> > +firmware files on a system using the same keys used for module signing.
> > +Firmware files's signatures consist of PKCS#7 messages of the respective
> > +firmware file. A firmware file named foo.bin, would have its respective
> > +signature on the filesystem as foo.bin.p7s. When firmware signature
> > +checking is enabled (FIRMWARE_SIG) and when one of the above APIs is used
> > +against foo.bin, the file foo.bin.p7s will also be looked for. If
> > +FIRMWARE_SIG_FORCE is enabled the foo.bin file will only be allowed to
> > +be returned to callers of the above APIs if and only if the foo.bin.p7s
> > +file is confirmed to be a valid signature of the foo.bin file. If
> > +FIRMWARE_SIG_FORCE is not enabled and only FIRMWARE_SIG is enabled the
> > +kernel will be permissive and enabled unsigned firmware files, or firmware
> > +files with incorrect signatures. If FIRMWARE_SIG is not enabled the
> > +signature file is ignored completely.
> 
> I'd rework this paragraph somewhat.  How about:
> 

<-- snip -->

Looks sexy, taken word for word, thanks!

 Luis
