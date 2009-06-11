Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP02.calltower.com ([69.4.184.249]:39346 "EHLO
	L01SLCSMTP02.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756706AbZFKPWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 11:22:07 -0400
Subject: RFC: cross-building crda
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 10:21:35 -0500
Message-Id: <1244733695.14768.22.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I'd like to propose a few changes to the CRDA Makefile
to allow better cross compilation support, and would
like to get your suggestion/approval/recommendation on
an overall approach before I get to far into it.

First, the easy change would be to allow some local
customization by adding "-include .config" as the first
line of the Makefile in the same style as the iw Makefile.

Second, in CRDA's Makefile, the "verify" step that builds
and uses regdbdump is really a host build and operation.
The regdbdump tool might then also be (re-)built as a target
tool and installed on the target as well.

So I'm proposing to introduce a two-layer build where the
top-level Makefile will introduce a "host/" and a "target/"
sub-directory build for each environment.  If the build
is not a cross-build, no "target/" build happens and it
all gets built in "host/" only.  The C files and sources
all stay in the current top-level directory, and will be
referenced and built into the host/ and target/ through
Makefile fidgery sub-directories.

Things like the CFLAGS and LDLIBS will have dual host
and target specific variants built-up and used in their
respective sub-driectories, all driven by the top-level
Makefile still.

Stylistically, would folks prefer
    1) three separate Makefiles in the top-, host/ and
       target/ directories, non-inclusively doing sub-make
       requests (ie, "make -C host/ all"),
    2) three Makefile components that all get "included"
       into the top-level Makefile without doing sub-make
       build requests,
or
    3) Just one top-level Makefile that hard-codes and
       builds targets directly into the sub-dirs?

Thoughts?

Thanks,
jdl


