Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:56562 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758384AbbA2Jq6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 04:46:58 -0500
MIME-Version: 1.0
Date: Thu, 29 Jan 2015 11:46:56 +0200
Message-ID: <CANUX_P2cPevVgWrSvSR+ufaBV1Uth=mmj6OOG7hC5Y4Q49fm2Q@mail.gmail.com> (sfid-20150129_104712_811763_14664A11)
Subject: random failures with Intel devices starting from kernel 3.18
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Cc: sait.a.umar@gmail.com, gredner@gmail.com, kichawa23@interia.pl,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently got quite a few reports about failures of the Intel wireless devices.
I looked at the logs and it turns out that we can't access our device
anymore. We had bad issues around this and I fixed them in the iwlwifi
driver in the end. What makes me feels that I need to add PCI folks is
that I can feel that we have a regression in 3.18 (based on the number
of reports) and we didn't change much there that could cause such a
bug.

Also, very surprisingly, I asked someone to disable ASPM as a boot
parameter and that didn't actually disable it. You can find more
details here [1].

What I see in the logs is that iwlwifi is trying to access the mapped
memory of the device (I may have a bad terminology, but it is BAR +
0x24 - let me know if the term is not the right one), and we get
0xffffffff...

Any thoughts?

Thanks!

[1] https://bugzilla.kernel.org/show_bug.cgi?id=91171

Emmanuel Grumbach
egrumbach@gmail.com
