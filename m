Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:39990 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYI2Tng (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 15:43:36 -0400
Received: by gxk9 with SMTP id 9so11007962gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 29 Sep 2008 12:43:35 -0700 (PDT)
Message-ID: <43e72e890809291243n72cd9d8am3bf6307cf52707da@mail.gmail.com> (sfid-20080929_214346_912220_48E45EE2)
Date: Mon, 29 Sep 2008 12:43:34 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: lsb-discuss@lists.linux-foundation.org
Subject: A home for ISO/IEC 3166 alpha2
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the Linux wireless subsystem we now have a use for having the
ISO/IEC 3166 alpha2 [1] of a user's system be stored somewhere and
allow the user to update this (through some admin capability) for
purposes of helping with regulatory considerations. Our new regulatory
infrastructure [2] can now make use of the alpha2 to set in place a
safety net of regulatory restrictions on the wireless drivers present.
A regulatory database is used then in userspace to pass to the kernel
a regulatory domain it builds based on the alpha2.

We were recently discussing who would set this [3] and it seems there
are a range of devices which could help contribute to this. Ultimately
we will use this to update the regulatory domain. Should this file be
updated a trigger should be made to change the regulatory domain as
well, for example. Provided that there may be other uses other than
wireless to define what country the user currently is in I was
wondering if there is a place for this already and if not consider its
addition to LSB. I'm not seeing it defined as of LSB 3.2. From what I
read from LSB 3.2 Core - VI Section 16.2 /etc: Host-specific system
configuration [4] we should be looking to Linux Assigned Names And
Numbers Authority (LANANA) LSB Provider Name Registry [5] for defining
a home for this? Is this correct?

Perhaps something as simple as /etc/country and in it we define the
ISO3166 alpha2.

Distributions can then set this to the country upon installation time
and then when certain devices (either the user, GPS, etc) determine
the user's location has changed the file gets updated and notification
gets sent (maybe through udev?)

[1] http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
[2] http://wireless.kernel.org/en/developers/Regulatory
[3] http://thread.gmane.org/gmane.linux.kernel.wireless.general/21333
[4] http://refspecs.linux-foundation.org/LSB_3.2.0/LSB-Core-generic/LSB-Core-generic/etc.html
[5] http://www.lanana.org/lsbreg/providers/index.html

Note: I think lsb-discuss requires subscription to post, linux-wireless doesn't

  Luis
