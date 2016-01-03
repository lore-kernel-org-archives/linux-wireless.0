Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:56578 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbcACMOU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 07:14:20 -0500
Subject: Re: net-libertas: Better exception handling in
 if_spi_host_to_card_worker()
To: Arend van Spriel <aspriel@gmail.com>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686F0B2.5000000@users.sourceforge.net>
 <56870866.7020000@cogentembedded.com>
 <568785B3.5000905@users.sourceforge.net>
 <alpine.DEB.2.02.1601020914100.2063@localhost6.localdomain6>
 <5687939E.7010701@users.sourceforge.net> <5687A2C7.3000704@gmail.com>
 <5687B2BC.8090901@users.sourceforge.net> <5688EBAC.5000701@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5689105B.50005@users.sourceforge.net> (sfid-20160103_131442_403599_27398F0B)
Date: Sun, 3 Jan 2016 13:13:15 +0100
MIME-Version: 1.0
In-Reply-To: <5688EBAC.5000701@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> What the patch tries to do is avoid the extra 'if (err)'.
>>
>> Yes. - I propose to look at related consequences together with the usage
>> of a popular short jump label once more.
> 
> When I read a subject saying "Better exception handling" it sounds like
> a functional improvement. Your change does not change anything
> functionally and may or may not save a bit of execution time depending
> on how smart the compiler is.

Can it eventually matter to skip another condition check in three cases?


> What you change does is confuse people reading the code.

A few software developers might find this proposal unusual.


> So please explain why your update improves exception handling here.
> I don't see it.

How does this feedback fit to the mentioned check avoidance?


> The code is not making the driver more robust against failures

That's true for this update suggestion.


> in this function, which is what I think of reading "better exception handling".

Other implementation details are affected by the shown fine-tuning.

Regards,
Markus
