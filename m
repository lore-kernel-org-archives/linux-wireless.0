Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.mandriva.com ([212.85.150.183]:34370 "EHLO mx1.mandriva.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbXKFPsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 10:48:52 -0500
Received: from perninha.conectiva.com.br (perninha.conectiva.com.br [200.140.247.100])
	by mx1.mandriva.com (Postfix) with ESMTP id A24021F0073
	for <linux-wireless@vger.kernel.org>; Tue,  6 Nov 2007 16:23:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 3FFAE182B4
	for <linux-wireless@vger.kernel.org>; Tue,  6 Nov 2007 13:23:25 -0200 (BRST)
Received: from perninha.conectiva.com.br ([127.0.0.1])
	by localhost (perninha.conectiva.com.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id wi33pFk5bdKO for <linux-wireless@vger.kernel.org>;
	Tue,  6 Nov 2007 13:23:21 -0200 (BRST)
Received: from dhcp207.conectiva (dhcp207.conectiva [10.0.4.207])
	by perninha.conectiva.com.br (Postfix) with ESMTP id 722E8182B1
	for <linux-wireless@vger.kernel.org>; Tue,  6 Nov 2007 13:23:21 -0200 (BRST)
From: Claudio Matsuoka <claudio@mandriva.com>
To: linux-wireless@vger.kernel.org
Subject: RTL8187 rate control problems
Date: Tue, 6 Nov 2007 13:23:16 -0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200711061323.16302.claudio@mandriva.com> (sfid-20071106_154855_966285_28AAB0E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been reported a problem with RTL8187 working only at very close ranges 
(4-5m) in Linux while the same hardware works at much higher distances in 
Windows. Investigating the problem, I found that it's caused by the mac80211 
rate control incrementing the bit rate to 54M and never going down because 
the fail counter stays at zero. What would be a good way to check 
transmission retries or failures in the RTL8187 to prevent this problem? Is 
it possible to have a retry count sent to the tx callback so 
status->retry_count could be set accordingly?   
