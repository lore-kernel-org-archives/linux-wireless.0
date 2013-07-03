Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:62307 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab3GCAiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jul 2013 20:38:54 -0400
Received: by mail-la0-f51.google.com with SMTP id fq12so6093072lab.24
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jul 2013 17:38:52 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 2 Jul 2013 17:38:32 -0700
Message-ID: <CAB=NE6V_PKG2UBSLPRhziUDcFzFi8uOJNiNzoPNaK0oU7rmZuQ@mail.gmail.com> (sfid-20130703_023901_549147_B1EE6BF1)
Subject: Updates to wireless-regdb review - vendor namespaces and VHT80
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Folks,

we have 802.11ac and 802.11ad now and I have a few pending patches
that I'd like to submit but unfortunately the requirements that we
have discussed for accepting patches do not meet the criteria we have
set in the community [0] for all the documentation. Additionally
getting all that documentation has proven quite difficult and at this
point I do not think we can easily get these upstream without making
an exception.

I'd like to propose a middle ground to also address another issue I've
noticed. Vendors can disagree and in order to give vendors a warm
fuzzy on ability to ensure their data is interpreted and provide the
ability to offload down to wireless-regdb even more interpretations
I'd like to propose the idea of embracing vendor namespaces within
wireless-regdb / crda / the kernel. The way I'd envision this is
'/sbin/crda US OUI' is passed upon a regulatory hint and in turn CRDA
will read the namespace for the OUI passed in regulatory.bin. Then at
our wireless summit kumbaya and with the development / enhancements of
intersect.c and union.c (not yet developed) we'd work on generalizing
the data. This would also allow vendors to supply their own rules
without the high bar that we are setting which so far has proven very
difficult to met.

In the meantime, while that gets developed, I'd still like to supply
patches to enable VHT80 for a few countries without hopefully such
high bar for documentation as I cannot get this information.

Let me know if this sounds reasonable.

[0] http://marc.info/?l=linux-wireless&m=128414096127554&w=2

  Luis
