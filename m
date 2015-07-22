Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34727 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbGVFVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jul 2015 01:21:36 -0400
Received: by obre1 with SMTP id e1so128297272obr.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jul 2015 22:21:36 -0700 (PDT)
Received: from localhost.localdomain (50-24-3-101.bcstcmtk01.res.dyn.suddenlink.net. [50.24.3.101])
        by smtp.gmail.com with ESMTPSA id oy11sm222891oeb.3.2015.07.21.22.21.35
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jul 2015 22:21:35 -0700 (PDT)
From: ahmed.taahir@gmail.com
To: linux-wireless@vger.kernel.org
Subject: Support Python 3 in the crda build system (Take 2)
Date: Wed, 22 Jul 2015 00:21:22 -0500
Message-Id: <1437542484-23409-1-git-send-email-ahmed.taahir@gmail.com> (sfid-20150722_072140_179152_2A291310)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Updated Intro:

This patchset takes into account helpful comments by Stefan.  The user
can now set the make variable BUILD_PYTHON to select which interpreter
runs key2pub.py.

key2pub.py is further simplified as well.

Original Intro:

crda's build system is one of the last packages with a hard dep on
python-2.7 on my Gentoo system.  This patchset adapts the utility
script 'key2pub.py' so that it will run under either Python 2.7 or
Python 3.x.  The main change is a switch from using M2Crypto to
PyCrypto, specifically for Python 3.x support.

In addition, Gentoo had a small collection of bugfix patches that were
applied every time someone installed crda.  I've included those that
seemed to have general applicability, as described in Patch 2.

