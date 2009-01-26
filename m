Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:13400 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZAZNsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2009 08:48:35 -0500
Received: by rv-out-0506.google.com with SMTP id k40so5850769rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2009 05:48:34 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 26 Jan 2009 15:48:34 +0200
Message-ID: <dac45060901260548n7e541464ufaa7d1bb961f7573@mail.gmail.com> (sfid-20090126_144842_090441_C6820613)
Subject: A short question about mesh routing
From: Mark Ryden <markryde@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
- Mesh routing in Linux implements the hwmp protocol.
- I had delved into the mesh code in the latest git wireless-testing tree.
- The part for on demand routing is implemented via the
mesh_path_start_discovery()  and other methods and via
sending/receiving the MPATH_PREQ /MPATH_PREP/MPATH_PERR messages  (see
mesh_hwmp.c)

- My question is about proactive routing: First, AFAIK,  proactive
routing is mandatory in hwmp (the name hybrid suggests it, proactive
routing and on demand
routing). This technique should proactively build a tree topology.
AFAIK, there should be at least one Portal is present in the network (so
that the tree shall be rooted at that Portal).
However, I could not find the Root Announcement (RANN) message which is needed
proactive routing in the mac80211 stack.

Is proactive routing implemented at all in the mesh code in the Linux kernel?
	
Regards,
Mark
