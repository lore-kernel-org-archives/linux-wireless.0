Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A96C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B497D216FA
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F6uP+3pa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F6uP+3pa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B497D216FA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbeI1QHP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 12:07:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbeI1QHP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 12:07:15 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB65560274; Fri, 28 Sep 2018 09:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538127859;
        bh=ZPRI8yQpZjCyHxkpuas/KeMPtPoWnO1lSpftX03QE+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F6uP+3pawFrnJ2kbaUJNvDpbUtLgD3MUVRjSz+2w7G9R8T/vJZ/F18YrcGWoT7DLw
         LoqL0pCQM8rj354cUsg4lFKzRyGaWRniU2P3gNW0KeJksqh4wrYAXAfaVNdflix989
         8wk4/9R2i3C3uK14Em+HZi4Td7zXz+Fg1aPSO3io=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3E2AC60274;
        Fri, 28 Sep 2018 09:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538127859;
        bh=ZPRI8yQpZjCyHxkpuas/KeMPtPoWnO1lSpftX03QE+E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F6uP+3pawFrnJ2kbaUJNvDpbUtLgD3MUVRjSz+2w7G9R8T/vJZ/F18YrcGWoT7DLw
         LoqL0pCQM8rj354cUsg4lFKzRyGaWRniU2P3gNW0KeJksqh4wrYAXAfaVNdflix989
         8wk4/9R2i3C3uK14Em+HZi4Td7zXz+Fg1aPSO3io=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Sep 2018 02:44:19 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
 <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org>
Message-ID: <f420dade85ee627e861bd43132c84ade@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-28 02:27, Rajkumar Manoharan wrote:
> On 2018-09-28 00:51, Toke Høiland-Jørgensen wrote:
>> On 28 September 2018 07:29:03 CEST, Rajkumar Manoharan
>> <rmanohar@codeaurora.org> wrote:
>>> On 2018-09-26 17:09, Rajkumar Manoharan wrote:
>>>> On 2018-09-26 02:22, Toke Høiland-Jørgensen wrote:
>>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>> 
>>>> :( Yeah... I got confused with attached soft lockup in ARM platform.
>>>> 
>>> Toke,
>>> 
>>> Cause for the soft lockup exposed in multi client scenario is due to
>>> mixed order of fq_lock and active_txqs_lock. In wake_tx_queue or
>>> push_pending
>>> case, driver acquires active_txq_lock first by schedule_start and
>>> followed by
>>> fq_lock in tx_dequeue. The same order should be maintained in sta
>>> cleanup.
>>> Below change fixed the issue.
>> 
>> Ah, great find! I'll fold this into the next version, thanks!
>> 
> 
> One more thing. As I mentioned earlier, scheduling wake_txqs_tasklet
> is heavy load and causing random rcu stall issue. Hence I added
> another API to schedule throttled txqs once for all. Also I did
> a cleanup in kick_airtime by traversing list only once. With these
> changes I don't see rcu stall issue. Please review and fold them as 
> well.
> 
Correction in patch. new API schedule kick_aitime tasklet not 
wake_txq_tasklet.

+void ieee80211_txq_schedule_throttled(struct ieee80211_hw *hw)
+{
+       struct ieee80211_local *local = hw_to_local(hw);
+
+       tasklet_schedule(&local->kick_airtime);
+}

-Rajkumar
