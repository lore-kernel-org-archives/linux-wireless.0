Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:54023 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751295AbZHKMDX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 08:03:23 -0400
Message-ID: <4A81070C.4070808@redfish-solutions.com>
Date: Mon, 10 Aug 2009 22:52:12 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jon Loeliger <jdl@bigfootnetworks.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] CRDA and cross-compilation
References: <4A7A8F7E.6020503@redfish-solutions.com>	 <1249576886.14919.16.camel@mj>	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>	 <1249580707.14919.29.camel@mj>	 <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>	 <4A7BD15E.1030604@redfish-solutions.com>	 <43e72e890908070905s447a2fc0j2dc086048194db34@mail.gmail.com>	 <4A7CC24D.1000104@redfish-solutions.com> <1249698462.25983.7.camel@mj>	 <4A809B8D.5000309@redfish-solutions.com>	 <43e72e890908101530h3b024c83t7e73817ed6e28618@mail.gmail.com>	 <4A80B363.3090809@redfish-solutions.com> <1249950344.14653.51.camel@mj>
In-Reply-To: <1249950344.14653.51.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Mon, 2009-08-10 at 16:55 -0700, Philip A. Prindeville wrote:
> 
>> You're right: that comment was much more helpful...  does it apply to the first file or the second or both?
>>
>> And what in particular is a mess?
> 
> Cross compilation is not easy.  That's why there are such
> "metadistros" (for the lack of a better word) as buildroot and
> openembedded.  They have special entries for every package that specify
> how to cross-compile it.  There are patches for many sources, although
> it's better to have such files applied to the upstream sources.  But
> it's inevitable that the build is influenced in some way to
> cross-compile, often by specifying variables on the make command line.
> 
> I believe the developers of buildroot and openembedded would be able to
> deal with CRDA as is.  If they find something that could be improved,
> they can send a patch, but I don't think they will bother to change so
> many things as your patch does.
> 
> Besides, it's one thing to follow sane rules that simplify
> cross-compilation, such as providing the fourth argument to
> AC_RUN_IFELSE in configure.ac or not using uname to determine the target
> architecture.  It's another thing to support cross-compilation in a way
> unique to the package.  The gain is miniscule, and the potential for
> breaking is substantial.
> 
> Most importantly, you are wasting time of people who could be doing
> something they are better at, such as development of wireless drivers.
> 
> There is no point in pushing the same patch over and over again, just
> because you wrote it.  Please try to accept the fact that it's not
> useful for others.  Maybe it was useful for you as an exercise.  But now
> you are not helping.  Please move on and do something else.

Pavel,

Consider the code in the form of the latest submission.  The conditional-compilation path *is* necessary.

Here's why.

Consider that at some point someone decides to spruce up the functionality of CRDA, perhaps by adding internationalization/NLS (just to pick an example)... and adds code for GETTEXT or some other library.

Then they decide that it isn't optional, it's a requirement.

Currently to make things build, I'd have to call:

make -C crda USE_OPENSSL=1 NL1FOUND=Y NLLIBNAME=libnl-1 NLLIBS=-lnl-1 ...

just to get it to compile successfully.

Then someone has the brilliant idea above (of adding new functionality, and making it mandatory), and adds a corresponding bit of code like:

ifeq ($(NLLIBNAME),)
$(error Cannot find development files for any supported version of libnl)
endif

to do the equivalent functionality.  Bingo.  The cross-compilation would break, and I'd have to come back and stare at the makefile and add to an ever increasing list of variables that had to be passed in.

But that's not even the worst of it.

NL1FOUND is an internal variable!  It's used as a temporary for some transient state in the makefile... It shouldn't even be externally visible, ditto for NLLIBNAME.  Yet if I don't pass this variable in, the make dies with the above $(error ...) message.

And you're telling me that my patch is a glory mess?

Not hardly.

At least my proposed fix compartmentalizes the auto-configuration bits from the list of external state that needs to be passed in, so it's quickly apparent which is which.

-Philip

