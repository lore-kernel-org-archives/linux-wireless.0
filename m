Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40618 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933858AbbELVXk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 17:23:40 -0400
Date: Tue, 12 May 2015 23:23:37 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Greg KH <greg@kroah.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	ming.lei@canonical.com, rusty@rustcorp.com.au, dhowells@redhat.com,
	seth.forshee@canonical.com, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, pebolle@tiscali.nl,
	linux-wireless@vger.kernel.org, Kyle McMartin <kyle@kernel.org>
Subject: Re: [PATCH v2 1/5] firmware: fix __getname() missing failure check
Message-ID: <20150512212337.GQ23057@wotan.suse.de> (sfid-20150512_232359_931287_0800A8A6)
References: <1431455457-25322-1-git-send-email-mcgrof@do-not-panic.com>
 <1431455457-25322-2-git-send-email-mcgrof@do-not-panic.com>
 <20150512212111.GB10402@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150512212111.GB10402@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 12, 2015 at 02:21:11PM -0700, Greg KH wrote:
> On Tue, May 12, 2015 at 11:30:53AM -0700, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > The request_firmware*() APIs uses __getname() to iterate
> > over the list of paths possible for firmware to be found,
> > the code however never checked for failure on __getname().
> > Although *very unlikely*, this can still happen. Add the
> > missing check.
> > 
> > There is still no checks on the concatenation of the path
> > and filename passed, that requires a bit more work and
> > subsequent patches address this. The commit that introduced
> > this is abb139e7 ("firmware: teach the kernel to load
> > firmware files directly from the filesystem").
> > 
> > mcgrof@ergon ~/linux (git::firmware-fixes) $ git describe --contains abb139e7
> > v3.7-rc1~120
> > 
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Ming Lei <ming.lei@canonical.com>
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: David Howells <dhowells@redhat.com>
> > Cc: Kyle McMartin <kyle@kernel.org>
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  drivers/base/firmware_class.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 171841a..bc6c8e6 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -322,7 +322,11 @@ static int fw_get_filesystem_firmware(struct device *device,
> >  {
> >  	int i;
> >  	int rc = -ENOENT;
> > -	char *path = __getname();
> > +	char *path;
> > +
> > +	path = __getname();
> > +	if (unlikely(!path))
> 
> Please only use likely/unlikely on code paths that actually care about
> it (i.e. you can measure the difference).  Otherwise it is pretty
> useless, and people have determined that sometimes it is slower as
> humans get this wrong a lot of time...

Will do , thanks.

 Luis
