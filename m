Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34545 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbcF1Quv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2016 12:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <20160611224708.GC31708@htj.duckdns.org>
References: <20160607200853.GA13742@Karyakshetra> <20160611224708.GC31708@htj.duckdns.org>
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
Date: Tue, 28 Jun 2016 22:20:11 +0530
Message-ID: <CAFNHFT8_4P3h1Ou0PZ6d4tPbJ1ysb5JjPc=NL2GiVO-tUZAp5g@mail.gmail.com> (sfid-20160628_185131_339290_BC683A17)
Subject: Re: [PATCH] libertas_tf: Remove create_workqueue
To: Tejun Heo <tj@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ping!
Thanks,
Bhaktipriya


On Sun, Jun 12, 2016 at 4:17 AM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Jun 08, 2016 at 01:38:53AM +0530, Bhaktipriya Shridhar wrote:
>> alloc_workqueue replaces deprecated create_workqueue().
>>
>> A dedicated workqueue has been used since the workitem (viz
>> &priv->cmd_work per priv, which maps to lbtf_cmd_work) is involved in
>> actual command processing and may be used on a memory reclaim path.
>> The workitems require forward progress under memory pressure and hence,
>> WQ_MEM_RECLAIM has been set. Since there are only a fixed number of work
>> items, explicit concurrency limit is unnecessary here.
>>
>> Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks.
>
> --
> tejun
