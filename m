Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa01-03.prod.phx3.secureserver.net ([72.167.82.83]:60450
	"HELO p3plsmtpa01-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759864Ab0I0RQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 13:16:39 -0400
Message-ID: <58E3CFACA7054DC48245C67E9D4AE07B@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: <linux-wireless@vger.kernel.org>
Subject: memory leak in scan with 9170?
Date: Mon, 27 Sep 2010 13:16:30 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have modified my code that is using a 9170. I am really concerned about 
roaming and so am testing that pretty hard. Yesterday I had a loop that 
forced a DISCONNECT followed by a REASSOCIATE every 30 seconds. After 
between 1:30 and 1:40 it failed by no longer receiving scan results. When I 
looked into a log, the very last scan results that I received had a reduced 
number of BSSs, down from 10-12 per scan to 4, then the next scan was zero. 
It never recovered. All scans always failed to return any results from then 
on and, of course, the re-associate failed. This 'feels' to me like a memory 
leak somewhere, either in the firmware or the driver. I am running the 
2.6.31 kernel/driver and the dual file firmware and version 0.6.10 of the 
supplicant. At the moment I am running another test where it roams every 60 
seconds rather than 30 seconds to see what kind of difference that makes. I 
know that my kernel is old, but for now I don't have a choice. Does anyone 
have any experience like this or insight into this new problem? This is an 
embedded device that doesn't have the memory of a PC. Is there some way that 
I could instrument something to check this?

Thank you,
Chuck 

