Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED5BC77B76
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Apr 2023 12:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjDNMWo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Apr 2023 08:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjDNMWl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2023 08:22:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB0AB44C
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2023 05:22:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E9E60B40
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2023 12:22:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8FAC433EF;
        Fri, 14 Apr 2023 12:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681474957;
        bh=wFxs7nX1/NzmfvsB691Vy6NQgHZJcexK7R9WQseiulk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Zq2XE2pzlNPPT+msiK4EWYhgz2o9PfLivFhGl0aV3PxjwsCmGSgxPlWMQTCvJIy9c
         fjnrImJ7EaOG5vOtKH9kWt8cjh8WBQytAlHO8qdwldFTbeROiXGGLZ4pe3MicwQnhv
         DCSI9hPqUfIub0pK2ifLZP/gBbf53H819DxdOH9iPuGlDtvuACGaTdgOuSIyyzvlfo
         LSZaNydvIZeP3oydhYnRiYQK6SOhy0S2Lvjcx16XD2JqehmQWU/LDdevmh/GCTVAVS
         Xtt8jLLnkOymu6qKEQlxAfI9bqaWGgg5sAY4I0GJ2E7boTbuyPTIa3/w7ZVS+vld8k
         F9/jAHQ6Yg1bg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: rtw89: support parameter tables by RFE type
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230330080331.37155-1-pkshih@realtek.com>
References: <20230330080331.37155-1-pkshih@realtek.com>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     <kevin_yang@realtek.com>, <linux-wireless@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168147495263.16522.11700992716819261769.kvalo@kernel.org>
Date:   Fri, 14 Apr 2023 12:22:36 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Zong-Zhe Yang <kevin_yang@realtek.com>
> 
> One chip can have different RFE (RF front end) types which we will judge
> at runtime. And, different RFE types may use different RF parameter tables.
> Though we didn't really meet this case previously, we are going to meet it
> on upcoming chip RTL8851B. So, this commit handles parameter tables for
> runtime RFE type.
> 
> We now encapsulate rtw89_txpwr_rule_<2/5/6>ghz tables into rtw89_rfe_parms.
> Then, each chip defines its default parameter tables, and if needed, it can
> configure extra parameter tables by RFE type. Finally we determine runtime
> parameter tables by RFE type if one is configured. Otherwise, we use the
> default parameter tables.
> 
> For now, we just move all settings under default parameter tables. We will
> configure parameter tables by RFE types in separate commits afterwards.
> 
> Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

5395482afabb wifi: rtw89: support parameter tables by RFE type

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230330080331.37155-1-pkshih@realtek.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

