Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:53461 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462AbZFKWvY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 18:51:24 -0400
Subject: Re: RFC: cross-building crda
From: Pavel Roskin <proski@gnu.org>
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1244733695.14768.22.camel@jdl-desktop>
References: <1244733695.14768.22.camel@jdl-desktop>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 18:51:25 -0400
Message-Id: <1244760685.6544.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-06-11 at 10:21 -0500, Jon Loeliger wrote:

> So I'm proposing to introduce a two-layer build where the
> top-level Makefile will introduce a "host/" and a "target/"
> sub-directory build for each environment.  If the build
> is not a cross-build, no "target/" build happens and it
> all gets built in "host/" only.  The C files and sources
> all stay in the current top-level directory, and will be
> referenced and built into the host/ and target/ through
> Makefile fidgery sub-directories.

This sounds too complicated.  No other popular software does it, yet
somehow it can be cross-compiled.  I'm not talking about such software
as kernels, compilers and other tools that need to know specific
characteristics of the target.

Please check the sources of buildroot (http://buildroot.uclibc.org/) to
see how it manages to cross-compile a lot of programs that don't do
anything specific to support cross-compilation.  Sometimes minimal
patches are needed, but nothing nearly as intrusive as your proposal.

-- 
Regards,
Pavel Roskin
