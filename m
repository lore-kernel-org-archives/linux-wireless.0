Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 790C2E7C4E3
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Oct 2023 16:34:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243391AbjJDQeV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Oct 2023 12:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243290AbjJDQeV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2023 12:34:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5D29B;
        Wed,  4 Oct 2023 09:34:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4510CC433C7;
        Wed,  4 Oct 2023 16:34:17 +0000 (UTC)
Date:   Wed, 4 Oct 2023 12:35:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] tracing: improve symbolic printing
Message-ID: <20231004123524.27feeae7@gandalf.local.home>
In-Reply-To: <20231004092205.02c8eb0b@kernel.org>
References: <20230921085129.261556-5-johannes@sipsolutions.net>
        <20231004092205.02c8eb0b@kernel.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 4 Oct 2023 09:22:05 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> Potentially naive question - the trace point holds enum skb_drop_reason.
> The user space can get the names from BTF. Can we not teach user space
> to generically look up names of enums in BTF?

That puts a hard requirement to include BTF in builds where it was not
needed before. I really do not want to build with BTF just to get access to
these symbols. And since this is used by the embedded world, and BTF is
extremely bloated, the short answer is "No".

-- Steve
