Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa01-05.prod.phx3.secureserver.net ([72.167.82.85]:55794
	"HELO p3plsmtpa01-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751384Ab1AXU6j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:58:39 -0500
Message-ID: <38B8E33D2F114AFCAF7F0F4C591983BD@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: <linux-wireless@vger.kernel.org>
Subject: problem calling the supplicant
Date: Mon, 24 Jan 2011 15:57:55 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have found a problem that is causing my communication with the supplicant 
to get confused. I call the supplicant via wpa_ctrl_request(). Sometimes the 
commands actually timeout. When that happens, the call to select() returns 0 
which causes the wpa_ctrl_request to return -2. From then onward, the 
response to all commands is the actual response to the previous command. 
That causes my state machine to fail. What should I be doing when this 
timeout situation occurs? It looks like I could simply make a subsequent 
call into the ctrl_request with a NULL command (with length == 0) to get it 
to execute the select() again, though I may want to modify 
wpa_ctrl_request() to skip the send() if there is a NULL command. I know 
that my missing response will ultimately be returned. Has anyone else seen 
anything like this?

Thank you,
Chuck Crisler 

