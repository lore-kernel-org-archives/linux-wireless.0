Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:41466 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbXHMF6M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 01:58:12 -0400
Message-ID: <46BFF10B.1090307@hhs.nl>
Date: Mon, 13 Aug 2007 07:50:03 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: flamingice@sourmilk.net, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Recent linux-wireless git changes have broken my prism54pci card
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I first reported this in Fedora bugzilla, as I'm using Fedora with a Fedora 
kernel (which includes recent  linux-wireless git snapshots), see here for the 
Fedora bugreport:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=249823

Updating from the Fedora 7 test kernel to the final results in very poor 
performance, and going to even newer versions of the Fedora kernel totally 
breaks connectivity. Linville thought it would be best to further discuss this 
here, so here I am.

I've looked at recent git commits to the prism54 / p54pci driver and have been 
trying it revision by revision, eventually I've managed to pin the cause down 
to 2 patches, below is a verbatim cut and paste from the bugzilla entry, 
containing my analysis:

---

I've been busy researching this and I have come to the
following conclusions.

1) with the 2.6.20-2something F7-test kernel everything works fine build date
    3 march, I can give you the exact revision if you want.

2) with the fc release kerkel (3194) things work, but the connection is often lost.

3) with the 2.6.23-0.49.rc1.git3.fc8, the card asociates and thats it.

Using wireless git and out of tree driver building I've found that the following
2 patches are the culprits:

Patch causing loose off connection within seconds when fully loading the link
with a local file transfer:
http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=62ee473d67b7ae353d210b186abaadc37a642237

Only associating and nothing else:
http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=7d59453a9dbe50dc9bab846c410e39f8d5b10c83
And then specifically the changes to prism54common.c

This is with an isl3886 cardbus card, using the p54pci driver.

----

I would be more then happy to test any changes.

Thanks & Regards,

Hans


p.s.

Please keep my CC-ed I'm not on the list.
