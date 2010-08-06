Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.cs.tu-berlin.de ([130.149.17.13]:55772 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933433Ab0HFSsA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 14:48:00 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost-12225.cs.tu-berlin.de (Postfix) with ESMTP id 63DD538FF9
	for <linux-wireless@vger.kernel.org>; Fri,  6 Aug 2010 20:47:56 +0200 (CEST)
Received: from mailhost.cs.tu-berlin.de ([127.0.0.1])
	by localhost (mail.cs.tu-berlin.de [127.0.0.1]) (amavisd-new, port 12224)
	with ESMTP id HDNPvaUtqyOq 18490-07
	for <linux-wireless@vger.kernel.org>;
	Fri,  6 Aug 2010 20:47:45 +0200 (CEST) 17249
Received: from hco-laptop.lan (g231109089.adsl.alicedsl.de [92.231.109.89])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: coskun)
	by mailhost.cs.tu-berlin.de (Postfix) with ESMTPSA
	for <linux-wireless@vger.kernel.org>; Fri,  6 Aug 2010 20:47:45 +0200 (CEST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1081)
Subject: Multiple station interfaces with one wifi card
From: Hakan Coskun <coskun@cs.tu-berlin.de>
In-Reply-To: <7CE373CC-7FCB-41A0-AC81-06E9893D8BC8@cs.tu-berlin.de>
Date: Fri, 6 Aug 2010 20:47:45 +0200
Message-Id: <46641FB7-7BF7-4BFA-9AF2-C1369840FF84@cs.tu-berlin.de>
References: <20100618190319.249D942E2C@repository3.localdomain> <C2473D7F-D624-48C1-A9C5-46678C5CD489@cs.tu-berlin.de> <7CE373CC-7FCB-41A0-AC81-06E9893D8BC8@cs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we are doing research in order to study the behaviour of virtual wifi interfaces with channel switching. After a simulative study, we started to perform some real world experiments with ath9k, which is able to run multiple wiphys on top of a card. This is working quite good. Of course there are several restrictions and performance problems, we are working on some scheduling algorithms to improve the operation.
But now to take it a step further, we plan to go for a mac80211 based virtualization, meaning to run multiple vifs in parallel in station mode. The first step is to run them on the same channel, but as expected this is not working, yet. We can create several interfaces with iw, there is no problem. Even scanning is working, but as soon as we want to connect to an open AP we get into trouble. Authentication and association are not working.
 
mac80211 needs to be extended with additional functionality like ath9k, to cope with multiple associations and channel switching, etc.. The internals of ath9k are clear to us, since the virtualization code is not big, and the patches well documented. We want to adapt them to mac80211, in order allow vifs to connect to APs simultaneously.

How can we track the sequence of operations during the runtime in order to get a better understanding of the mac80211. At the moment, we enabled tracing and debug messages for mac80211, this helps but is not sufficient to follow the functions step by step. We can put a lot of debugging messages into the files, but are there any "best practices" we should follow. 

Thanks,
Hakan