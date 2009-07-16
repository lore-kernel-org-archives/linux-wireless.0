Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:56201 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbZGPJiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 05:38:52 -0400
Received: by bwz28 with SMTP id 28so1933727bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 02:38:51 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: Further improvements to the software scan implementation
Date: Thu, 16 Jul 2009 11:38:58 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Luis Rodriguez <mcgrof@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907161138.58874.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

as already discussed with Johannes we can further optimize the scan
implementation by allowing (on an active channel) to send probes as
soon as any other frame is received (and updated the NAV) instead of
ever waiting 30ms.

Another optimization I thought of while reading [1] would be to take the
same approach as Intel in their ucode. If a frame is received while
scanning a passive channel switch to active scan mode and send out probes.
That should allow us to shorten the time needed to stay on that channel.
Luis, do you think this is ok in regard to regulatory restrictions?

Thanks,
Helmut

[1] http://sourceforge.net/mailarchive/forum.php?thread_name=200907061428.55840.jung%40ecos.de&forum_name=ipw3945-devel
