Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.242]:28744 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671AbYFHPzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jun 2008 11:55:03 -0400
Received: by an-out-0708.google.com with SMTP id d40so421728and.103
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jun 2008 08:55:02 -0700 (PDT)
Message-ID: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com> (sfid-20080608_175618_790913_8944EACA)
Date: Sun, 8 Jun 2008 08:55:00 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Backported MQ requirement on 802.11n for older kernels
Cc: compat-masters@lists.madwifi.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	tomas.winkler@intel.com, "Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just finished trying to backport CONFIG_NETDEVICES_MULTIQUEUE
requirement for 802.11n to older kernels by relying on the old
internal mac80211 hacked up MQ support. I've tested the build on
2.6.22, 2.6.23, and 2.6.24. Let me know if you get to test this,
particularly iwl4965 using 11n on 2.6.22.

Oh and if you're interested in helping with the compat-wireless work
please subscribe to this new list:

https://lists.madwifi.org/mailman/listinfo/compat-masters

I called it compat-masters as compat-maintainers sounded too boring.
You can also send compat-wireless patches there to not clutter
linux-wireless mailing list. I'll soon enable automatic compile tests
across each kernel we support in compat-wireless and only if it fails
will you get a nagging e-mail on that list. This means no new
compat-wireless package will be put on wireless.kernel.org unless we
know it compiles fine on all kernels supported. This should prevent
using from getting tarballs they can't compile.

  Luis
