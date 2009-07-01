Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:38530 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297AbZGASug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 14:50:36 -0400
Subject: Re: [Fwd: Re: [PATCH 4/5] Introduce separate HOST and TARGET
 compilation steps.]
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890907011049w45508c9fpfabdddf36c28e99c@mail.gmail.com>
References: <1246460365.11632.4.camel@jdl-desktop>
	 <43e72e890907010959q15bde116ue796802e006e410f@mail.gmail.com>
	 <1246468471.15757.12.camel@mj> <1246469405.11632.19.camel@jdl-desktop>
	 <43e72e890907011035x77005470u6646d7feb941b9f7@mail.gmail.com>
	 <1246470361.11632.23.camel@jdl-desktop>
	 <43e72e890907011049w45508c9fpfabdddf36c28e99c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 13:50:40 -0500
Message-Id: <1246474240.11632.27.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-01 at 10:49 -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 1, 2009 at 10:46 AM, Jon Loeliger<jdl@bigfootnetworks.com> wrote:
> > On Wed, 2009-07-01 at 10:35 -0700, Luis R. Rodriguez wrote:
> >> On Wed, Jul 1, 2009 at 10:30 AM, Jon Loeliger<jdl@bigfootnetworks.com> wrote:
> >>
> >> > Do you agree or disagree with me when I say that the regdbdump program
> >> > might need to be compiled twice -- once for the host and once for the
> >> > target?
> >>
> >> Why?
> >
> > The existing binary regulatory DB binary is verified on the host
> > using these rules.  (This is from my version of the makefile, but
> > they are there in the original too.):
> >
> >    all: host target $(REG_BIN) $(BUILD_ALL) verify
> >
> >    verify: $(REG_BIN) host/regdbdump
> >        $(NQ) '  CHK  $(REG_BIN)'
> >        $(Q)./host/regdbdump $(REG_BIN) >/dev/null
> >
> > That is, as part of the host build process, the regdbdump tool
> > is run *on the host*.
> 
> This helps to understand a little better some of your intentions, may
> be good to mention this as part of your patches. Hm, interesting... I
> suppose we don't want to just disable this check then.

Luis,

Shall I supply more or different information than what
was in my git log message?:

        The regdbdump tool is really a host executable that is used
        during the build process.  It could also be installed and
        used on the target, but two separate compilations are needed
        to achieve that goal.
        
        Currently, regdbdump is only built for the target, and thus
        cross-compilation of the tool is really feasible without
        this patch (or one like it).
        
        Signed-off-by: Jon Loeliger <jdl@bigfootnetworks.com>

Though, we should s/feasible/infeasible/ there too. :-)

> > Ultimately, the regdbdump utility may *also* be needed or
> > wanted on the target too.
> 
> ACK.
> 
>   Luis

Thanks,
jdl


