Return-Path: <SRS0=WqAe=ZU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ECBEC432C0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 03:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B3D02154A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Nov 2019 03:54:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfK1DyY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 22:54:24 -0500
Received: from smtprelay0023.hostedemail.com ([216.40.44.23]:45784 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726695AbfK1DyY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 22:54:24 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id D0883180A8128;
        Thu, 28 Nov 2019 03:54:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cord05_261e104f2dd33
X-Filterd-Recvd-Size: 1920
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf09.hostedemail.com (Postfix) with ESMTPA;
        Thu, 28 Nov 2019 03:54:21 +0000 (UTC)
Message-ID: <d02f4eef9aa674cb36c1d90069a13e7bd02b7e40.camel@perches.com>
Subject: Re: [PATCH RESEND] wireless: Use offsetof instead of custom macro.
From:   Joe Perches <joe@perches.com>
To:     Pi-Hsun Shih <pihsun@chromium.org>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:CLANG/LLVM BUILD SUPPORT" 
        <clang-built-linux@googlegroups.com>
Date:   Wed, 27 Nov 2019 19:53:55 -0800
In-Reply-To: <20191128033959.87715-1-pihsun@chromium.org>
References: <20191128033959.87715-1-pihsun@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-11-28 at 11:39 +0800, Pi-Hsun Shih wrote:
> Use offsetof to calculate offset of a field to take advantage of
> compiler built-in version when possible, and avoid UBSAN warning when
> compiling with Clang:
[]
> diff --git a/include/uapi/linux/wireless.h b/include/uapi/linux/wireless.h
[]
> @@ -1090,8 +1090,7 @@ struct iw_event {
>  /* iw_point events are special. First, the payload (extra data) come at
>   * the end of the event, so they are bigger than IW_EV_POINT_LEN. Second,
>   * we omit the pointer, so start at an offset. */
> -#define IW_EV_POINT_OFF (((char *) &(((struct iw_point *) NULL)->length)) - \
> -			  (char *) NULL)
> +#define IW_EV_POINT_OFF offsetof(struct iw_point, length)
>  #define IW_EV_POINT_LEN	(IW_EV_LCP_LEN + sizeof(struct iw_point) - \
>  			 IW_EV_POINT_OFF)

This is uapi.  Is offsetof guaranteed to be available?

Perhaps this is better without using another macro

#define IW_EV_POINT_OFF	((size_t)&((struct iw_point *)NULL)->length)

