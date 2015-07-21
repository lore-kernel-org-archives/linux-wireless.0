Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42244 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbbGUP4N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 11:56:13 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <maninder1.s@samsung.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	PANKAJ MISHRA <pankaj.m@samsung.com>
Subject: Re: [PATCH 1/1] ath10k: fixing wrong initialization of struct channel
References: <1785807958.195941437479984203.JavaMail.weblogic@epmlwas04a>
Date: Tue, 21 Jul 2015 18:56:05 +0300
In-Reply-To: <1785807958.195941437479984203.JavaMail.weblogic@epmlwas04a>
	(Maninder Singh's message of "Tue, 21 Jul 2015 11:59:44 +0000")
Message-ID: <87bnf5mrmy.fsf@kamboji.qca.qualcomm.com> (sfid-20150721_175631_694961_7FDA3142)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maninder Singh <maninder1.s@samsung.com> writes:

>>> chandef is initialized with NULL and on the very next line,
>>> we are using it to get channel, which is not correct.
>>>
>>> channel should be initialized after obtaining chandef.
>>>
>>> Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
>
>>How did you find this bug?
>
> Static anlysis reports this bug like coverity or any other static tool like cppcheck :-
>
> drivers/net/wireless/ath/ath10k/mac.c:839]: (error) Possible null pointer dereference: chandef

Thanks. This is always good to add to the commit log so I did that:

    ath10k: fix wrong initialization of struct channel
    
    chandef is initialized with NULL and on the very next line, we are using it to
    get channel, which is not correct. Channel should be initialized after
    obtaining chandef.
    
    Found by cppcheck:
    
    ath/ath10k/mac.c:839]: (error) Possible null pointer dereference: chandef
    
    Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>


-- 
Kalle Valo
