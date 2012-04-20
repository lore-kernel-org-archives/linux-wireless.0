Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57830 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab2DTEoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 00:44:01 -0400
Received: by obbta14 with SMTP id ta14so9049194obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 21:44:00 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 19 Apr 2012 21:43:40 -0700
Message-ID: <CAB=NE6Xw2-5vLD-52H2pFtaRkUSKZ1CrBzzU9HA-eDz-8tHw-A@mail.gmail.com> (sfid-20120420_064413_271298_2D9E9CF7)
Subject: compat-wireless daily snapshots
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey folks, I updated the patches / scripts on compat-wireless to apply
patches cleanly based on next-20120419 but compilation now fails with
the new slew of updates since next-20120410. The ckmake summary log:

mcgrof@flash ~/devel/compat-wireless (git::master)$ ckmake
Trying kernel                     3.2.2-030202-generic  [FAILED]
Trying kernel                    3.1.10-030110-generic  [FAILED]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [FAILED]
Trying kernel                  2.6.34-02063410-generic  [FAILED]
Trying kernel                  2.6.33-02063305-generic  [FAILED]
Trying kernel                  2.6.32-02063255-generic  [FAILED]
Trying kernel                  2.6.31-02063113-generic  [FAILED]
Trying kernel                  2.6.30-02063010-generic  [FAILED]
Trying kernel                  2.6.29-02062906-generic  [FAILED]
Trying kernel                  2.6.28-02062810-generic  [FAILED]
Trying kernel                    2.6.27-020627-generic  [FAILED]
Trying kernel                    2.6.26-020626-generic  [FAILED]
Trying kernel                    2.6.25-020625-generic  [FAILED]
Trying kernel                    2.6.24-020624-generic  [FAILED]

You can read the detailed warnings (non-fatal) and errors (these need
to be fixed) here:

http://bombadil.infradead.org/~mcgrof/2012/04/19/ckmake-compat-wireless-2012-04-19.log.bz2

I don't have time for these right now as I am leaving to the mountains
Friday-Sunday. I'm thinking a nice alternative from barring the entire
tarball to be released is to instead to disable the drivers that fail
compilation, but still haven't figured out a neat clean easy way to do
this and automate so for now no new daily tarballs are released until
all the above issues are fixed.

  Luis
