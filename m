Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48712 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbbIBDp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 23:45:28 -0400
Received: from /spool/local
	by e23smtp06.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 2 Sep 2015 13:45:25 +1000
Message-ID: <1441165462.17898.94.camel@linux.vnet.ibm.com> (sfid-20150902_054558_406658_92E3C86B)
Subject: Re: Linux Firmware Signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
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
	Julia Lawall <julia.lawall@lip6.fr>,
	Jay Schulist <jschlst@samba.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Alexei Starovoitov <ast@plumgrid.com>
Date: Tue, 01 Sep 2015 23:44:22 -0400
In-Reply-To: <CAGXu5j+_yHc1wbubzw4h=QFM=uyn1pCraGYCWS6LvgtS3-A+Qw@mail.gmail.com>
References: <1440462367.2737.4.camel@linux.vnet.ibm.com>
	 <CALCETrXWBBdOKz-fSdM7YVu_sWQbA3YsHPeZAkRmtj+eawqZGQ@mail.gmail.com>
	 <1440464705.2737.36.camel@linux.vnet.ibm.com>
	 <14540.1440599584@warthog.procyon.org.uk>
	 <31228.1440671938@warthog.procyon.org.uk>
	 <36ddb60c1d22756234392a2d065a02cb.squirrel@twosheds.infradead.org>
	 <20150827212907.GF8051@wotan.suse.de>
	 <1440719673.2118.84.camel@linux.vnet.ibm.com>
	 <20150829021659.GN8051@wotan.suse.de>
	 <1441030735.2647.70.camel@linux.vnet.ibm.com>
	 <20150901234305.GU8051@wotan.suse.de>
	 <CAGXu5j+_yHc1wbubzw4h=QFM=uyn1pCraGYCWS6LvgtS3-A+Qw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-09-01 at 20:08 -0700, Kees Cook wrote:
> On Tue, Sep 1, 2015 at 4:43 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> > On Mon, Aug 31, 2015 at 10:18:55AM -0400, Mimi Zohar wrote:
> >> > > eBPF/seccomp
> >
> > OK I knew nothing about this but I just looked into it, here are my notes:
> >
> >   * old BPF - how far do we want to go? This goes so far as to parsing
> >     user passed void __user *arg data through ioctls which typically
> >     gets copy_from_user()'d and eventually gets BPF_PROG_RUN().
> >
> >   * eBPF:
> >                              seccomp() & prctl_set_seccomp()
> >                                         |
> >                                         V
> >                              do_seccomp()
> >                                         |
> >                                         V
> >                              seccomp_set_mode_filter()
> >                                         |
> >                                         V
> >                              seccomp_prepare_user_filter()
> >                                         |
> >                                         V
> >         bpf_prog_create_from_user() (seccomp) \
> >         bpf_prog_create()                      > bpf_prepare_filter()
> >         sk_attach_filter()                    /
> >
> >     All approaches come from user passed data, nothing fd based.
> >
> >     For both old BPF and eBPF then:
> >
> >     If we wanted to be paranoid I suppose the Machine Owner Key (MOK)
> >     Paul had mentioned up could be used to vet for passed filters, or
> >     a new interface to enable fd based filters. This really would limit
> >     the dynamic nature of these features though.
> >
> >     eBPF / secccomp would not be the only place in the kernel that would have
> >     issues with user passed data, we have tons of places the same applies so
> >     implicating the old BPF / eBPF / seccomp approaches can easily implicate
> >     many other areas of the kernel, that's pretty huge but from the looks of
> >     it below you seem to enable that to be a possibility for us to consider.
> 
> At the time (LSS 2014?) I argued that seccomp policies come from
> binaries, which are already being measured. And that policies only
> further restrict a process, so there seems to be to be little risk in
> continuing to leave them unmeasured.

What do you mean by "measured"?  Who is doing the measurement?  Could
someone detect a change in measurement?

Mimi

