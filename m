Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9508 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbcBZKAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2016 05:00:51 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@codeaurora.org>
CC: "Oh, Peter" <poh@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v3] ath10k: set MAC timestamp in management Rx frame
Date: Fri, 26 Feb 2016 10:00:35 +0000
Message-ID: <87bn73dc5a.fsf@kamboji.qca.qualcomm.com> (sfid-20160226_110057_732788_1343D82B)
References: <4c705dc7a2c0aa857da4e6eaf6e8ed47c354b9ea.1456351768.git.poh@qca.qualcomm.com>
	<87k2lsd9zv.fsf@kamboji.qca.qualcomm.com>	<56CF4DA3.8030803@codeaurora.org>
In-Reply-To: <56CF4DA3.8030803@codeaurora.org> (Peter Oh's message of "Thu, 25
	Feb 2016 10:53:23 -0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Oh <poh@codeaurora.org> writes:

>> I see new warnings:
>>
>> drivers/net/wireless/ath/ath10k/wmi.c:2199:16: warning: restricted __le32
>> degrades to integer
>> drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted __le32
>> degrades to integer
>> drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: cast to restricted
>> __le32
>> drivers/net/wireless/ath/ath10k/wmi.c:2201:41: warning: restricted __le32
>> degrades to integer
>>
> Do I have a way to run this check before submitting a patch such as
> checkpatch.pl?

I use this script to run checks on ath10k before I apply a patch to
pending branch:

https://github.com/qca/qca-swiss-army-knife/blob/master/tools/scripts/ath10k/ath10k-check

You need to install sparse separately, better to take the latest version
from git:

https://sparse.wiki.kernel.org/index.php/Main_Page

-- 
Kalle Valo