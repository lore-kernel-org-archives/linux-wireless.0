Return-Path: <SRS0=UQ4x=7K=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EFF8C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 19:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E00D206A1
	for <linux-wireless@archiver.kernel.org>; Thu, 28 May 2020 19:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=airpost.net header.i=@airpost.net header.b="bsVs2+Fi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="B3q8nhGg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406190AbgE1THO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 May 2020 15:07:14 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:43183 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406108AbgE1THM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 May 2020 15:07:12 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 195CBBA1;
        Thu, 28 May 2020 15:07:12 -0400 (EDT)
Received: from imap2 ([10.202.2.52])
  by compute3.internal (MEProxy); Thu, 28 May 2020 15:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=airpost.net; h=
        mime-version:message-id:in-reply-to:references:date:from:to
        :subject:content-type; s=fm3; bh=PSzxvc8bdtYDwvVcRMmQgP4ScLf43hO
        MQ6KobG2h/Hw=; b=bsVs2+Fi2sQu17tUcI+gSf1+foc8A9kZpTVZQ7s3dHkGO7w
        usOrvi7BBzIYuC4ekWdF86OCXuVyurmQPAIXpbUmhLJK+cy011F4DxEq72JzKToS
        Sao45vlwsuG/VaTe7/1szf4chBWq6jD/2PoFvrU880W5QeBypQMc/sF5SyPedE9M
        X1/FWR39Gsz3vVroqVkX1BVFMRIMlzJZU/pc0GkfMlBEGpQeNpxYnoF2uPKI6VZC
        tqdMOGdAsAty7Q7jv91GBBa1k/0ox9+9zT+v1guIPFwBm2OOChMke6VIZ7yA5qIK
        m8qPfnkAtS0kY6AqpW2Gc8b3/OopRO5tB7JAEeg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PSzxvc
        8bdtYDwvVcRMmQgP4ScLf43hOMQ6KobG2h/Hw=; b=B3q8nhGg/eOAKw36i0tlDA
        skxyU+nuiNZnar6hZhzvIviXxTqoglSIr8saCcM4OMPRmA6RFnbwB4wwePv5uyMT
        23hSud4upxi2GQDj1Lr0UijOBzAHF5sBz6okVoO0rIgbWBzLHOmEW2EDHMoVWlkg
        l7lkcO0RIt1Hd6ZcezoV7FMptfepLKYVrknBuecDTnaWknsKDH2quOncDaA4n67q
        cVba01YF9HJzD9GQkS6aAUuSe+YXSAMeRDcOXZqXzGwUWhgRvN1/+KOuyHdd6rHe
        Xnzlo83PdFnjtQ5HBz9GsC0/oM8PP3l2AdXpmjxvgkoBSEC4Zdb/4iK1c4lK4kVw
        ==
X-ME-Sender: <xms:3wvQXnsai0REy-UtDy8zAcQ8tufU_wyIHIBmSlj3A2BtGMxw0iH12Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddviedgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvffutgesthdtredtreertdenucfhrhhomhepfdeurhhu
    nhhoucffrghnthgrshdfuceofihirhgvlhgvshhssegurghnthgrshdrrghirhhpohhsth
    drnhgvtheqnecuggftrfgrthhtvghrnhepteeukeejvefhgefgvdegfeevfffhleetfeff
    tdduueehudeufeefjedvveegjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepfihirhgvlhgvshhssegurghnthgrshdrrghirhhpohhsthdr
    nhgvth
X-ME-Proxy: <xmx:3wvQXofkXoThqdpjCclnT3_RVeZiZCvInBZtSKKfw9m6IlZUe9nSFA>
    <xmx:3wvQXqzvjFNl-R217IKQxKxId4w1m6uTvZQXPK8R7qSUHRwrpo_R6A>
    <xmx:3wvQXmMAypGE-IlJr9NPG7LNUROFCbaYYnF59QkmHlLqc8NDnJqdbg>
    <xmx:3wvQXqI5eAD8-gT_UhDGgkJ4BdnrUuGvg-b4XbaTV5wzO6-elOPQZQ>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 684EBE00BF; Thu, 28 May 2020 15:07:11 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-dev0-504-g204cd6f-fm-20200527.002-g204cd6f2
Mime-Version: 1.0
Message-Id: <c921f6e0-8b27-475d-9441-28025d5afe83@www.fastmail.com>
In-Reply-To: <6d5994325bbb28ff855b527a26e4e7e87760705f.camel@sipsolutions.net>
References: <afef8a7d-053e-4aaa-ace7-d320c32e8b7c@www.fastmail.com>
 <(sfid-20200528_174911_413757_32DBA783)>
 <a185a4283c1230965b520de52737427c91af9c22.camel@sipsolutions.net>
 <99c4ece3-15ca-42cb-aa09-c86d466d6429@www.fastmail.com>
 <7406af4a9e852d99735e1b1af63deed2f0c5d703.camel@sipsolutions.net>
 <f78191c6-3093-4d97-a959-068dce1da552@www.fastmail.com>
 <6d5994325bbb28ff855b527a26e4e7e87760705f.camel@sipsolutions.net>
Date:   Thu, 28 May 2020 15:06:51 -0400
From:   "Bruno Dantas" <wireless@dantas.airpost.net>
To:     "Johannes Berg" <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: iwlist scanning: how to exclude old scan results from output?
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> That's why 'flush' exists :)
Alas, mine seems to be clogged :)

> Obviously. But still, now I'm wondering if there's a bug?
> What driver are you using?
My adapter is  Atheros AR928X  which uses the  ath9k  driver.

-Bruno
