Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BFBFC433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 16:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1DFB64DF6
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Feb 2021 16:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbhBJQ4A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Feb 2021 11:56:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232930AbhBJQyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Feb 2021 11:54:04 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B86BD64DDF;
        Wed, 10 Feb 2021 16:53:23 +0000 (UTC)
Date:   Wed, 10 Feb 2021 11:53:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     Brian Norris <briannorris@chromium.org>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: change len of trace_ath10k_log_dbg_dump for
 large buffer size
Message-ID: <20210210115322.0b65a856@gandalf.local.home>
In-Reply-To: <20210210114823.1408dd64@gandalf.local.home>
References: <1612839593-2308-1-git-send-email-wgong@codeaurora.org>
        <CA+ASDXN1V2HYA7C6s-q5bQNSxE7L5GCJiqfiJ_67R_hpUn4b_g@mail.gmail.com>
        <20210209145531.5977b16d@gandalf.local.home>
        <20210209163431.11133472@gandalf.local.home>
        <9b479a88331dbf969f07708eabe53d14@codeaurora.org>
        <20210210113026.5f5ebe8a@gandalf.local.home>
        <20210210114823.1408dd64@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 10 Feb 2021 11:48:23 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 10 Feb 2021 11:30:26 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Can you test this patch?  
> 
> v2:

Bah!

v3:

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b79bcacdd6f9..90d7ade03499 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2739,7 +2739,7 @@ trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
 	    (entry = this_cpu_read(trace_buffered_event))) {
 		/* Try to use the per cpu buffer first */
 		val = this_cpu_inc_return(trace_buffered_event_cnt);
-		if (val == 1) {
+		if ((len < (PAGE_SIZE - sizeof(*entry))) && val == 1) {
 			trace_event_setup(entry, type, trace_ctx);
 			entry->array[0] = len;
 			return entry;
