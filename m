Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44955 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbbIBDgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 23:36:11 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 2 Sep 2015 13:36:08 +1000
Message-ID: <1441164905.17898.86.camel@linux.vnet.ibm.com> (sfid-20150902_053629_893797_22381BFA)
Subject: Re: Linux Firmware Signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Kees Cook <keescook@chromium.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	"Roberts, William C" <william.c.roberts@intel.com>,
	"linux-security-module@vger.kernel.org"
	<linux-security-module@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"james.l.morris@oracle.com" <james.l.morris@oracle.com>,
	"serge@hallyn.com" <serge@hallyn.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@parisplace.org>,
	SE Linux <selinux@tycho.nsa.gov>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	"Schaufler, Casey" <casey.schaufler@intel.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Jones <pjones@redhat.com>, Takashi Iwai <tiwai@suse.de>,
	Ming Lei <ming.lei@canonical.com>, Joey Lee <jlee@suse.de>,
	=?UTF-8?Q?Vojt=C4=9Bch_Pavl=C3=ADk?= <vojtech@suse.com>,
	Kyle McMartin <kyle@kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jay Schulist <jschlst@samba.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 01 Sep 2015 23:35:05 -0400
In-Reply-To: <20150902000915.GW8051@wotan.suse.de>
References: <476DC76E7D1DF2438D32BFADF679FC5601058E78@ORSMSX103.amr.corp.intel.com>
	 <CAGXu5jJuwPfnQhu9u4-90UkmjWTBF_GLpJ7J1VaaT2D0d_-Mhg@mail.gmail.com>
	 <1440462367.2737.4.camel@linux.vnet.ibm.com>
	 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
	 <1440464705.2737.36.camel@linux.vnet.ibm.com>
	 <14540.1440599584@warthog.procyon.org.uk>
	 <31228.1440671938@warthog.procyon.org.uk>
	 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	 <20150827212907.GF8051@wotan.suse.de>
	 <CAGXu5jKF6CBAADoybZHRCzYAepcZYqpbck1gTAeV1p7iuOVAvw@mail.gmail.com>
	 <20150902000915.GW8051@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-02 at 02:09 +0200, Luis R. Rodriguez wrote:
> On Tue, Sep 01, 2015 at 01:20:37PM -0700, Kees Cook wrote:
> > On Thu, Aug 27, 2015 at 2:29 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > As long as the LSM know what kind of file it's loading, and has access
> > to the fd (and for IMA, the blob loaded from that fd), that should be
> > everything it needs. IMA has the name and blob, loadpin has the fd,
> > and a future signature-checking LSM could be able to look up signature
> > type from the load type, and split the key off (or fetch the key file)
> > itself.

I assume "and for IMA, the blob loaded from that fd"  is referring to
the file signature stored in the xattr.

> OK great, I think that instead of passing the actual routine name we should
> instead pass an enum type for to the LSM, that'd be easier to parse and we'd
> then have each case well documented. Each LSM then could add its own
> documetnation for this and can switch on it. If we went with a name we'd have
> to to use something like __func__ and then parse that, its not clear if we need
> to get that specific.

Agreed.  IMA already defines an enumeration.

/* IMA policy related functions */
enum ima_hooks { FILE_CHECK = 1, MMAP_CHECK, BPRM_CHECK, MODULE_CHECK,
                 FIRMWARE_CHECK, POLICY_CHECK, POST_SETATTR };

Mimi

