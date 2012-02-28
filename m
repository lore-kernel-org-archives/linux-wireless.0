Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:54934 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2B1Kgj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 05:36:39 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1S2KQ9-0008TB-GM
	for linux-wireless@vger.kernel.org; Tue, 28 Feb 2012 11:36:37 +0100
Received: from localhost ([::1]:50334 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1S2KQ8-0006LH-VI
	for linux-wireless@vger.kernel.org; Tue, 28 Feb 2012 11:36:37 +0100
Received: from [195.4.92.25] (port=58144 helo=15.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1S2KNf-00033N-O9
	for linux-wireless@vger.kernel.org; Tue, 28 Feb 2012 11:34:03 +0100
Received: from [2002:4fde:298:2:5054:ff:feb8:40bd] (port=53603 helo=mail.maya.org)
	by 15.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1S2KNf-0004of-6T
	for linux-wireless@vger.kernel.org; Tue, 28 Feb 2012 11:34:03 +0100
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.4/8.13.8) with ESMTP id q1SAXvJL004179
	for <linux-wireless@vger.kernel.org>; Tue, 28 Feb 2012 11:33:58 +0100
Message-ID: <4F4CAD95.1000102@01019freenet.de> (sfid-20120228_113646_889972_DEA60E04)
Date: Tue, 28 Feb 2012 11:33:57 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless install-scripts section broken since 2012-02-26
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm getting the following error during make install:

make install-scripts
/bin/sh: -c: line 0: syntax error near unexpected token `;'
/bin/sh: -c: line 0: `if ; then \'
make: *** [install-scripts] Error 1


Problem are these lines (one example - first line is the problem):

@if $(modinfo ath_pci > /dev/null 2>&1); then \
       echo -n "Note: madwifi detected, we're going to disable it. "  ;\
       echo "If you would like to enable it later you can run:"  ;\
       echo "    sudo athenable madwifi"  ;\
       echo ;\
       echo Running athenable ath5k...;\
       $(DESTDIR)/usr/sbin/athenable ath5k ;\
fi



Kind regards,
Andreas
