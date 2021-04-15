Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C962BC43460
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Apr 2021 15:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99C096115B
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Apr 2021 15:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbhDOPk6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Apr 2021 11:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhDOPk6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Apr 2021 11:40:58 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F810C061574
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2021 08:40:33 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lX46Z-00C9z1-5C; Thu, 15 Apr 2021 17:40:31 +0200
Message-ID: <60b03f0cc20aa72dd6c6e94bfe2253bd3d21037f.camel@sipsolutions.net>
Subject: Re: Adding a fifth edca tx queue
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Johannes Behrens <johannes.behrens@st.ovgu.de>,
        linux-wireless@vger.kernel.org
Date:   Thu, 15 Apr 2021 17:40:30 +0200
In-Reply-To: <fae3f300-8e04-d9ec-8e22-a401aaa6f70a@st.ovgu.de> (sfid-20210415_161635_690528_BEE8E641)
References: <fae3f300-8e04-d9ec-8e22-a401aaa6f70a@st.ovgu.de>
         (sfid-20210415_161635_690528_BEE8E641)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2021-04-15 at 18:07 +0200, Johannes Behrens wrote:
> Hi,
> currently I am planning to implement a fifth edca tx-queue in the kernel
> for research purposes for special requirements on the tactile internet.
> 
> Now I am facing the challenge that I cannot find any actual hardware on
> which I can implement another queue. Do you have any tips for me there?

I doubt you'll have much luck with this, but do you really need all 5?
You could do a lot of experimentation by just changing the EDCA
parameters of e.g. the mostly unused VO or BK queues.

johannes

