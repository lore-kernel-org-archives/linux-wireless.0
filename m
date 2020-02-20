Return-Path: <SRS0=UygI=4I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A22BBC11D0C
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Feb 2020 17:20:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C6D024672
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Feb 2020 17:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=dd-wrt.com header.i=@dd-wrt.com header.b="flIuMP91"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgBTRUs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:20:48 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:53073 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726959AbgBTRUs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Feb 2020 12:20:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=dd-wrt.com; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject; bh=pLg11MpBdtv80mP5P7vLIVBzKAWjn0k1OQfLluRsXzs=;
        b=flIuMP91ySCNDrb6Jjf0UlpO21LpiZivv1h4UiFpNplGZ9EZBuD7XnOH905fA7WUfsIiFuBreirIh6jkhY5230Y68cj3+ySXZ/ufImDzQ2feAgWiCCSJveDhEydFGm+dOM5yIASmEOgGawcsf7ni3SHWcprB+6LLZhGIUgeSFi0=;
Subject: Re: [PATCH 5/5] mt76: enable Airtime Queue Limit support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
References: <20200127181754.2810-1-nbd@nbd.name>
 <20200127181754.2810-5-nbd@nbd.name> <875zgqfoqu.fsf@toke.dk>
 <aca37dcb-c76d-d239-0d0e-61b73afc5d8f@dd-wrt.com> <87lfoyw71d.fsf@toke.dk>
From:   Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <02e9c960-44ba-c879-be65-d9a9a840543d@dd-wrt.com>
Date:   Thu, 20 Feb 2020 18:20:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <87lfoyw71d.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [2a01:7700:8040:a100:c145:97bf:237a:a332]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@dd-wrt.com>)
        id 1j4pSl-0002KY-Qj; Thu, 20 Feb 2020 18:18:11 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

the interface is bridged to a bridge named br0 and owns the local lan ip.
its a typical setup. lan switch is bridged together with ap interface
iperf was not running on the device itself needs to be mentioned. i was 
running iperf -s on a device which was  connected by ethernet to this 
device.
my client was a simple lenovo p52 laptop with a iwlwifi 9560 card wich 
was using iperf -c x.x.x.x -P 32 -i 1

Am 19.02.2020 um 23:23 schrieb Toke Høiland-Jørgensen:
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> nope (iperf3 with 32 parallel streams after 5 seconds of running)
>>
>> STA 30:24:32💿f9:c4 AC 2 txq pending airtime underflow: 4294967208, 88
>> Modules linked in: fast_classifier mt7615e mt76 mac80211 compat
>> CPU: 3 PID: 1890 Comm: hostapd Not tainted 4.14.171 #187
>> Stack : 00000000 00000001 00000040 8007e454 80490000 8048bc8c 80610000
>> 805aee78
>>           8058850c 8770b864 870f289c 805f07a7 80582204 00000001 8770b808
>> 805f60a8
>>           00000000 00000000 80650000 00000000 81147bb8 0000011e 00000007
>> 00000000
>>           00000000 80660000 80660000 68203a6d 80000000 80610000 00000000
>> 873079ec
>>           873a4654 00000775 00000000 00000001 00000000 80230b88 0000000c
>> 8065000c
>>           ...
>> Call Trace:
>> [<800153a0>] show_stack+0x58/0x100
>> [<80438c54>] dump_stack+0xa4/0xe0
>> [<80035050>] __warn+0xe4/0x144
>> [<80034c8c>] warn_slowpath_fmt+0x30/0x3c
>> [<873079ec>] _616+0x110/0x214 [mac80211]
>> [<87301ce0>] _535+0x15c/0x4f8 [mac80211]
>> [<804224f0>] br_handle_frame_finish+0x4e0/0x524
>> [<873d5160>] _49+0x50/0xa4 [mt76]
>> [<87606e30>] _61+0x1e8/0x224 [mt7615e]
> Huh, why is there a bridge function name in there in the middle of the
> callstack?
>
> -Toke
>
>
