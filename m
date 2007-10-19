Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:5652 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548AbXJSSwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 14:52:31 -0400
Received: by nf-out-0910.google.com with SMTP id g13so517531nfb
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2007 11:52:29 -0700 (PDT)
To: "Marcus Better" <marcus@better.se>
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
Date: Fri, 19 Oct 2007 21:10:37 +0200
Cc: linux-wireless@vger.kernel.org
References: <fdqhn4$qab$1@sea.gmane.org> <200710152013.20777.IvDoorn@gmail.com> <39384.80.169.182.16.1192780194.squirrel@www.dactylis.com>
In-Reply-To: <39384.80.169.182.16.1192780194.squirrel@www.dactylis.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710192110.37099.IvDoorn@gmail.com> (sfid-20071019_195234_164615_B9669995)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Ivo van Doorn wrote:
> > Could you enable debugfs and use attached debugfs script to create a
> > dump of the rt2x00 registers.
> 
> If you still need the debug dump for 2.0.7 (the latest working version),
> can you show me how to get hold of a source tree with that version? I have
> both the wireless-2.6 and rt2x00 git trees, but seem to have trouble
> locating the right revision, perhaps because the tree was rebased.

I'm afraid that is a bit of a problem, rt2x00 was merged into linus' tree as
a complete patch of version 2.0.8. This means the complete versioning of
2.0.7 has been lost.
The only possible way would be toying with cvs and copying the files
from there. But that is in no what a guarentee for success.

However I can recommend using 2.0.11 the following patches:
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=8927e4ea2933f5f276a7bb505a6b240156a9238f
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=32a8da711c3b03a88487dbe48e57c489b5a3031c

Both caused problems with packet throughput. So those might have
resolved the problem you reported.

Ivo
