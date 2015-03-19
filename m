Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:35182 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbbCSKOC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 06:14:02 -0400
Received: by wibdy8 with SMTP id dy8so113285524wib.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2015 03:14:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r3sljpsa.fsf@kamboji.qca.qualcomm.com>
References: <1426066382-481-1-git-send-email-rmanohar@qti.qualcomm.com>
	<878uetl7cn.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmcdiy3u8cvYYRueSoQxGzYf9Suf4dy8HpLG6UaQzJzZQ@mail.gmail.com>
	<87r3sljpsa.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 19 Mar 2015 11:14:00 +0100
Message-ID: <CA+BoTQkZ-dZUq0Uqy0uAUNxzz0uZtWB4sWwsZod3Wysn_a_YoQ@mail.gmail.com> (sfid-20150319_111407_496525_357EF256)
Subject: Re: [PATCH] ath10k: fix htt t2h message conflicts among firmware revisions
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 March 2015 at 10:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>>> When I was adding WMI_OP_VERSION, my idea was that we will add similar
>>> version for HTT as well once we need it. But I guess this is good enough
>>> for now, we can add HTT_OP_VERSION later if more changes are needed.
>>
>> Maybe it should be renamed to OP_VERSION (drop the WMI_) or BRANCH_ID
>> or something else?
>>
>> It's not like HTT wasn't diverging. It was. However only WMI ABI was
>> seeing major breakage that needed taking care of. HTT changes were
>> small enough and could be ignored until now.
>
> I'm a bit worried that having one id for everything will be more
> difficult to maintain, that's why I created WMI_OP_VERSION in the first
> place. IMHO it's lot cleaner codewise to have one id for WMI interface
> and one id for HTT (eg. HTT_OP_VERSION). What do you think?

Currently both WMI and HTT seem to be developed in tandem within their
own branches. HTT_OP_VERSION would make sense if you assume HTT/WMI
development will be developed in parallel branches.

Would that even make sense from _any_ perspective? Current branching
model seems to be based on per-purpose branching and isolation. The
thinking behind this might be this allows better parallelization of
efforts between teams and tasks. If my assertion is correct then both
master-be-all branching and independent WMI/HTT branching stands in
conflict with the per-purpose branch isolation so a single
OP_VERSION/BRANCH_ID should suffice for ath10k.

With this htt conflict patch WMI_OP_VERSION is already being treated
as OP_VERSION effectively (and thus change the meaning of it).

Would it be much of a problem to re-rename OP_VERSION and introduce
HTT_OP_VERSION later? Hmm..


Michał
