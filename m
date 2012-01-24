Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:60620 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab2AXV4U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 16:56:20 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RpoLh-0005sV-9c
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 22:56:17 +0100
Received: from localhost ([::1]:57892 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RpoLh-00005M-5L
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 22:56:17 +0100
Received: from [195.4.92.21] (port=55768 helo=11.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RpoIb-0006pJ-4c
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 22:53:05 +0100
Received: from [2002:4fde:916:2:5054:ff:feb8:40bd] (port=48114 helo=mail.maya.org)
	by 11.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RpoIa-0000mM-Mu
	for linux-wireless@vger.kernel.org; Tue, 24 Jan 2012 22:53:05 +0100
Message-ID: <4F1F2837.5090307@maya.org> (sfid-20120124_225624_236872_01C564FD)
Date: Tue, 24 Jan 2012 22:52:55 +0100
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k get's completely knocked out by rt3572 device
References: <4F1EF618.6080108@01019freenet.de> <13411135.eH6opTgxBo@helmutmobil.site>
In-Reply-To: <13411135.eH6opTgxBo@helmutmobil.site>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
> Am Dienstag, 24. Januar 2012, 19:19:04 schrieb Andreas Hartmann:
>> - At the moment of stopping netperf on rt3572, the ath9k device
>> instantly started sending / receiving data again as expected.
> [...]
>> Does anybody has an idea what could cause this situation? Or is this normal?
> 
> Your netperf traffic is in the direction STA -> AP or also in the other
> direction?

In both directions (serially). It's a script, which does the following:

while true
do
	netperf -H host -t TCP_STREAM 	 # (STA -> AP)
	netperf -H host -t TCP_MAERTS    # (AP -> STA)
	netperf -H host -t TCP_SENDFILE  # (STA -> AP)
done


Andreas
