Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331A1C4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:27:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB3482082C
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:27:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="oPEWaYZM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730078AbfDBJ1Z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:27:25 -0400
Received: from webmail.newmedia-net.de ([185.84.6.166]:38132 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfDBJ1Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 05:27:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=gfCHKPoATq+7yChXgr9QBMFbNgH2tXYJxWx89PuFJ60=;
        b=oPEWaYZMZLtVHsS2MlPQuCYLrwbBu9AMpYBle6JpfdiRep2O0rFERYcFx2W+t5KyHjw+j/GMVAJfZ6MUeDxMBVuCMUbjryghUsxtmZ90sUK3OQ3tsQgIINEZo/S1qNajggsRjDlZOdaha5bTxfkIgogULDFXRxHiC/Vja+FQHFs=;
Subject: Re: [RFC V3 2/2] ath10k: add tx hw 802.11 encapusaltion offloading
 support
To:     John Crispin <john@phrozen.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <20190401131416.22646-1-john@phrozen.org>
 <20190401131416.22646-3-john@phrozen.org>
 <b7be0488-46ce-f57a-35fd-a00479e0764d@phrozen.org>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <82b5d619-1214-7464-a873-901677b4445e@newmedia-net.de>
Date:   Tue, 2 Apr 2019 11:27:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <b7be0488-46ce-f57a-35fd-a00479e0764d@phrozen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [212.111.244.1] (helo=[172.29.0.186])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1hBFhV-0004Ps-0M; Tue, 02 Apr 2019 11:27:25 +0200
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 01.04.2019 um 16:02 schrieb John Crispin:

>
> On 01/04/2019 15:14, John Crispin wrote:
>> @@ -5185,6 +5214,23 @@ static int ath10k_add_interface(struct 
>> ieee80211_hw *hw,
>>           break;
>>       }
>>   +    switch (vif->type) {
>> +    case NL80211_IFTYPE_AP:
>> +        hw_encap = 1;
>> +        break;
>> +    case NL80211_IFTYPE_STATION:
>> +//        if (!sdata->u.mgd.use_4addr)
>> +            hw_encap = 1;
>> +        break;
>> +    case NL80211_IFTYPE_AP_VLAN:
>> +//        if (!sdata->wdev.use_4addr)
>> +            hw_encap = 1;
>> +        break;
>> +    default:
>> +        break;
>> +    }
>> +    ieee80211_set_hw_80211_encap(vif, ar->ethernetmode & hw_encap);
>> +
>>       /* Using vdev_id as queue number will make it very easy to do 
>> per-vif
>>        * tx queue locking. This shouldn't wrap due to interface 
>> combinations
>>        * but do a modulo for correctness sake and prevent using 
>> offchannel tx
>
> Hi
>
> I am not sure what the best way to handle the 4addr mode is. sdata is 
> part of the subsystem and is not exposed to the drivers.Calling  
> ieee80211_set_hw_80211_encap() from within the driver looked best to 
> me at first glance and would avoid adding an extra op call to figure 
> out if the if encap is supported. Any pointers on what the preferred 
> solution would look like are welcome.
>
>     John

you may do the 4addr check within ieee80211_set_hw_80211_encap, there is 
no need for dealing with that in ath10k or do i miss something?

Sebastian

