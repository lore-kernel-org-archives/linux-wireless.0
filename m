Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAAA7C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:12:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBB9E20841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 14:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBB9E20841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbeJHVYX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 17:24:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56358 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbeJHVYX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 17:24:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9WGh-0007pc-1A; Mon, 08 Oct 2018 16:12:19 +0200
Message-ID: <1539007928.3687.49.camel@sipsolutions.net>
Subject: Re: [RFC v3 02/12] rtw88: core files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Date:   Mon, 08 Oct 2018 16:12:08 +0200
In-Reply-To: <1538565659-29530-3-git-send-email-yhchuang@realtek.com> (sfid-20181003_132138_423244_A2698272)
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-3-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132138_423244_A2698272)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-03 at 19:20 +0800, yhchuang@realtek.com wrote:

If you use bitmaps for the security CAM index tracking,

this:

> +u32 rtw_sec_installed_cam_num(struct rtw_sec_desc *sec)
> +{
> +	u32 cnt = 0;
> +	int i;
> +
> +	for (i = 0; i < sec->total_cam_num; i++)
> +		if (sec->cam_table[i].used)
> +			cnt++;
> +
> +	return cnt;
> +}

becomes hweight(), and this:

> +int rtw_sec_get_free_cam(struct rtw_sec_desc *sec)
> +{
> +	int i;
> +
> +	/* if default key search is enabled, the first 4 cam entries
> +	 * are used to direct map to group key with its key->key_idx, so
> +	 * driver should use cam entries after 4 to install pairwise key
> +	 */
> +	i = sec->default_key_search ? RTW_SEC_DEFAULT_KEY_NUM : 0;
> +	for (; i < sec->total_cam_num; i++)
> +		if (!sec->cam_table[i].used)
> +			return i;
> +
> +	return i;
> +}

just find_next_zero_bit().

Your code hard-codes an assumption that default_key_search is true
though, afaict, so you can probably just remove that.

johannes
