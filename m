Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D9DC64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B44812087D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 07:58:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B44812087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbeJIPOC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 11:14:02 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45326 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbeJIPOB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 11:14:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9muK-0007Ke-Pv; Tue, 09 Oct 2018 09:58:20 +0200
Message-ID: <1539071890.3687.88.camel@sipsolutions.net>
Subject: Re: [PATCH iw] iw: fix enum warnings
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Brian Norris <briannorris@chromium.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 09 Oct 2018 09:58:10 +0200
In-Reply-To: <20181008175126.82965-1-briannorris@chromium.org> (sfid-20181008_195139_275178_FCC6BE18)
References: <20181008175126.82965-1-briannorris@chromium.org>
         (sfid-20181008_195139_275178_FCC6BE18)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-10-08 at 10:51 -0700, Brian Norris wrote:
> clang warns about the misuse of enums:
> 
> reg.c:246:26: warning: implicit conversion from enumeration type 'enum command_identify_by' to different enumeration type 'enum id_input' [-Wenum-conversion]
>         err = handle_cmd(state, CIB_NONE, 2, dump_args);
>               ~~~~~~~~~~        ^~~~~~~~
> info.c:645:26: warning: implicit conversion from enumeration type 'enum command_identify_by' to different enumeration type 'enum id_input' [-Wenum-conversion]
>         err = handle_cmd(state, CIB_NONE, 2, feat_args);
>               ~~~~~~~~~~        ^~~~~~~~

Applied, thanks.

johannes
