Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:5621 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbZG2LLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 07:11:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 8B6CD3A00F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:11:11 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id La7RfzGL-8AL for <linux-wireless@vger.kernel.org>;
	Wed, 29 Jul 2009 13:11:11 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F9F0B.dip0.t-ipconnect.de [217.95.159.11])
	by mx51.mymxserver.com (Postfix) with ESMTP id 3ECB23A007
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:11:10 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id AE4C31E004F
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 13:10:58 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: BUG: ifdown doesn't notify cfg80211
Date: Wed, 29 Jul 2009 13:10:50 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907291310.50121.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

# iw dev eth1 connect -w MNHS key 0:11111
eth1 (phy #0): connected to 00:13:19:80:da:30
# ifconfig eth1 down
# iw dev eth1 connect -w MNHS key 0:11111
# ifconfig eth1 down
# ifconfig eth1 up
# iw dev eth1 connect -w MNHS key 0:11111
command failed: Operation already in progress (-114)


Only when I do "iw dev eth1 disconnect" can I connect again. 
Shouldn't downing the interface clear the "I'm connected" state?

-- 
http://www.holgerschurig.de
