Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:8238 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZI2NS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 09:18:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 078584B00C
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 15:19:03 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bohyx9kKNOqO for <linux-wireless@vger.kernel.org>;
	Tue, 29 Sep 2009 15:19:02 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F93E5.dip0.t-ipconnect.de [217.95.147.229])
	by mx51.mymxserver.com (Postfix) with ESMTP id D2F8B4B024
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 15:19:01 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 424751E004F
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 15:18:48 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: scan_request->nr_ssids never 0 ?
Date: Tue, 29 Sep 2009 15:18:46 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909291518.46655.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Even when I do an "iw xxx scan trigger", scan_request->nr_ssids 
is always 1 in my driver.

Is this a bug or a feature?



However, scan_request->ssids[0].ssid_len is 0.

So to ask my firmware for an SSID scan, I need to do 

 if (req->n_ssids && req->ssid[0].ssid_len)

instead of simply

 if (req->n_ssids)

-- 
http://www.holgerschurig.de
