Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A954C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 20:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C620B20830
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 20:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="Ay3KaSNB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbfDJUwm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 16:52:42 -0400
Received: from 10.mo69.mail-out.ovh.net ([46.105.73.241]:59005 "EHLO
        10.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfDJUwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 16:52:41 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2019 16:52:39 EDT
Received: from player759.ha.ovh.net (unknown [10.109.160.62])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 811C44C975
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2019 22:46:43 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player759.ha.ovh.net (Postfix) with ESMTPSA id EA0644AA7A2B;
        Wed, 10 Apr 2019 20:46:41 +0000 (UTC)
Subject: Re: [RFC PATCH v3 07/12] iwlwifi: Extended Key ID support (NATIVE)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1554929200;
        bh=9UC8vlH6J60j/4MydAp4o8B5mwJwUbEKU/Qu7t6cf/Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=Ay3KaSNBs/G3lmVnsp1VB0NmyXoZMWhQylw6r8yOGLXsnLtBLPoybpjviDtEBiI/q
         aFMWWeFYVr7ZkOFTfm1GsyI/CJCXvXL/Q+lK5xvM6TKvbQNxb5TxWgy296LF3kvUWn
         pbsUAty7kI+KhN3BlnQIwS7sY9AZRJ/9hulHko1Y=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-8-alexander@wetzel-home.de>
 <1a3b6e515c73a2c185e8dad84ab2ebfd8982a6ce.camel@sipsolutions.net>
 <e84c30de-28d6-7d1b-0fa3-d1ca466e257b@wetzel-home.de>
 <69e6577f90d99289acaa9853fe236e6f15f9e774.camel@sipsolutions.net>
 <14c9d8f7-7cf6-d7e1-a1c0-9f1a10920d4e@wetzel-home.de>
 <ed6e95dad39ef0ac98c62e3acd3f78fd7b3a6d2b.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <185ea9a2-f3c6-04a5-000b-44191da5a0ee@wetzel-home.de>
Date:   Wed, 10 Apr 2019 22:46:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ed6e95dad39ef0ac98c62e3acd3f78fd7b3a6d2b.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6211308315023776967
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudejgdduheegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am 08.04.19 um 22:10 schrieb Johannes Berg:
> On Sun, 2019-02-24 at 14:04 +0100, Alexander Wetzel wrote:
> 
>> Finding a really good sniffer able to also capture A-MPDU frames
>> including control frames would be awesome.
> 
> I think the AC-9260 you have should be a decent sniffer. The (yet
> unreleased) follow-up hardware is even better, but this one is fine.
> 
> Just remember to load with amsdu_size set to the appropriate (maximum)
> A-MSDU size you want to capture.

I did not do that so far... Thanks for that tip!

> 
>> I probably should work on the new AP, but then I always wanted to test
>> coreboot and finding out my notebook is now supported is too alluring to
>> resist;-)
> 
> :-)
> 

I've got a new test system in the meantime and have it up and running as 
a simple test AP with Extended Key ID. I suspect I'll should tune the 
antennas (and probably also the card) based on the first test spins, but 
it's good enough for the moment.

>>> I think they all should just be made to work in native mode, the
>>> firmware basically supports this as you found, there must be some small
>>> bugs.
>>
>> Agree. And with your statements that it already should work and the
>> option to get ucode updates I like our chances:-) With some luck it
>> could even work and I made some error the first time. I'll give that a
>> second look with what I have at hand soon. But after bombing you with
>> mails for what feels like most of the weekend I'll postpone that for now:-)
> 
> I was looking at the firmware now and ... well, I want to really test
> this to understand what's going wrong, because it really *looks* like
> even the recent ones should be supported natively, at least as far as
> I've looked now.
> 

my new test AP came with a Intel AC-3168, which seems to use only one 
antenna, potentially also explaining my fist impression that it's a 
worse card for sniffing than my old Ultimate-N 6300. But it looks like 
it's acting exactly the same in my other iwlmvm test. So I actually 
started to run some tests and started writing a mail. It's so far 
inconclusive and I want to verify the packets on the air next. Something 
is off here and I want to look at that again from scratch, including an 
external sniffer.

That said here what I've got so far and some fresh captures.

It looks like my (new) Wireless-AC 3168NGW (firmware 29.1044073957.0) 
does not have the new key ready for Rx when needed. I have a roughly 5 - 
15 ms long window where the card scrambles received packets using the 
new key. (Note: I can't replicate that at the moment. May be wrong!)
I first suspected the card "cleared" the new key for usage a bit too 
soon and tried to verify that by waiting a bit after installing a key to 
the HW. But it looks like it's not so simple...

I've added a 40 ms delay in the mvm driver after the call to 
iwl_mvm_set_sta_key() and it first looked like that improved the 
situation. So I moved the sleep to iwl_trans_send_cmd() behind 
send_cmd() when not being in CMD_ASYNC but I can't see any any 
differences any longer. At the moment (with the new test setup) I always 
get one corrupted frame when downloading from the AP. Always the first 
frame using the new key...

As for the test procedure: I just add a monitor interface in parallel to 
the "normal" interface on the AP. With HW encryption enabled we should 
only get cleartext packets and don't have to worry about encrypted 
packets in our capture at all:
   iw phy phy0 interface add mon0 type monitor
   ip link set up dev mon0
And start a capture in the interface:
   tcpdump -pi mon0 -s0 -w /tmp/AP.cap

I've just uploaded some captures for you to 
https://www.awhome.eu/index.php/s/AJJXBLsZmzHdxpX also. I've enabled 
swcrypto on the client for the first two and enabled HW crypto on the 
client again for the third and forth.

AP-40ms.pcap.gz
	delay hack as outlined above on the AP
AP-no-delay.cap.gz
	no hack (just some useless printks)
AP-no-delay-client-HW-crypt.cap.gz
	same as above, only cleint using HW crypto
AP-upload-no-delay-HW-crypt.cap.gz
	same as previous, only uploading instead of downloading.
	(and too many broken packets on receive, indicating a bad
	reception/sniffer card)

In all captures I have a normal (1s) ping running to the AP from the 
cleint and start a download from an internal server after a while.

You can e.g. find the "corrupted" looking frames with the wireshark filter
"(wlan.fc.type_subtype == 0x0028) && !(llc.dsap == 0xaa)"

Each capture here only has exactly one, the very first packet using the 
new key.

I'll plane to look deeper here, but that is as far as I got so far.

When you look at the captures keep in mind that both the client and the 
AP also have the two not merged patches applied. But I do not see how 
that makes a difference here.


>> As mentioned above I'm currently aiming for two or three Intel AC-9260
>> cards for the next development round. It's seems to be the most modern
>> card and the price difference between the cards is irrelevant compared
>> to both efforts and costs to get the cards working in two or three
>> devices. If you thing another card would be better for development I'll
>> just use that one instead...
> 
> AC-9260 should be fine, as far as Intel is concerned. Also make for good
> sniffers, in my experience, we use them all the time for that.

Guess I will have to get one for my AP soon at least:-)

Alexander
