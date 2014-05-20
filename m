Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:58080 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaETILn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 04:11:43 -0400
Received: from [99.240.204.5] (port=35556 helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.80)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1Wmeq1-0003sF-P6
	for linux-wireless@vger.kernel.org; Tue, 20 May 2014 03:51:53 -0400
Date: Tue, 20 May 2014 03:49:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
To: linux-wireless@vger.kernel.org
Subject: if i deselect PCIEPORTBUS, why are iwlwifi PCIE modules still being
 compiled?
Message-ID: <alpine.LFD.2.11.1405200342050.10462@localhost> (sfid-20140520_101149_157876_1874D563)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


  quite possibly a silly question (which has never stopped me before),
but in perusing the PCIE code in the kernel source, i was looking for
sample code to demo in a classroom setting and picked on
drivers/net/wireless/iwlwifi/pcie, which i was *assuming* was
PCIE-dependent -- specifically, i was going to demo the Advanced-N
6235 PCIE wifi card on an intel galileo board.

  but i thought it was a bit strange that the pcie/ subdirectory there
doesn't seem to depend on PCIEPORTBUS. as a test, i deselected
PCIEPORTBUS in a configuration and did a rebuild, and the source in
the pcie/ directory was recompiled.

  am i misunderstanding the function of the kernel config variable
PCIEPORTBUS? i notice that .../iwlwifi/Makefile includes the line:

  iwlwifi-objs  += pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o

which simply compiles those files with no regard to dependency. can
someone clarify this? thanks.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
