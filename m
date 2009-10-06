Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:53135 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756033AbZJFMT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 08:19:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 6C757148013
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2009 14:18:20 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id l1Yw+JDfYi-s for <linux-wireless@vger.kernel.org>;
	Tue,  6 Oct 2009 14:18:20 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F9373.dip0.t-ipconnect.de [217.95.147.115])
	by mx51.mymxserver.com (Postfix) with ESMTP id 1535C148011
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2009 14:18:18 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id CFA701E0036
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2009 14:18:08 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: question about cfg80211_inform_bss()
Date: Tue, 6 Oct 2009 14:18:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910061418.05039.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

I did implement the cfg80211 scan command in libertas. Now I'm 
about to submit the results back to cfg80211. AFAIK I have to 
use cfg80211_inform_bss() for this.

There's just one subtle problem here:

I tell the firmware of libertas card to scan on some channels, 
e.g. on 4 channels at a time. The firmware does this, and then 
sends me back a scan response. This scan response may contain 
any number of APs, from different channels. I don't know which 
BSS entry belongs to which channel --- unless I parse the 
also-supplied IE.

However, cfg80211_inform_bss() want's a channel. And it wants the 
IEs as well. A presume it scans those IEs, too. So do we need to 
parse the IEs twice?

-- 
http://www.holgerschurig.de
