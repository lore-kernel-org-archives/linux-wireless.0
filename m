Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:34438 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933999AbbGVAiH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 20:38:07 -0400
Received: by oigd21 with SMTP id d21so91988384oig.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 17:38:07 -0700 (PDT)
Received: from localhost.localdomain (50-24-3-101.bcstcmtk01.res.dyn.suddenlink.net. [50.24.3.101])
        by smtp.gmail.com with ESMTPSA id mu5sm15178904obc.4.2015.07.21.17.38.06
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jul 2015 17:38:06 -0700 (PDT)
From: ahmed.taahir@gmail.com
To: linux-wireless@vger.kernel.org
Subject: Support Python3 in the crda buildsystem.
Date: Tue, 21 Jul 2015 19:37:44 -0500
Message-Id: <1437525466-27512-1-git-send-email-ahmed.taahir@gmail.com> (sfid-20150722_023812_906437_A7615ED8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

crda's build system is one of the last packages with a hard dep on
python-2.7 on my Gentoo system.  This patchset adapts the utility
script 'key2pub.py' so that it will run under either Python 2.7 or
Python 3.x.  The main change is a switch from using M2Crypto to
PyCrypto, specifically for Python 3.x support.

In addition, Gentoo had a small collection of bugfix patches that were
applied every time someone installed crda.  I've included those that
seemed to have general applicability, as described in Patch 2.

