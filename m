Return-Path: <SRS0=ugwx=DQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C5EC433E7
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Oct 2020 23:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BC34222EB
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Oct 2020 23:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602285406;
	bh=l6taX0FCEWeJUtB5xJSPpOswP3JU4Ua+gVwYeASRj70=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=kE+VCkZNSkZKXtzwf+TqeQorcbgStABGZY5EG2YZVl0GheDwi/ELYij5UMvnJw0pi
	 HRt/lAPVKmGW0/SuC0GyAjShEX26q74wpv999mXu2cEKUulsP5/yMxytPU313zry4D
	 GR2BV4Me7gscdvEE+c1y+0dVbTY1VfizM8pBzWHw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgJIXQi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Oct 2020 19:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgJIXQB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Oct 2020 19:16:01 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5981B222EB;
        Fri,  9 Oct 2020 23:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602285360;
        bh=l6taX0FCEWeJUtB5xJSPpOswP3JU4Ua+gVwYeASRj70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xIc7ck5uziWAG/SSx/mh88eb3LlScn3+0DzlM9FJUMXbsTFPZK3r57aJ13AibdtEB
         jPhbQyIZ4yIfHnFBNcrlHeD07F8y7bAnOgX0nBBJez0/1BG9ETEHJrpySjmPDqpld8
         8TztDhpzEvy67xgveMfrjgvJ4Qi30Cq3EIzm8tLo=
Date:   Fri, 9 Oct 2020 16:15:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aleksandr Nogikh <a.nogikh@gmail.com>
Cc:     davem@davemloft.net, johannes@sipsolutions.net,
        edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
Message-ID: <20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007101726.3149375-2-a.nogikh@gmail.com>
References: <20201007101726.3149375-1-a.nogikh@gmail.com>
        <20201007101726.3149375-2-a.nogikh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed,  7 Oct 2020 10:17:25 +0000 Aleksandr Nogikh wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> Remote KCOV coverage collection enables coverage-guided fuzzing of the
> code that is not reachable during normal system call execution. It is
> especially helpful for fuzzing networking subsystems, where it is
> common to perform packet handling in separate work queues even for the
> packets that originated directly from the user space.
> 
> Enable coverage-guided frame injection by adding a kcov_handle
> parameter to sk_buff structure. Initialization in __alloc_skb ensures
> that no socket buffer that was generated during a system call will be
> missed.
> 
> Code that is of interest and that performs packet processing should be
> annotated with kcov_remote_start()/kcov_remote_stop().
> 
> An alternative approach is to determine kcov_handle solely on the
> basis of the device/interface that received the specific socket
> buffer. However, in this case it would be impossible to distinguish
> between packets that originated from normal background network
> processes and those that were intentionally injected from the user
> space.
> 
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Could you use skb_extensions for this?
