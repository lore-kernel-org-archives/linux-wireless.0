Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SMTP.ANDREW.CMU.EDU ([128.2.10.159]:37081 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYI0ROj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 13:14:39 -0400
Received: from whitestar.squill.dementia.org (198-144-37-134.static.vdsl.nidhog.net [198.144.37.134])
	(user=cg2v mech=GSSAPI (0 bits))
	by smtp.andrew.cmu.edu (8.13.8/8.13.8) with ESMTP id m8RH1abC010980
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sat, 27 Sep 2008 13:01:37 -0400
Date: Sat, 27 Sep 2008 13:01:57 -0400 (EDT)
From: Chaskiel Grundman <cg2v@andrew.cmu.edu>
To: linux-wireless@vger.kernel.org
Subject: Problems with iwlagn in compat-wireless-2.6-old
Message-ID: <Pine.LNX.4.64.0809271152390.7143@whitestar> (sfid-20080927_191458_556726_F6850733)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am running debian lenny (64bit, 2.6.26 kernel) on a dell D830 that has 
an intel 4965 wireless device.

I started using compat-wireless-2.6-old in the hope that it would help 
with connection stability issues I was having on some networks.

older versions of compat-wireless-2.6-old (at commit 
c69eab63a99699566501604b7ea78293b04f248f) work fairly well for me, but may 
be contributing to kernel panics.

Releases of compat-wireless-2.6-old newer than that do not work. There is 
a build problem that I worked around but cannot fix (I needed to put 
iwlagn-y += iwl-4965.o in iwlwifi/Makefile in order for the iwlagn module 
to include the 4965 code). The real problem is that I cannot associate to 
any AP. scanning works, but dmesg reports that authentication times out. 
This happens on A and B/G frequencies, and for wpa and open networks.

