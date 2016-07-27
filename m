Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.tech.triadic.us ([98.102.61.98]:42802 "EHLO
	SMTP.Tech.Triadic.US" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbcG0SO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2016 14:14:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 27 Jul 2016 14:04:06 -0400
From: alexmcwhirter@triadic.us
To: Alan Curry <rlwinm@sdf.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: network data corruption (bisected to e5a4b0bb803b)
In-Reply-To: <201607271032.u6RAWPcS008174@sdf.org>
References: <201607271032.u6RAWPcS008174@sdf.org>
Message-ID: <4dbfebe8136bc963b5b51463d6887db4@triadic.us> (sfid-20160727_201533_426683_96B5B92A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just to add some more information to this, the corruption seems to 
effect ssh as well.

Using a sun hme interface, occasionally upon an ssh connection it will 
refuse to authenticate a client with either password or cert 
authentication. Using wireshark to capture and decrypt the packets 
between the two machines, the data coming from the server seems good, 
but the data received by the server from the client is essentially 
garbage. Note that the client is sending valid data, but the server is 
corrupting it upon receipt. Closing the connection and starting a new 
one will remedy the login issue, but you do occasionally see corruption 
on the server side sporadically.

So far this only seems to occur on incoming data, outgoing data seems 
fine.
