Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08290C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C98D22147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:19:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XR1Uckv3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GHk+71OC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfBGOTR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:19:17 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbfBGOTR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:19:17 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C2CF6605FC; Thu,  7 Feb 2019 14:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549549155;
        bh=u2brZnxSuy2o+fZphCydE9YIYBZZCzZrw4n/EL9aDZw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=XR1Uckv32uRHm8HJy2R1aJ6D+BQdhLeppi1VKpQkL79W483zCb5P3TyCuQKRQrEIO
         FWZ7abbR/TzJqd9j0sxAfwqeDMk8c5I2d/SI3blvh1lX63GqMfhr0C2N6A6Tk8oG2e
         FOqzRfiYYkejB6CE1H99Fl7VMPxH+K6tlRCn+ZZw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 25B8F6047C;
        Thu,  7 Feb 2019 14:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549549154;
        bh=u2brZnxSuy2o+fZphCydE9YIYBZZCzZrw4n/EL9aDZw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=GHk+71OCCx4PXMham0K4kQ/MLnHFlj/jxgpu8LQBS2MKcox9M7ra7X+SRuxyN6Xsc
         AnwjZxMpZ2R+GLvGkwY0Q0WO0esU/CaH+sVK7eJXbKGJa3fqUqgfLm/Tqr4okv3uaa
         1e+/ehdkhsmExJ4F+iPs/VAR5tDRm9H969X88l7Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 25B8F6047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Mathias Kresin <dev@kresin.me>,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath10k: implement set_base_macaddr to fix rx-bssid mask in multiple APs conf
References: <20190114153558.972-1-chunkeey@gmail.com>
        <87tvhjd0c7.fsf@kamboji.qca.qualcomm.com>
        <4891660.4ehrp1WKpm@debian64>
Date:   Thu, 07 Feb 2019 16:19:10 +0200
In-Reply-To: <4891660.4ehrp1WKpm@debian64> (Christian Lamparter's message of
        "Mon, 04 Feb 2019 19:10:38 +0100")
Message-ID: <87womb8yw1.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christian Lamparter <chunkeey@gmail.com> writes:

> On Monday, February 4, 2019 4:45:12 PM CET Kalle Valo wrote:
>> Christian Lamparter <chunkeey@gmail.com> writes:
>> 
>> > @@ -8885,6 +8904,7 @@ static const struct wmi_ops wmi_ops = {
>> >  
>> >  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>> >  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
>> > +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>> >  	.gen_pdev_set_rd = ath10k_wmi_op_gen_pdev_set_rd,
>> >  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>> >  	.gen_init = ath10k_wmi_op_gen_init,
>> > @@ -8960,6 +8980,7 @@ static const struct wmi_ops wmi_10_1_ops = {
>> >  
>> >  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>> >  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
>> > +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>> >  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>> >  	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
>> >  	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
>> > @@ -9032,6 +9053,7 @@ static const struct wmi_ops wmi_10_2_ops = {
>> >  
>> >  	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
>> >  	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
>> > +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>> >  	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
>> >  	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
>> >  	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
>> 
>> These are in practise obsolete WMI interfaces so not sure if it makes it
>> worth to support this parameter in them. But on the other hand it won't
>> hurt either, so dunno.
>
> Ok. I looked what firmware interfaces (wmi_cmd_map) supported the 
> pdev_set_base_macaddr_cmdid and all did (including the old and tlv)
> so I added the line everywhere I could.
> As far as the support for the old firmwares goes: I don't think
> anybody with a current ath10k is willingly still stuck on the 10.1,
> 10.2 firmware. So, I might as well just remove those for 10_2, 10_1 and MAIN. 

Yeah, that's the best. BTW I'm planning (or better hoping) to remove
10.1, 10.2 and main WMI interfaces altogether. They are just making
these unnecessary complex.

>> > @@ -9115,6 +9137,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
>> >  	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
>> >  	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
>> >  	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
>> > +	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
>> >  	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
>> >  	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
>> >  	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
>> 
>> This is only used by QCA988X. Did you test with that? If not, IMHO
>> better not to enable it for 10.2.4 until it's tested.
>
> Yes. I tested it on a CUS-223 with 10.2.4-1.0-00041 and after. I also know
> that Mathias Kresin tested it on his Homehub 5a Router (QCA9880) with both
> ath10k (most likely with the same 10.2.4-1.0-00041) and Ben's ath10k-ct.
>
> Ben also confirmed in the thread that the patch was working fine on his
> R7800 (QCA9984).

Great. And I see that you added that to the commit log in v2 already.

>> > --- a/drivers/net/wireless/ath/ath10k/core.c
>> > +++ b/drivers/net/wireless/ath/ath10k/core.c
>> > @@ -2649,6 +2649,13 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
>> >  		goto err_hif_stop;
>> >  	}
>> >  
>> > +	status = ath10k_wmi_pdev_set_base_macaddr(ar, ar->mac_addr);
>> > +	if (status) {
>> > +		ath10k_err(ar,
>> > +			   "failed to set base mac address: %d\n", status);
>> > +		goto err_hif_stop;
>> > +	}
>> 
>> Oh, and as the new parameter is not supported with WMI TLV interface
>> (QCA6174, WCN3990 etc) this will print an error on those.
>
> This also means that Brian won't be able to test/verify this anyway?
> Should I also drop ath10k_wmi_tlv_op_gen_pdev_set_base_macaddr() then?

Yes, and I see that you already did :)

> Because it won't make sense to have the support function if
> "WMI_TLV_TAG_STRUCT_PDEV_SET_BASE_MACADDR_CMD" is just a dummy in this
> context.
>
>> I think you
>> need to check for -EOPNOTSUPP and then just ignore the error on that
>> case. IIRC we have similar checks elsewhere in ath10k.
>
> Ok, I think I know what you are looking for:
> | if (status && status != -EOPNOTSUPP) { ...

> Yes, this should work.

Yup, this is what I meant.

-- 
Kalle Valo
