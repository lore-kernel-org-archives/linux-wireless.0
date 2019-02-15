Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A95C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8D65217F5
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:45:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730360AbfBOKp2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:45:28 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38040 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729841AbfBOKp2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:45:28 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1guazm-0004PC-Or; Fri, 15 Feb 2019 11:45:26 +0100
Message-ID: <a6fd97757fe5254b60556035da5ffcc42e539c38.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] cfg80211: add support to probe unexercised mesh link
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, kevinhayes@google.com,
        julanhsu@google.com
Date:   Fri, 15 Feb 2019 11:45:25 +0100
In-Reply-To: <1550152570-13051-2-git-send-email-rmanohar@codeaurora.org>
References: <1550152570-13051-1-git-send-email-rmanohar@codeaurora.org>
         <1550152570-13051-2-git-send-email-rmanohar@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> + * @NL80211_CMD_PROBE_MESH_LINK: The requirement for mesh link metric
> + *	refreshing, is that from one mesh point we be able to send some data
> + *	frames to other mesh points which are not currently selected as a
> + *	primary traffic path, but which are only 1 hop away. The absence of
> + *	the primary path to the chosen node makes it necessary to apply some
> + *	form of marking on a chosen packet stream so that the packets can be
> + *	properly steered to the selected node for testing, and not by the
> + *	regular mesh path lookup. Further, the packets must be of type data
> + *	so that the rate control (often embedded in firmware) is used for
> + *	rate selection.
> + *
> + *	Uses %NL80211_ATTR_MAC and %NL80211_ATTR_FRAME attributes. The frame
> + *	content here is ethernet data.

Please document the address requirements as well.

johannes

