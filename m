Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D0EEC433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 23 May 2022 14:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbiEWOUr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 May 2022 10:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiEWOUp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 May 2022 10:20:45 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAA25A17E;
        Mon, 23 May 2022 07:20:43 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:36252)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nt8vI-00ATIA-DK; Mon, 23 May 2022 08:20:40 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:39108 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nt8vG-0041Du-0k; Mon, 23 May 2022 08:20:39 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, rafael@kernel.org
In-Reply-To: <20220523052810.24767-1-duoming@zju.edu.cn> (Duoming Zhou's
        message of "Mon, 23 May 2022 13:28:10 +0800")
References: <20220523052810.24767-1-duoming@zju.edu.cn>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
Date:   Mon, 23 May 2022 09:20:28 -0500
Message-ID: <87o7zoxrdf.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nt8vG-0041Du-0k;;;mid=<87o7zoxrdf.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX19XL6dIVUh4Rgjy70dRTrylgdC8ofaP27Q=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by
 dev_coredumpv
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Duoming Zhou <duoming@zju.edu.cn> writes:

> There are sleep in atomic context bugs when uploading device dump
> data in mwifiex. The root cause is that dev_coredumpv could not
> be used in atomic contexts, because it calls dev_set_name which
> include operations that may sleep. The call tree shows execution
> paths that could lead to bugs:
>
>    (Interrupt context)
> fw_dump_timer_fn
>   mwifiex_upload_device_dump
>     dev_coredumpv(..., GFP_KERNEL)
>       dev_coredumpm()
>         kzalloc(sizeof(*devcd), gfp); //may sleep
>         dev_set_name
>           kobject_set_name_vargs
>             kvasprintf_const(GFP_KERNEL, ...); //may sleep
>             kstrdup(s, GFP_KERNEL); //may sleep
>
> In order to let dev_coredumpv support atomic contexts, this patch
> changes the gfp_t parameter of kvasprintf_const and kstrdup in
> kobject_set_name_vargs from GFP_KERNEL to GFP_ATOMIC. What's more,
> In order to mitigate bug, this patch changes the gfp_t parameter
> of dev_coredumpv from GFP_KERNEL to GFP_ATOMIC.

vmalloc in atomic context?

Not only does dev_coredumpm set a device name dev_coredumpm creates an
entire device to hold the device dump.

My sense is that either dev_coredumpm needs to be rebuilt on a
completely different principle that does not need a device to hold the
coredump (so that it can be called from interrupt context) or that
dev_coredumpm should never be called in an context that can not sleep.


Looking at fw_dump_timer_fn the only purpose of the timer is to trigger
a device dump after a certain amount of time.  So I suspect all that is
needed to fix this issue is to change the type of devdump_timer to
struct delayed_work and use scheduled_delayed_work instead of mod_timer.


Eric

p.s.  I looked at this because there was coredump in the infrastructure
name, and I do some of the work to keep coredumps working.  Device dump
seems like a much better term, and I wished the designer of the api had
used that instead.



