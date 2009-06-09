Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from L01SLCSMTP01.calltower.com ([69.4.184.248]:14894 "EHLO
	L01SLCSMTP01.calltower.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753347AbZFITzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 15:55:10 -0400
Subject: Cross compiling libnl, iw, crda and friends
From: Jon Loeliger <jdl@bigfootnetworks.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 09 Jun 2009 14:54:46 -0500
Message-Id: <1244577286.12185.7.camel@jdl-desktop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Guys,

Am I missing an obvious solution to cross compiling libnl, iw,
the crda and related friends?

I have a cross-compiled kernel and headers and such, and I'd
like to add the various wireless tools into the mix, but I
think the existing Makefiles are basically unaware of cross
compiling.

I think there are a couple points of confusion.  While we need
to compile on the host machine, we need to point to the target
include files which may not be installed in standard locations.
The resulting libraries, though, need to be installed in standard
locations on the target.  This combination doesn't seem to be
recordable in the pkg-config files (libnl-2.0.pc, for example).

Then things like crda and iw need to use the headers from the
cross-build installation and the cross-kernel, not the host's.

Also, crda seems to have hard paths for the regulatory.bin.
I want to point to my source package for the build, but then
install it into a standard location on the target.  Feh.

I feel like I'm missing something here...?

Thanks,
jdl


