Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35264 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757180AbdELQiD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 12:38:03 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Joe Perches <joe@perches.com>
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        "hwang\@quantenna.com" <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [v6] qtnfmac: introduce new FullMAC driver for Quantenna chipsets
References: <20170511215101.15356-1-igor.mitsyanko.os@quantenna.com>
        <20170512151854.6F16A60953@smtp.codeaurora.org>
        <87shkap0e5.fsf@kamboji.qca.qualcomm.com>
        <1494603783.2028.21.camel@perches.com>
Date: Fri, 12 May 2017 19:37:56 +0300
In-Reply-To: <1494603783.2028.21.camel@perches.com> (Joe Perches's message of
        "Fri, 12 May 2017 08:43:03 -0700")
Message-ID: <87bmqy6nff.fsf@purkki.adurom.net> (sfid-20170512_183806_918738_1C78DE70)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> On Fri, 2017-05-12 at 15:20 +0000, Kalle Valo wrote:
>> Kalle Valo <kvalo@codeaurora.org> writes:
>> Here's the diff between v5 and v6:
>
> trivia:
>
>> diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
> []
>> @@ -93,9 +94,11 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
>>  
>>  	qtnf_scan_done(vif->mac, true);
>>  
>> -	if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
>> -		pr_err("failed to change interface type\n");
>> -		return -EFAULT;
>> +	ret = qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
>> +	if (ret) {
>> +		pr_err("VIF%u.%u: failed to change VIF type: %d\n",
>> +		       vif->mac->macid, vif->vifid, ret);
>
> It might make sense to add vif_<level> macros or functions
> to make sure the vif->mac->macid, vif->vifid are emitted
> consistently and simplify the calls
>
> For instance:
> 		vif_err(vif, "failed to change VIF type %d\n", ret);
>
> etc...

Yeah, I was thinking the same.

> Not necessarily in this patch, maybe in a future one.

Exactly, that's easy to do in a separate patch after the driver is
merged.

-- 
Kalle Valo
