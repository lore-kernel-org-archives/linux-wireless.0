Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41739 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbbCSJcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 05:32:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix htt t2h message conflicts among firmware revisions
References: <1426066382-481-1-git-send-email-rmanohar@qti.qualcomm.com>
	<878uetl7cn.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmcdiy3u8cvYYRueSoQxGzYf9Suf4dy8HpLG6UaQzJzZQ@mail.gmail.com>
Date: Thu, 19 Mar 2015 11:32:37 +0200
In-Reply-To: <CA+BoTQmcdiy3u8cvYYRueSoQxGzYf9Suf4dy8HpLG6UaQzJzZQ@mail.gmail.com>
	(Michal Kazior's message of "Thu, 19 Mar 2015 09:40:39 +0100")
Message-ID: <87r3sljpsa.fsf@kamboji.qca.qualcomm.com> (sfid-20150319_103251_207213_1DD8FD0C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

>> When I was adding WMI_OP_VERSION, my idea was that we will add similar
>> version for HTT as well once we need it. But I guess this is good enough
>> for now, we can add HTT_OP_VERSION later if more changes are needed.
>
> Maybe it should be renamed to OP_VERSION (drop the WMI_) or BRANCH_ID
> or something else?
>
> It's not like HTT wasn't diverging. It was. However only WMI ABI was
> seeing major breakage that needed taking care of. HTT changes were
> small enough and could be ignored until now.

I'm a bit worried that having one id for everything will be more
difficult to maintain, that's why I created WMI_OP_VERSION in the first
place. IMHO it's lot cleaner codewise to have one id for WMI interface
and one id for HTT (eg. HTT_OP_VERSION). What do you think?

> Perhaps the rename could be accompanied by FW API bump to 5?

Maybe not the rename, but yeah, something should be decided before the
bump up.

-- 
Kalle Valo
