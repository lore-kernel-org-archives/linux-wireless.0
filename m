Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbbGNTUV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 15:20:21 -0400
Date: Tue, 14 Jul 2015 21:20:15 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Kees Cook <keescook@chromium.org>,
	David Howells <dhowells@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Ming Lei <ming.lei@canonical.com>, seth.forshee@canonical.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Paul Bolle <pebolle@tiscali.nl>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, jlee@suse.com,
	Takashi Iwai <tiwai@suse.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <David.Woodhouse@intel.com>
Subject: Re: [RFC v3 2/2] firmware: add firmware signature checking support
Message-ID: <20150714192015.GO7021@wotan.suse.de> (sfid-20150714_212046_762441_9DAE965E)
References: <1431996325-8840-1-git-send-email-mcgrof@do-not-panic.com>
 <1431996325-8840-3-git-send-email-mcgrof@do-not-panic.com>
 <CAGXu5jJnPqgpvXd05-dtSbYeSVndcpH1_XMMczPWn5Gq-DUtcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jJnPqgpvXd05-dtSbYeSVndcpH1_XMMczPWn5Gq-DUtcw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 08, 2015 at 12:56:44PM -0700, Kees Cook wrote:
> On Mon, May 18, 2015 at 5:45 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> > index 134dd77..97cab65 100644
> > --- a/drivers/base/firmware_class.c
> > +++ b/drivers/base/firmware_class.c
> > @@ -180,17 +190,33 @@ static struct firmware_buf *__allocate_fw_buf(const char *fw_name,
> >                                               struct firmware_cache *fwc)
> >  {
> >         struct firmware_buf *buf;
> > +       const char *sign_ext = ".p7s";
> > +       char *signed_name;
> > +
> > +       signed_name = kzalloc(PATH_MAX, GFP_ATOMIC);
> > +       if (!signed_name)
> > +               return NULL;
> >
> >         buf = kzalloc(sizeof(*buf), GFP_ATOMIC);
> > -       if (!buf)
> > +       if (!buf) {
> > +               kfree(signed_name);
> >                 return NULL;
> > +       }
> >
> >         buf->fw_id = kstrdup_const(fw_name, GFP_ATOMIC);
> >         if (!buf->fw_id) {
> > +               kfree(signed_name);
> >                 kfree(buf);
> >                 return NULL;
> >         }
> >
> > +       strcpy(signed_name, buf->fw_id);
> > +       strncat(signed_name, sign_ext, strlen(sign_ext));
> 
> fw_id is potentially unbounded, so using strncat hear poses an
> overflow risk. Maybe better to use strlcpy?
> 

Thanks for the feedback, indeed.

 Luis
