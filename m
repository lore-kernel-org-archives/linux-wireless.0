Return-Path: <SRS0=l33s=O6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC20C43387
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 11:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8446218FD
	for <linux-wireless@archiver.kernel.org>; Fri, 21 Dec 2018 11:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731691AbeLULTg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 21 Dec 2018 06:19:36 -0500
Received: from smtprelay0119.hostedemail.com ([216.40.44.119]:53516 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730624AbeLULTg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Dec 2018 06:19:36 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id E435D8368F00;
        Fri, 21 Dec 2018 11:19:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: drug08_191996814fd62
X-Filterd-Recvd-Size: 2002
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Fri, 21 Dec 2018 11:19:32 +0000 (UTC)
Message-ID: <b0b97478f9b2b9b12ad7bc04a1eb0af3bad6c5f3.camel@perches.com>
Subject: Re: [PATCH v2 1/3] rt2x00: use ratelimited variants dev_warn/dev_err
From:   Joe Perches <joe@perches.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc:     Randy Oostdyk <linux-kernel@oostdyk.com>,
        Tomislav =?UTF-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Date:   Fri, 21 Dec 2018 03:19:31 -0800
In-Reply-To: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-12-20 at 16:16 +0100, Stanislaw Gruszka wrote:
> As reported by Randy we can overwhelm logs on some USB error conditions.
> To avoid that use dev_warn_ratelimited() and dev_err_ratelimitd().
> 
> Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2x00.h | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
[]
> @@ -65,14 +65,19 @@
>  /* Utility printing macros
>   * rt2x00_probe_err is for messages when rt2x00_dev is uninitialized
>   */
> +#define wiphy_err_ratelimited(wiphy, format, args...)		\
> +	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
> +#define wiphy_warn_ratelimited(wiphy, format, args...)		\
> +	dev_warn_ratelimited(&(wiphy)->dev, format, ##args)
> +

These should probably be generic in include/net/cfg80211.h


