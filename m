Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:33615 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaC1O27 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 10:28:59 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v5] ath10k: implement per-VDEV FW statistics
References: <20140328132849.31620.78501.stgit@potku.adurom.net>
	<CA+BoTQmqf8kryKEeD00P6o+N7C+980pEqHnT9qe4H4cjZ+eb=w@mail.gmail.com>
	<87wqfev2ml.fsf@kamboji.qca.qualcomm.com>
	<CAEFj985Xq-_QRmdOsFKEM0kA40TpgKL6t1DW8yXSPY6dn=R2LA@mail.gmail.com>
Date: Fri, 28 Mar 2014 16:28:53 +0200
In-Reply-To: <CAEFj985Xq-_QRmdOsFKEM0kA40TpgKL6t1DW8yXSPY6dn=R2LA@mail.gmail.com>
	(Yeoh Chun-Yeow's message of "Fri, 28 Mar 2014 22:24:33 +0800")
Message-ID: <87siq2v1lm.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_152902_719397_76E2F4D0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yeoh Chun-Yeow <yeohchunyeow@gmail.com> writes:

> On Fri, Mar 28, 2014 at 10:06 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Michal Kazior <michal.kazior@tieto.com> writes:
>>
>>> On 28 March 2014 14:28, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>>>> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>>>>
>>>> The WMI_REQUEST_PEER_STAT command with latest (999.999.0.716) FW
>>>> can return per-VDEV statistics. Using debugfs we can fetch this info now.
>>>>
>>>> This is a backward compatible change. In case of older FW the VDEV
>>>> statistics are simply not returned.
>>>>
>>>> kvalo: remove struct wmi_peer_stats_common cast from
>>>> ath10k_debug_read_target_stats()
>>>
>>> I just glanced over the patch and I don't think this is correct.
>>>
>>> Firmware 10.1.467 has peer_rx_rate but doesn't seem to have vdev stats.
>>
>> Ok, I need to take a closer look at this. If someone else wants to look
>> at this instead, feel free to do that :)
>>
> I up two AP interfaces in same physical but not able to see two
> different vdev in get stats.

That's because the firmware image have doesn't have the feature bit set.

-- 
Kalle Valo
