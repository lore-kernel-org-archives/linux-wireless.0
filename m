Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server75.greatnet.de ([83.133.96.62]:59564 "EHLO
	server75.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3JWJfL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 05:35:11 -0400
Received: from [192.168.0.11] (i577B2BBD.versanet.de [87.123.43.189])
	by server75.greatnet.de (Postfix) with ESMTPA id D634A22AC470
	for <linux-wireless@vger.kernel.org>; Wed, 23 Oct 2013 11:24:49 +0200 (CEST)
Message-ID: <526795E1.90701@crlf.de> (sfid-20131023_113516_301445_D45C2C1C)
Date: Wed, 23 Oct 2013 11:24:49 +0200
From: Dietmar Rudolph <dietmar@crlf.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwl3945 filling kern.log when HW switch is off
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, I hope this is the correct place to put a bug report in. I do 
not subscribe to this mailing list, but feel free to send PM in case 
you need additional info. You shoudn't :-)

After installing Ubuntu 13.10, I noticed kern.log growing faster 
than you could look at. Within a few working hours, kern.log was >6GB!

The reason is that I intentionally disabled WiFi on this laptop by 
turning the HW switch off. However, this makes iwl3945 write a log 
entry into kern.log every few microseconds!

The workaround is to turn the HW switch on. The bug fix would be to 
write just a single line to kern.log.

Regards
Dietmar

- - - from kern.log:

Oct 22 18:28:52 C50 kernel: [  141.144085] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.144214] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.145167] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.145304] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.146184] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.146315] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.147164] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.147304] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.148254] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.148387] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.149217] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.149347] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.150165] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.150294] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.151113] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.151243] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.152097] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch
Oct 22 18:28:52 C50 kernel: [  141.152227] iwl3945 0000:02:00.0: 
Radio disabled by HW RF Kill switch


-- 
Dietmar Rudolph
Geschäftsführer/President

CR/LF GmbH
Obere Fuhr 27, 45136 Essen, Germany
phone: ++49 201 254566
mailto: dietmar@crlf.de, http://www.crlf.de

CR/LF Beratungsgesellschaft für EDV-Anwendungen mbH
Essen HRB 7016 - GF: Dipl.-Math. Dietmar Rudolph
