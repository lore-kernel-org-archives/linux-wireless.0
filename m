Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:45751 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbZLCKtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:49:21 -0500
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id A6911148008
	for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2009 11:49:26 +0100 (CET)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ejNdkh-5o7s2 for <linux-wireless@vger.kernel.org>;
	Thu,  3 Dec 2009 11:49:26 +0100 (CET)
Received: from lin01.mn-solutions.de (pD95FAAA4.dip0.t-ipconnect.de [217.95.170.164])
	by mx51.mymxserver.com (Postfix) with ESMTP id 66E78148005
	for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2009 11:49:25 +0100 (CET)
Received: from schurig.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id E9FC11E0010
	for <linux-wireless@vger.kernel.org>; Thu,  3 Dec 2009 11:49:20 +0100 (CET)
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: question regarding cfg80211 monitor modes
Date: Thu, 3 Dec 2009 11:48:46 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200912031148.46934.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"iw wlan0 set type monitor" allows the following flags:

                none:     no special flags
                fcsfail:  show frames with FCS errors
                control:  show control frames
                otherbss: show frames from other BSSes
                cook:     use cooked mode

However, I don't know how to map them to the Libertas' firmware 
flags, which has

Libertas (bits can be ored)
Data frames                   0x01   
Mgmt frames but beacons       0x02
Beacons                       0x04


So I guess that the following could be a translation table:

none       0x00
fcsfail    -ENOTSUPP
control    0x02 | 0x04

But what should "otherbss" and "cook" be?

-- 
http://www.holgerschurig.de
