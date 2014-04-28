Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:41161 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932358AbaD1QcK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 12:32:10 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so5975245pab.41
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 09:32:09 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: "Michal Kazior" <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [v4 13/13] mac80211: implement multi-vif in-place reservations
In-Reply-To: <1397050174-26121-14-git-send-email-michal.kazior@tieto.com>
Date: Tue, 29 Apr 2014 00:32:01 +0800
Message-ID: <87lhupo1oe.fsf@gmail.com> (sfid-20140428_183215_736997_7E0431A7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Michal,

+	kfree_rcu(ctx, rcu_head);
+
+	list_for_each_entry(sdata, &ctx->reserved_vifs,
+			    reserved_chanctx_list) {

I'm not very familiar with rcu, but this doesn't seems right ?

I noticed it when rebasing my recalc refactoring code on your patches. :-)
