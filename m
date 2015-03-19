Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:35157 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbCSIkl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 04:40:41 -0400
Received: by wgdm6 with SMTP id m6so56002892wgd.2
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2015 01:40:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <878uetl7cn.fsf@kamboji.qca.qualcomm.com>
References: <1426066382-481-1-git-send-email-rmanohar@qti.qualcomm.com>
	<878uetl7cn.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 19 Mar 2015 09:40:39 +0100
Message-ID: <CA+BoTQmcdiy3u8cvYYRueSoQxGzYf9Suf4dy8HpLG6UaQzJzZQ@mail.gmail.com> (sfid-20150319_094047_467117_1C4B2033)
Subject: Re: [PATCH] ath10k: fix htt t2h message conflicts among firmware revisions
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 March 2015 at 09:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
>
>> Target to host HTT messages are conflicting between 10.x and other
>> firmware revisions. By maintaining separate HTT T2H tables for each
>> firmware revisions (main, 10x and tlv) similar to WMI abstraction,
>> solves the conflicts.
>>
>> Cc: Michal Kazior <michal.kazior@tieto.com>
>> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
>
> So this is needed to get managements frames over HTT working, right?
> It's good to mention that in the commit log, does this look ok:
>
> Author: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> Date:   Wed Mar 11 15:03:02 2015 +0530
>
>     ath10k: fix htt t2h message conflicts among firmware revisions
>
>     Target to host HTT messages are conflicting between 10.x and other
>     firmware revisions. By maintaining separate HTT T2H tables for each
>     firmware revisions (main, 10x and tlv) similar to WMI abstraction,
>     solves the conflicts.
>
>     This fix is needed to get management frames over HTT (ie.
>     ATH10K_FW_FEATURE_HAS_WMI_MGMT_TX disabled) working with 10.2.4.48-2 firmware.
>     Otherwise there will be unknown htt events and nothing works:
>
>     [30087.438343] ath10k_pci 0000:02:00.0: htt event (19) not handled
>     [30087.448691] ath10k_pci 0000:02:00.0: htt event (19) not handled
>     [30149.032974] ath10k_pci 0000:02:00.0: htt event (19) not handled
[...]
>
> When I was adding WMI_OP_VERSION, my idea was that we will add similar
> version for HTT as well once we need it. But I guess this is good enough
> for now, we can add HTT_OP_VERSION later if more changes are needed.

Maybe it should be renamed to OP_VERSION (drop the WMI_) or BRANCH_ID
or something else?

It's not like HTT wasn't diverging. It was. However only WMI ABI was
seeing major breakage that needed taking care of. HTT changes were
small enough and could be ignored until now.

Perhaps the rename could be accompanied by FW API bump to 5?


Michał
